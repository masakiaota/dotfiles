# Isolated worker protocol

## Build the worker brief

Create a self-contained brief containing:

1. the objective, relevant background, and task-local inputs, paths, and constraints;
2. whether files may be changed, the worker's ownership, and required validation;
3. the expected response shape and language.

Include the background and purpose the worker needs, no more and no less. State that the worker must not spawn subagents, launch another Codex process, or otherwise redelegate. Do not paste irrelevant conversation or use dangling references. Preserve task-specific output contracts.

## Run the worker

Pass the brief through stdin to the wrapper, using the model and effort selected from `model-routing.md`:

```sh
printf '%s\n' "$worker_brief" | \
  /bin/sh "<skill-dir>/scripts/delegate_worker.sh" \
    --model <selected-model> \
    --effort <selected-effort> \
    --cwd /absolute/path/to/workspace
```

Add `--load-user-config` only when the task needs a user-configured MCP server, provider, hook, or other setting. Add `--allow-non-git` only when intentionally targeting a trusted non-repository directory.

## Continue a worker when needed

Use persistence only when follow-up turns with the same worker are expected. Start it with `--persist --session-id-file <path>`, then resume the exact saved ID with `--resume <id>`; do not use `--resume --last`. On resume, omit `--model` and `--effort` unless intentionally changing them, and repeat `--load-user-config` or `--allow-non-git` when previously required.

## Integrate the result

Treat the response as evidence, not authority. Verify important claims against referenced files, commands, tests, or primary sources. Retry at most once when a tighter brief, supported model, or higher effort is likely to address a specific failure; otherwise continue in the parent or report the limitation.
