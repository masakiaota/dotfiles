---
name: gh-autonomous-pr-review
description: Autonomously handle unresolved GitHub PR review threads for the open pull request on the current branch. Use when Codex needs to read only unresolved review comments, decide whether to apply a fix, reject the suggestion, or ask for clarification, and then reply to each thread with the reasoning behind the decision.
---

# GH Autonomous PR Review

## Overview

Use this skill to process unresolved GitHub PR review threads end to end without asking the user to triage comments manually. Read unresolved threads, decide on the appropriate action, implement safe fixes when warranted, reply to each thread, and resolve only the threads that were actually addressed.

If you need a reference for PR lookup or review-thread pagination, inspect the sibling official skill at `../gh-address-comments/scripts/fetch_comments.py`. Do not edit that skill.

## Workflow

1. Run `gh auth status` and stop immediately if GitHub CLI is not authenticated.
2. Resolve the open PR for the current branch.
3. Run `scripts/fetch_unresolved_threads.py --json` with an available Python runner and inspect only unresolved review threads. `python` in examples is only a placeholder; use whatever works in the current environment, such as `python3`, `uv run python`, or a bundled Python executable.
4. Classify each thread into exactly one of these buckets:
   - `accept-and-fix`
   - `reject-with-reason`
   - `needs-user-input`
5. For `accept-and-fix`, make the code change and run the smallest useful verification.
6. Reply to every processed thread with a concise rationale.
7. Resolve only threads that are both:
   - actually addressed
   - not outdated
8. Return a final user report in thread order.

## Decision Rules

- Choose `accept-and-fix` when the comment points to a local, safe, technically correct change that does not alter product intent.
- Choose `needs-user-input` when the comment implies a product decision, a compatibility tradeoff, a broad refactor, or any behavior change that cannot be justified locally.
- Choose `reject-with-reason` when the suggestion is incorrect, already addressed, contradicted by project intent, or would make the code worse.
- If a thread is outdated, do not auto-resolve it. Reply if useful, then leave it unresolved unless the user explicitly asks otherwise.
- If there are zero unresolved threads, do not change code and do not post replies. Report that there was nothing to do.

## Reply Templates

Use short, direct replies. State the decision and the reason in the same reply.

- `accept-and-fix`
  - "対応した。<what changed>。理由は <why this change is correct> である。"
- `reject-with-reason`
  - "この指摘は今回は採用しない。理由は <why not> であり、現状の実装の方が <what it preserves> を満たすためである。"
- `needs-user-input`
  - "判断に必要な前提が不足している。<decision point> を確認したい。<single concrete question>?"

Keep replies to 2-4 sentences. Do not paste long diffs or long justifications into GitHub replies.

## Required Reporting Format

When reporting back to the user, summarize each thread in this order:

1. `指摘要約`
2. `判断`
3. `実施内容または非対応理由`
4. `返信内容`

Keep the summary thread-oriented. Do not collapse multiple review threads into one decision.

## Scripts

Use an available Python runner for these commands. `python` below is an example command name, not a requirement; on macOS this may need to be `python3`, and in some repositories `uv run python` or a bundled Python executable may be the correct choice.

- `python scripts/fetch_unresolved_threads.py --json`
  - Print unresolved review threads as machine-readable JSON.
- `python scripts/fetch_unresolved_threads.py --pretty`
  - Print a concise human-readable summary for inspection.
- `python scripts/reply_review_thread.py --thread-id <id> --body <text> [--dry-run]`
  - Reply to a single review thread.
- `python scripts/resolve_review_thread.py --thread-id <id> [--dry-run]`
  - Resolve a single review thread.

## Failure Handling

- If `gh` is unauthenticated, stop and tell the user to run `gh auth login`.
- If no open PR is associated with the current branch, stop and report that no PR was found.
- If GitHub API calls fail, surface the exact operation that failed and do not attempt partial mutation retries blindly.

## Shell-Safe Reply Text

When invoking `reply_review_thread.py` through a shell command, treat the reply body as
untrusted shell input. Do not interpolate it with `JSON.stringify`, double quotes, or an
unquoted heredoc: Markdown backticks, `$VAR`, and `$(...)` can be evaluated by the shell.

Use a POSIX single-quote helper and pass the result as the `--body` argument:

```javascript
function shellQuote(value) {
  return "'" + value.replaceAll("'", "'\"'\"'") + "'";
}

const cmd = `uv run python scripts/reply_review_thread.py \\
  --thread-id ${threadId} --body ${shellQuote(body)}`;
```

After every reply, inspect the returned JSON `body` and confirm that it exactly matches the
intended comment before resolving the thread. If it differs, post a correction before resolving.

### Preserve Comment Semantics Across Interpreters

A review reply passes through more than one interpreter: the shell, the GitHub API, and GitHub
Flavored Markdown. Before posting, identify characters whose meaning can change at any boundary
and use the target format's literal syntax. For Markdown, wrap code identifiers and literal
syntax in backticks; this includes names such as `**slots**`, `_private_name`, `*args`, `#tag`,
and brackets.

Treat the returned JSON as confirmation of stored source text only, not rendered appearance. If
the source has Markdown-sensitive text or the reply corrects a rendering issue, inspect it once
as Markdown before posting and verify the returned source text afterward. Do not resolve the
thread until the reply preserves the intended meaning at every boundary.
