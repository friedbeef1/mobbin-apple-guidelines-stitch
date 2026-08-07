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

## Returning-user product story contract

These documentation and interface cases describe the user-visible contract. The executable skill checker separately protects the underlying project identity, confirmation, recovery, and deduplication rules.

| Case | Required user-visible behavior |
| --- | --- |
| First use | Install once, then confirm this project’s preferences and separately approve or decline one pinned home. |
| Next-day return | Open the project’s pinned home and use an ordinary-language starter; the home launches a clean local task in the same project. |
| New product | Reuse the installed plugin, run setup in the new saved project, and keep its optional home and preferences separate. |
| Multiple products | Keep at most one approved home per participating project and never create a global home. |
| Project without setup | Create no home and no sidebar item. |
| Duplicate discovery | Reuse the matching same-project home, report extras for user cleanup, and create no known duplicate. |
| Task tools unavailable | Save only confirmed preferences, report that no home is ready, and provide the exact title, card, and manual create-and-pin steps. |

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

## Fresh-task installation and setup evidence — 2026-08-07

The corrective installation prompt was exercised in fresh ephemeral tasks on Codex CLI 0.146.1 with the installed public `design-arc@design-arc-marketplace` profile. The task prompt, environment, final output, and scoring criteria are recorded here so this evidence is not confused with the static workflow checker.

### Installation-routing RED

The first corrective prompt said to use the plugin marketplace and avoid skills.sh, but did not explicitly prohibit the built-in plugin-install control. In a fresh read-only task, Codex avoided the standalone registry but used the restricted built-in plugin-install control and failed because Design Arc is not in the permitted recommended-plugin list.

Scoring: RED because no terminal marketplace command ran and installation could not be verified, even though the skills-registry failure was avoided.

### Installation-routing GREEN

The revised public prompt explicitly directs Codex to use these terminal commands and not `request_plugin_install`:

```bash
codex plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch --ref main
codex plugin add design-arc@design-arc-marketplace
```

In a fresh ephemeral task with terminal access, Codex executed both terminal commands, verified `design-arc@design-arc-marketplace` as installed and enabled, avoided skills.sh and the built-in plugin-install control, and told the user to start a new task.

Scoring: GREEN because both canonical terminal commands ran successfully, the reported plugin ID and enabled state matched the CLI, no skills-registry refusal appeared, and the response gave the new-task boundary.

### Setup GREEN

A separate fresh read-only task invoked `$design-arc setup` with no Design Arc or legacy project preference present. It wrote no files and presented Benchmarks/Guidelines and Guided/Follow recommendation/Fully automatic independently, with the recommended choices identified.

Scoring: GREEN because the installed plugin skill loaded, setup preceded product work, both choices were independent, and no preference was written without confirmation.

These observations prove the tested Codex CLI 0.146.1 routing and setup behavior in the recorded environment. They do not prove that every future model, client, policy, or marketplace configuration will behave identically. The isolated CLI installation and mutation suites remain the deterministic regression evidence.

## Isolated 0.2.0 to 0.2.1 upgrade evidence — 2026-08-07

This is deterministic CLI integration evidence, separate from the static instruction contracts above and the qualitative agent scenarios. `scripts/test-plugin-upgrade.sh` uses only a temporary `CODEX_HOME`, an exact checkout of public commit `8e2318496d8e2dbc3c75e19ddde997b598188755`, and a temporary checkout of the current branch. It does not read or change the user's installed plugin profile.

The RED expectation installed Design Arc `0.2.0`, attempted `codex plugin marketplace upgrade design-arc-marketplace`, and required the installed state to expose `0.2.1`. On Codex CLI 0.146.1 it failed with the installed CLI's real local-source boundary: the exact-commit fixture was not configured as a Git marketplace, and the installed cache remained `0.2.0`.

The GREEN path uses the bounded fallback only when the post-refresh installed state is not `0.2.1`: remove the canonical plugin, remove its marketplace source, add the isolated current checkout, and reinstall `design-arc@design-arc-marketplace`. The smoke then proves that exactly one enabled `0.2.1` plugin and one branch-identical cached skill remain, a new task discovers that skill exactly once, the old `0.2.0` cache is removed, and a representative `.codex/design-arc.yaml` containing evidence, approval, and ready-home metadata is unchanged byte-for-byte.

This proves the tested local exact-baseline-to-branch upgrade and fallback behavior. It does not claim that the unpublished `0.2.1` is available from the public Git marketplace yet. After publication, a user should try marketplace refresh first and use the same remove/add fallback only if installed state still does not expose `0.2.1`.

## Actual Codex desktop project-home acceptance — 2026-08-07

This is actual Codex app task-tool evidence, not a static instruction check and not a qualitative agent scenario. The acceptance was explicitly bounded to two temporary project tasks, and every mutating call targeted only the recorded temporary thread IDs.

The read-only preflight called `codex_app__list_threads({limit: 50})` and found no pinned or unpinned Design Arc task in the visible task set. `codex_app__list_projects({})` supplied these two saved projects, neither of which had its canonical home title before creation:

| Saved project | Project ID | Canonical temporary title |
| --- | --- | --- |
| UI plugin | `e1feaaeb-59f2-4dc8-a6d7-cb5603606b59` | `Design Arc — UI plugin` |
| Testing FB Lanes | `c5384f95-2b8b-46fa-99ee-458010b0f638` | `Design Arc — Testing FB Lanes` |

The exercised app schemas were `codex_app__create_thread({target: {type: "project", projectId, environment: {type: "local"}}, prompt})`, `codex_app__wait_threads({targets: [{threadId, hostId}], timeoutMs: 60000})`, `codex_app__set_thread_title({threadId, title})`, `codex_app__set_thread_pinned({threadId, pinned})`, `codex_app__list_threads({limit: 50})`, and `codex_app__set_thread_archived({threadId, hostId: "local", archived: true})`. Creation supplied no model or thinking override.

Each initial prompt identified itself as Design Arc acceptance only and prohibited file inspection, edits, research, further task creation, and running Design Arc. It requested only a compact launchpad card and then a wait. Both tasks returned only that inert card: correct project name, installed status, sample Guidelines/Guided preferences, and five plain-language starters. Neither task performed a product audit or research, and neither wrote project files.

| Saved project | Temporary thread ID | Mutation and observed result |
| --- | --- | --- |
| UI plugin | `019fdbab-2a07-7590-b3d7-bd872698311f` | Titled once, pinned once, and listed once under the UI plugin project ID. |
| Testing FB Lanes | `019fdbab-2766-7092-90ad-55ad3c60b778` | Titled once, pinned once, and listed once under the Testing FB Lanes project ID. |

The first post-mutation list contained both pinned homes under distinct project IDs with a count of one for each. A separate later lookup from a fresh controller context rediscovered both with `onePerProject=true` and chose `reuse existing; create zero`. This demonstrates persistence across a later task-tool context and repeat discovery without duplication; it was not an application restart and is not presented as restart evidence.

Cleanup unpinned each recorded temporary thread and then archived it. Each tool result reported `{pinned: false}` followed by `{archived: true}`. A final visible-task list found `temporaryHomesStillPinned: 0`. This proves the fixtures are no longer pinned; it does not claim that archived task records were deleted from storage.

## Historical regression context

The 2026-08-04 standalone workflow sometimes requested a surface for inspection before explicitly establishing the intended outcome, and it did not consistently identify approval-mode provenance. That evidence predates the plugin consolidation and is retained only as historical motivation. It is not proof of current runtime behavior.
