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
3. Run `python scripts/fetch_unresolved_threads.py --json` and inspect only unresolved review threads.
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
