# Design Arc instruction-contract validation

## What the executable checks prove

The contract under validation is the embedded skill at `plugins/design-arc/skills/design-arc/SKILL.md`. `scripts/check-workflow-contracts.py` checks required clauses, and `scripts/test-workflow-contracts.py` mutates each clause to prove that missing or reversed behavior is rejected.

These are executable static instruction-contract guards; they do not execute an agent or prove runtime agent behavior. They protect the written contract against regression across setup, evidence selection, approval behavior, preference migration, objective handling, platform precedence, evidence integrity, and implementation boundaries.

Fresh-context scenario evidence is qualitative unless the prompt, environment, output, and scoring are stored reproducibly. The observations below are therefore reported separately from deterministic pass/fail results and are not presented as a runtime guarantee.

## Deterministic scenario matrix

Evidence and approval choices are independent, producing six supported combinations:

| Evidence | Approval | Required Direction behavior | Required Stitch behavior |
| --- | --- | --- | --- |
| Benchmarks | Guided | Stop for the user's selection | Stop after render validation |
| Benchmarks | Follow recommendation | Continue with the visible marked recommendation | Stop after render validation |
| Benchmarks | Fully automatic | Continue with the visible marked recommendation | Continue only on `meets direction` |
| Guidelines | Guided | Stop for the user's selection | Stop after render validation |
| Guidelines | Follow recommendation | Continue with the visible marked recommendation | Stop after render validation |
| Guidelines | Fully automatic | Continue with the visible marked recommendation | Continue only on `meets direction` |

Every combination also retains setup-before-inspection, objective handling, current-journey audit, current first-party validation, complete-state coverage, render critique, evidence integrity, and the design-only handoff boundary.

## Contract cases

| Case | Project state and request | Required instruction behavior |
| --- | --- | --- |
| First use | No `.codex/design-arc.yaml`; `$design-arc setup` | Ask for evidence and approval choices independently, show proposed values, confirm before saving, and report first-use provenance for both. |
| Saved values | Saved Benchmarks + Guided; no override | Use both saved values, report saved-preference provenance for each, and preserve Objective Confirmation and both gates. |
| Independent overrides | Saved Benchmarks + Fully automatic; request says `use Guidelines and Guided for this run` | Apply both current-request overrides independently, do not rewrite the saved file, perform no benchmark lookup, and stop at Objective Confirmation. |
| One-run benchmark fallback | Saved Benchmarks; access is unavailable | Stop and offer a one-run Guidelines fallback or confirmed saved switch. A one-run fallback preserves the saved Benchmarks value and makes no benchmark claim. |
| Benchmark quality | Authorized Benchmarks run | Inspect complete relevant journeys and explain why each pattern helps the confirmed objective; reject library presence, metadata, popularity, or one screenshot as best-in-class proof. |
| Guidelines isolation | Active Guidelines | Perform no benchmark lookup and make no benchmark-evidence claim. |
| Fully automatic objective | Active Fully automatic; current request states an explicit objective | The objective may be treated as established without a confirmation pause. Direction continues with the marked recommendation; Stitch continues only on `meets direction`. |
| Missing objective | Active Fully automatic; `Redesign this onboarding.` | Stop before product inspection, research, or generation and ask for an objective. Do not invent it. |
| Android/web precedence | Objective concerns Android or web | Apply current Android or web first-party rules over conflicting Apple-inspired judgment. |
| Legacy FB UX import | New preference absent; only `.codex/fb-ux.yaml` exists | Show Benchmarks + provider `mobbin` + preserved approval mapping and ask once before writing the new file. Leave the old file untouched. |
| Legacy Apple-led import | New preference absent; only `.codex/apple-guidelines-stitch.yaml` exists | Show Guidelines + preserved approval mapping and ask once before writing the new file. Leave the old file untouched. |
| Dual legacy conflict | New preference absent; both old files exist | Present both mappings and require the user to choose one or start fresh; never merge automatically. |
| Direction evidence | Any approval mode | Present one unmistakably marked recommendation plus meaningful alternatives, evidence, risks, and trade-offs. Automatic selection remains visible. |
| Authorization boundary | Any gate passes | Authorize only a coordinated design handoff, never source implementation, staging, deployment, release, destructive/provider changes, or work outside the authorized lane. |

## Mutation coverage

The mutation suite removes or reverses each load-bearing clause, including:

- all setup, evidence, and mode commands;
- resolution precedence and independent provenance;
- all six evidence/approval combinations;
- benchmark quality, Guidelines isolation, unavailable access, and one-run fallback;
- both legacy mappings, confirmation, dual-file conflict, and file preservation;
- Guided/Follow objective confirmation and Fully automatic's explicit-objective rule;
- Direction and Stitch gate verdict behavior;
- Android/web first-party precedence;
- evidence claims and implementation/release ownership.

A passing mutation run means the checker rejected every weakened fixture. It does not mean an agent executed an end-to-end product journey.

## Fresh-context observations

During consolidation, fresh agents were shown either the old two-plugin instructions or the new Design Arc skill.

The old instructions could infer several safe behaviors, including objective protection and gate boundaries, but had no canonical single preference, independent evidence/approval provenance, or import contract. With Design Arc, representative scenarios resolved first-use choices independently, preserved saved settings under one-run overrides, offered explicit fallback choices when benchmark access was missing, isolated Guidelines from benchmark claims, and preserved the Fully automatic verdict and authorization boundaries.

These observations are qualitative. They document what was seen during implementation, while the deterministic checker and mutation suite remain the reproducible repository evidence.

## Historical regression context

The 2026-08-04 standalone workflow sometimes requested a surface for inspection before explicitly establishing the intended outcome, and it did not consistently identify approval-mode provenance. That evidence predates the plugin consolidation and is retained only as historical motivation. It is not proof of current runtime behavior.
