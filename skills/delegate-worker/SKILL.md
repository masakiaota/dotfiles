---
name: delegate-worker
description: Decide how to handle delegated work among the parent agent, native Codex subagents, and isolated codex exec workers, then launch an isolated worker only when selected. Use whenever the user mentions or requests subagents (サブエージェント), delegation or offloading (委任・移譲), parallel agents, workers, isolated execution, or codex exec, asks how work should be delegated, or explicitly invokes $delegate-worker. First choose the execution surface; do not assume an isolated worker is appropriate.
---

# Delegate Worker

Launch one bounded worker through `codex exec`. Pass only task-local context, prohibit recursive delegation, and verify the returned result before integrating it.

## Choose the execution surface

Honor the user's explicit choice. Otherwise:

- Keep work in the parent when it depends on ongoing decisions, frequent coordination, or would be faster to perform directly.
- Use a native Codex subagent when the work needs parent context but can run independently, the same model and effort are suitable, and Codex should manage steering, waiting, and result collection.
- Use this skill when the task is self-contained and fresh context, different model or effort, configuration isolation, or rate savings matter more than integrated orchestration.

When both delegation paths fit, prefer the native subagent for context fidelity and automatic integration; prefer this skill for isolation and execution-setting control. Do not delegate unclear, trivial, high-impact external, secret-handling, or conflicting write tasks.

## Select the model and reasoning effort

Read [references/model-routing.md](references/model-routing.md) before choosing settings. Honor an explicit user selection first. Otherwise classify the task and select the narrowest sufficient model and effort from that routing guide.

If no route clearly applies, use `gpt-5.6-luna` with `xhigh` reasoning. Never select `ultra`, because it can automatically create subagents and conflicts with this skill's no-recursive-delegation rule. Use `max` as the ceiling.

## Select permissions and configuration

The wrapper uses the fixed permission profile `workspace-write`, `approval_policy="on-request"`, and `approvals_reviewer="auto_review"`, equivalent to **Approve for me**. It does not expose a sandbox override and never uses `danger-full-access`. For a non-editing task, explicitly tell the worker not to modify files. Avoid concurrent parent and worker edits to the same files. If workspace policy does not permit automatic review, surface the failure rather than weakening the policy.

Ignore `$CODEX_HOME/config.toml` by default to prevent unrelated model defaults, MCP servers, hooks, plugins, or permission settings from changing the worker. This does not disable authentication or `AGENTS.md`; global and project `AGENTS.md` guidance remains available through Codex's separate instruction-loading mechanism. Add `--load-user-config` only when the task needs a user-configured MCP server, provider, hook, or other setting.

## Build the worker brief

Create a compact, self-contained task containing:

1. the exact objective;
2. only relevant paths, facts, inputs, and constraints;
3. an explicit instruction not to assume the parent conversation or any unstated context;
4. an explicit instruction not to spawn subagents, launch another Codex process, or recursively delegate;
5. whether files may be changed and the required validation;
6. the expected response shape and language.

Do not paste the full conversation or use references such as "the change discussed above." The task-specific output contract has highest priority: do not add generic reporting requirements that conflict with JSON-only, exact-text, or other strict formats. The wrapper forwards the brief without adding or rewriting prompt text, so the parent must include every required constraint in the brief itself.

## Start a fresh worker

Run `scripts/delegate_worker.sh` relative to this skill directory. Pass the task through stdin:

```sh
printf '%s\n' "$worker_brief" | \
  <skill-dir>/scripts/delegate_worker.sh \
    --model gpt-5.6-luna \
    --effort xhigh \
    --cwd /absolute/path/to/workspace
```

Fresh workers are ephemeral by default. Add `--allow-non-git` only when intentionally targeting a trusted non-repository directory.

## Persist or resume a worker conversation

Use persistence only when the user expects follow-up turns with the same worker. Persistence retains the worker's own conversation; it still does not inherit the parent conversation.

Start a persistent worker and retain its session ID:

```sh
printf '%s\n' "$worker_brief" | \
  <skill-dir>/scripts/delegate_worker.sh \
    --persist \
    --session-id-file /absolute/path/to/session-id \
    --model gpt-5.6-sol \
    --effort xhigh \
    --cwd /absolute/path/to/repository
```

Continue that exact worker:

```sh
printf '%s\n' "$follow_up_brief" | \
  <skill-dir>/scripts/delegate_worker.sh \
    --resume "$(sed -n '1p' /absolute/path/to/session-id)"
```

When resuming, omit `--model` and `--effort` to preserve the session's prior selection. Specify them only when intentionally changing the model or effort. Do not use `--resume --last` because another Codex run may have become the newest session.

If the initial run used `--load-user-config`, pass it again on every resumed turn.

If the saved worker uses a non-Git directory, pass `--allow-non-git` on both the initial persistent run and every resumed turn.

## Integrate the result

Successful runs emit only the final worker message on stdout. Add `--verbose` when progress is needed; failures reveal captured diagnostics on stderr. `--verbose` cannot be combined with `--session-id-file` for a new persistent worker, but it may be used after resuming. Use `--output /absolute/path` when retaining the final message as an artifact is useful.

Treat the response as subordinate evidence. Verify important claims against referenced files, commands, tests, or primary sources. Retry at most once when a tighter brief, supported model, or higher effort is likely to address a specific failure. Otherwise continue in the parent or report the limitation. The child uses the same Codex authentication and rate pool; isolation does not create a separate quota.
