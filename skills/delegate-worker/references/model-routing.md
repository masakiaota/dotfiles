# Model routing

Choose the model from task shape, not from a fixed quality ladder. An explicit user choice wins. The defaults and examples below combine the user's preferred routing with current Codex guidance: Luna for clear repeatable work, Terra for everyday agentic work, and Sol for complex open-ended work.

## Primary routes

| Task shape | Model | Effort | Examples |
|---|---|---:|---|
| Locate implementation points, file paths, JSON schemas, CSV schemas, symbols, or configuration keys | `gpt-5.3-codex-spark` | `xhigh` | Find an endpoint implementation; locate the schema consumed by a job; identify all call sites |
| Narrow web research with a clear factual target | `gpt-5.6-luna` | `high` | Find the official usage of a library function; confirm an API parameter; locate an authoritative example |
| Low-complexity, isolated implementation | `gpt-5.6-luna` | `max` | Single-file change; independent helper; conversion between explicitly defined schemas |
| Clearly accepted implementation spanning files or carrying plausible side effects | `gpt-5.6-terra` | `max` | Feature touching handler, service, and tests; localized refactor with integration risk |
| Advanced algorithms, debugging hypothesis generation, meta-level review, intent interpretation, or difficult consultation | `gpt-5.6-sol` | `xhigh` | Algorithm design; intermittent bug hypotheses; architectural or adversarial review; ambiguous product intent |
| Same as above where errors are costly or the problem remains unresolved after an xhigh pass | `gpt-5.6-sol` | `max` | Security-critical reasoning; hardest root-cause analysis; final review of a high-risk design |

## Additional routes

| Task shape | Model | Effort | Examples |
|---|---|---:|---|
| High-volume extraction, classification, normalization, or structured summaries with exact output rules | `gpt-5.6-luna` | `medium` or `high` | Normalize records; classify logs; extract fields; produce repetitive summaries |
| Repetitive but precision-sensitive transformation | `gpt-5.6-luna` | `xhigh` | Mechanical migration from a documented pattern; generate fixtures from a schema; enforce a known format |
| Localized debugging with a reproduction and a bounded module | `gpt-5.6-terra` | `high` or `xhigh` | Explain a deterministic failure; trace a request through a known subsystem |
| Ordinary feature work requiring tool use and moderate judgment | `gpt-5.6-terra` | `xhigh` | Implement a conventional endpoint; update a small workflow with tests |
| Open-ended architecture, threat modeling, deep multi-source research, or polished decision material | `gpt-5.6-sol` | `xhigh` or `max` | Compare architectures; build a threat model; synthesize conflicting evidence; draft an ADR |

## Effort rules

- Use `medium` or `high` only when the task is deterministic enough that rate savings outweigh extra checking.
- Use `xhigh` as the default when no route clearly applies.
- Use `max` for the hardest single-agent tasks or when the selected route explicitly calls for it.
- Never use `ultra`; it may automatically delegate to subagents.
