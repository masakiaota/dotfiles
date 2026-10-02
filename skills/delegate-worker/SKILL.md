---
name: delegate-worker
description: Plan and coordinate delegated work across the parent agent, native Codex subagents, and isolated codex exec workers, and launch isolated workers when selected. Use whenever the user mentions or requests subagents (サブエージェント), delegation or offloading (委任・移譲), parallel agents, workers, isolated execution, or codex exec, asks how work should be divided or delegated, or explicitly invokes $delegate-worker.
---

# Delegate Worker

Plan delegated work across the parent agent, native Codex subagents, and isolated `codex exec` workers. Keep the parent responsible for coordination, verification, and integration.

## Choose the model and effort

Before delegating, read [references/model-routing.md](references/model-routing.md). Apply the same selection rules to native subagents and `codex exec` workers. Explicitly select the model and effort for each work item rather than inheriting the parent's settings for unrelated work.

## Route delegated work

Honor the user's explicit choice. Otherwise, delegate only when useful and choose an execution surface for each work item:

- Keep work in the parent when it requires ongoing decisions or close integration.
- Prefer a native Codex subagent for ordinary delegated work. Use the available tool schema to select the model, effort, and context inheritance. If a context-inheritance mode forces the parent's model, choose a mode that permits the selected model and provide a self-contained brief.
- Use an isolated `codex exec` worker when a separate process or configuration is needed, or when native tools cannot express the selected settings. A separate conversation does not isolate workspace files.

Choose per work item, not once per request. Combine native subagents and `codex exec` workers within the runtime's concurrency limits. Run them concurrently when their work is independent and non-conflicting; sequence dependencies and overlapping writes. Moving work out of the parent reduces intermediate context there, but does not guarantee lower total token usage.

Keep delegation one level deep. Tell every delegated agent not to spawn subagents, launch another Codex process, or otherwise redelegate.

Do not delegate when the objective or ownership is unclear, coordination cost outweighs the benefit, or the work involves secrets or high-impact external actions.

## Run isolated workers

Only when an isolated worker is selected, follow [references/worker-protocol.md](references/worker-protocol.md) to prepare, run, and integrate it.
