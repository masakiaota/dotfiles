# Model routing

Use this selection table for both native Codex subagents and `codex exec` workers. An explicit user choice wins. Otherwise, choose from these three models; if no route clearly applies, use `gpt-6.1-sol` with `xhigh` reasoning. Adjust the model and effort to the task's scope and difficulty.

| Model | Role | Task and effort |
|---|---|---|
| `gpt-6-astra` | Difficult judgment, intent interpretation, design, and high-risk review | `xhigh` for advanced algorithms, debugging hypothesis generation, ambiguous intent, architecture, threat modeling, or deep research; `max` when errors are costly or the problem remains unresolved after an xhigh pass |
| `gpt-6.1-sol` | Ordinary implementation and bounded debugging | `high` or `xhigh` for debugging with a reproduction and a bounded module; `xhigh` for ordinary feature work; `max` for accepted implementation spanning files or carrying plausible side effects |
| `gpt-5.6-luna` | Clear, bounded work with readily verifiable results | `medium` for locating files, schemas, symbols, configuration keys, or call sites; `high` for narrow factual research; `medium` or `high` for extraction, classification, normalization, or structured summaries; `xhigh` for precision-sensitive mechanical transformations; `max` for low-complexity isolated implementation |

Use Luna only when the inputs, ownership, and completion criteria are clear. Choose Sol when implementation still requires judgment; choose Astra when the objective, approach, or risk itself requires difficult judgment. Retain GPT-5.6 Luna based on the user's experience of its practical quality and sufficiently low cost.

## Effort rules

For delegated work, select a supported single-agent effort from `low`, `medium`, `high`, `xhigh`, and `max`. Check the model and effort supported by the current runtime; native tool argument names may differ from `codex exec --config model_reasoning_effort="..."`.

- Preserve the task-specific efforts above rather than lowering them solely because the model generation changed.
- Use `medium` or `high` only when the task is deterministic enough that savings outweigh extra checking.
- Use `max` when the selected route calls for it.
- Never use `ultra` for delegated agents; it may automatically delegate to subagents.

The three-model selection and effort table are the user's operating policy. For current availability and native configuration options, consult [OpenAI Models](https://learn.chatgpt.com/docs/models) and [Subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents).
