---
name: delegate-worker
description: Plan and coordinate delegated work across the parent agent, native Codex subagents, and isolated codex exec workers, and launch isolated workers when selected. Use whenever the user mentions or requests subagents (サブエージェント), delegation or offloading (委任・移譲), parallel agents, workers, isolated execution, or codex exec, asks how work should be divided or delegated, or explicitly invokes $delegate-worker.
---

# Delegate Worker

Plan delegated work across the parent agent, native Codex subagents, and isolated `codex exec` workers. Keep the parent responsible for coordination, verification, and integration.

## Route delegated work

Honor the user's explicit choice. Otherwise, delegate only when useful and choose an execution surface for each work item:

- Keep work in the parent when it requires ongoing decisions or close integration.
- Use a native Codex subagent when parent context, integrated orchestration, or an available specialization benefits the work.
- Use an isolated `codex exec` worker for self-contained work that benefits from fresh context or explicit control over execution settings, and for work where the parent needs only the result and wants to conserve context and tokens.

Choose per work item, not once per request. Use any number and combination of native Codex subagents and isolated `codex exec` workers. Run them concurrently when their work is independent and non-conflicting; sequence dependencies and overlapping writes.

Do not delegate when the objective or ownership is unclear, coordination cost outweighs the benefit, or the work involves secrets or high-impact external actions.

## Run isolated workers

Only when an isolated worker is selected, read [references/model-routing.md](references/model-routing.md) to choose its model and effort, then follow [references/worker-protocol.md](references/worker-protocol.md) to prepare, run, and integrate it.
