# Design Arc instruction-contract validation

## What the executable checks prove

The contract under validation is the embedded skill at `plugins/design-arc/skills/design-arc/SKILL.md`. `scripts/check-workflow-contracts.py` checks required clauses, and `scripts/test-workflow-contracts.py` mutates each clause to prove that missing or reversed behavior is rejected.

These are executable static instruction-contract guards; they do not execute an agent or prove runtime agent behavior. They protect the written contract against regression across setup, evidence selection, approval behavior, preference migration, objective handling, platform precedence, motion evidence and specification, evidence integrity, and implementation boundaries.

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

## Motion contract cases

The executable checker protects these twelve motion-methodology cases. Each row states an instruction contract, not a claim that an agent or shipped interface executed the behavior.

| Case | Required instruction behavior |
| --- | --- |
| 1. Evidence precedence | Resolve existing product motion, native platform behavior and standard components, current first-party guidance, inspected shipped-product motion, then labeled Design Arc judgment. |
| 2. Benchmark and static limits | Permit authorized shipped-product precedent in Benchmarks mode, while limiting static screens and sequences to states, changing elements, journey location, and intent rather than temporal mechanics. |
| 3. Playable evidence | Record source, journey, known frame rate, observed path and order, interruption and reversal, measurement method, confidence, missing states, and the estimated status of frame-derived values. |
| 4. Temporal labels | Give every temporal claim exactly one allowed observation, estimate, inference, judgment, or unverified label. |
| 5. Missing playback | Report the limitation, offer one of the allowed playable/default/proposal paths, and never invent unavailable motion. |
| 6. Guidelines isolation | Perform no benchmark lookup, make no real-product motion claim, and explicitly report that no benchmark motion was inspected. |
| 7. Complete contract | Require all named fields, define reproducible target/timing/easing/interruption/provenance/source/proof semantics, and use `unverified` for unsupported values. |
| 8. Motion+ boundary | Keep Motion+ outside Design Arc requirements, evidence, authority, and dependencies while allowing separately authorized implementation help across documentation, source retrieval, tuning, inspection, auditing, and design-system adaptation. |
| 9. Direction and restraint | Require each direction to explain purpose and restraint, evidence and guidance, provenance labels, reduced motion, risks, complexity, and remaining proof; headings alone do not pass. |
| 10. Prototype, proof, and authority | Make every Stitch verdict evaluate motion requirements and contract alignment, carry limitations and runtime proof forward, and preserve implementation, dependency, staging, deployment, and release ownership. |
| 11. Run record | Preserve scope, evidence, provenance, contracts, reduced motion, implementation source, proof, and remaining uncertainty. |
| 12. Fully automatic | Never let Fully automatic bypass motion evidence integrity. |

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
- all twelve motion-methodology cases, including semantic mutations for contract values, Direction explanations, Motion+ assistance, and Stitch verdict/automatic-gate behavior;
- evidence claims and implementation/release ownership.

The deterministic suite records 151 deterministic mutation rejections. Fourteen render-repair mutations prove that the written contract rejects unbounded retries, per-mismatch retrying, user-dependent ordinary corrections, uninspected correction claims, skipped reinspection, unsafe direction changes, runtime-proof retries, premature early stopping, missing exhaustion handling, unexplained `meets direction`, incomplete repair records, and approval-mode bypasses.

These are static instruction-contract mutations; they do not execute Stitch or prove that every future agent will follow the contract. A passing mutation run means the checker rejected every weakened fixture. It does not mean an agent executed an end-to-end product journey.

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

This proves the tested local exact-baseline-to-branch upgrade and fallback behavior. At the time of that run it did not claim that the then-unpublished `0.2.1` was available from the public Git marketplace. It is retained as historical `0.2.0`-to-`0.2.1` evidence, not as current installation guidance.

## Isolated 0.2.1 to 0.2.2 upgrade evidence — 2026-08-08

This is deterministic local CLI integration evidence, not a publication, remote-marketplace, real-profile, or product-runtime claim. `scripts/test-plugin-upgrade.sh` checks out immutable public `0.2.1` commit `c86240c67e1e9cae51bd6cc63a0f957d7fbca4a9`, clones the current `0.2.2` checkout, and runs Codex CLI 0.146.1 with a newly created temporary `CODEX_HOME`. The fixture creates two temporary participating projects only; it does not inspect or mutate the user's installed plugin, preferences, tasks, or projects.

The RED expectations changed the canonical identity, fresh-install, migration, and exact-baseline upgrade targets to `0.2.2` while the plugin manifest still reported `0.2.1`. They failed independently at the manifest identity, fresh install result, migration result, and target marketplace availability checks. Changing only the canonical manifest version to `0.2.2` made those same expectations pass.

The actual route first attempted `codex plugin marketplace upgrade design-arc-marketplace`. The isolated exact-commit source is local rather than a configured Git marketplace, so this installed CLI reported its local-marketplace boundary and left `0.2.1` installed. Before any removal, the fallback now fails closed unless the refreshed state contains exactly one installed and enabled canonical `0.2.1`, zero other available plugins, the exact parsed baseline marketplace and plugin source, one `0.2.1` cache, and a complete cached plugin tree equal by path, type, mode, and file bytes to immutable commit `c86240c…`. Missing, disabled, duplicate, unexpected-source, and cache-mismatch injections all stop before either removal command.

Only after that preflight passed did the tested route remove the one canonical plugin and marketplace, add the isolated current checkout, require exactly one parsed available `0.2.2` before installing it, and reinstall `design-arc@design-arc-marketplace`. The successful final validator reads the marketplace list and reports its parsed source; it does not infer the source from the shell's target variable. The same parser is used after either a refresh-success or fallback route. No network source or user profile was involved.

The fixture discovers both temporary `.codex/design-arc.yaml` files and snapshots every fixture file before and after. The preferences deliberately cover Benchmarks with `benchmark_provider: mobbin` and Follow recommendation, Guidelines with Guided, and distinct ready-home project and thread metadata. Separate product-file and active-review sentinels record two product states, two review thread identities, and a zero continuation count. The passing comparison proves those bytes and identities remained unchanged, with zero replacement homes and zero review continuations in the tested fixture.

The final isolated state contains exactly one enabled canonical plugin, one cached plugin manifest at `0.2.2`, one branch-identical complete plugin tree and cached `$design-arc` skill, no `0.2.1` cache, and no second available version. One new `codex debug prompt-input` task loads the cached Design Arc skill exactly once.

Rollback is exercised after injected failures at plugin removal, marketplace removal, target marketplace add, target availability read, invalid target availability, plugin install, final plugin-state read, final marketplace-state read, new-task prompt loading, and preservation validation. Each path restores and parses the immutable public marketplace source, requires exactly one enabled canonical `0.2.1`, exactly one cached manifest with public version and bytes, no stale `0.2.2` cache, a complete cached plugin tree equal by path, type, mode, and bytes to the immutable public tree, and the unchanged two-project inventory before it reports exact restoration.

This evidence proves only the local immutable-`0.2.1`-to-current-`0.2.2` path and its rollback behavior. It does not claim that `0.2.2` is published, remotely available, installed for the user, or exercised against real project or task state.

## Isolated 0.2.2 to 0.2.3 upgrade evidence — 2026-08-08

This is local deterministic evidence only; it is not publication, a real-profile upgrade, real Stitch execution, or product-runtime proof. `scripts/test-plugin-upgrade.sh` checks out immutable public 0.2.2 commit `1c9b3796e6f5f0648bae5984f1b8e3013eeac56f`, uses a temporary `CODEX_HOME`, and creates only a temporary two-project fixture. It does not inspect or mutate the user's installed plugin, preferences, tasks, or projects.

The RED identity, fresh-install, migration, and upgrade expectations required 0.2.3 while the unchanged canonical manifest still reported 0.2.2; each failed at the intended manifest-version boundary. The upgrade RED reached the immutable 0.2.2 baseline, rejected target availability, and restored the exact public package before reporting failure. Changing only `plugins/design-arc/.codex-plugin/plugin.json` to 0.2.3 made the same four focused release checks GREEN.

The normal `codex plugin marketplace upgrade design-arc-marketplace` attempt did not produce the 0.2.3 installed state from the local immutable source, so the observed route was `remove-add-fallback`. Before any removal, the immutable restoration preflight required exactly one enabled canonical 0.2.2 installation, zero other available plugins, the exact parsed baseline marketplace and plugin source, one complete byte-identical 0.2.2 cache, and unchanged two-project bytes. Five injected preflight cases—missing, disabled, duplicate, unexpected-source, and cache-mismatch—must stop before either removal command.

Only after that preflight passes may the fallback remove the canonical plugin and marketplace, add the isolated current checkout, require exactly one available 0.2.3 target, and reinstall `design-arc@design-arc-marketplace`. Injected failures preserve rollback coverage for plugin removal, marketplace removal, target marketplace add, target availability read and validation, plugin install, final state reads, prompt loading, and preservation validation; every restoration requires the immutable 0.2.2 package and unchanged project bytes.

The passing comparison preserved exactly two preferences, two ready homes, two product sentinels, and two active reviews byte-for-byte, created zero homes, and continued zero reviews. The fixture covers Benchmarks with `benchmark_provider: mobbin` and Follow recommendation, Guidelines with Guided, distinct ready-home project and thread metadata, two product-state files, and two active-review thread identities with zero continuation counts. The final isolated state contains exactly one enabled canonical 0.2.3 plugin and a complete branch-identical cache, no stale 0.2.2 cache, no second available version, and one new task that loads the cached `$design-arc` skill exactly once.

## Isolated 0.2.2 and 0.2.3 to 0.3.0 transition evidence — 2026-08-08

This is deterministic local package and instruction-contract evidence, not publication, a real-profile change, a real-project migration, or proof that an agent executed a review. The release checks were changed first while the manifest still reported 0.2.3. Identity failed because the manifest was not canonical 0.3.0; fresh install and two-plugin migration independently rejected the reported 0.2.3 package; and the upgrade reached immutable public 0.2.2, rejected target availability, then restored the exact 0.2.2 package and project bytes. Changing the manifest to 0.3.0 made the same four checks pass.

The upgrade harness runs twice with temporary checkouts, projects, and `CODEX_HOME` directories. One baseline is immutable public 0.2.2 commit `1c9b3796e6f5f0648bae5984f1b8e3013eeac56f`; the other is exact local 0.2.3 candidate commit `489988474dce4a4b0da7a5c48104e9d548c107bd`. Before removal, each fallback validates the exact baseline plugin identity, source, and complete cached tree. It then installs exactly one enabled 0.3.0 plugin whose complete cache equals the candidate package and proves the post-transition project snapshot equals the one captured before any plugin operation.

Each baseline fixture has two project preferences with no graph field, two ready project homes, two product sentinels, two valid `design-arc.graph/v1` records, and two active reviews pinned to the baseline workflow version. The before/after inventory hashes every project file. Both upgrades preserve every hash and identity, create zero homes, and leave both continuation counts at zero. The installed 0.3.0 skill is then checked from its cache with the deterministic workflow-contract validator: missing graph settings resolve active only for the next new 0.3.0 review, while the unchanged active reviews remain pinned. This is executable installed-instruction evidence; it does not claim a model actually started that review.

The 0.2.3 case then simulates downgrade by removing only the isolated 0.3.0 plugin and marketplace, reinstalling exact commit `4899884…`, and loading one fresh task from that cache. The final package is byte-identical to exact 0.2.3, contains neither the later graph schema nor validator, and therefore has no packaged graph machinery to consume the records. The complete project snapshot—including both graph files, preferences, ready homes, product sentinels, and active reviews—remains byte-for-byte equal to the pre-upgrade snapshot. This proves ignore-and-preserve compatibility for the simulated exact-package transition, not runtime behavior in an actual product project.

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

The first post-mutation list contained both pinned homes under distinct project IDs with a count of one for each. A later controller lookup also rediscovered both with `onePerProject=true` and chose `reuse existing; create zero`, but that lookup was not treated as new-session proof.

For genuine separate-session proof, the controller temporarily unarchived and repinned only the two recorded home fixtures, then created a new projectless Codex verifier task, `019fdbb7-379d-78a1-8bf9-87a9ec5ac5d5`. Its prompt was explicitly read-only and requested only task-list verification, with no edits or mutations. The completed verifier returned:

```text
Design Arc — UI plugin: Visible — project ID e1feaaeb-59f2-4dc8-a6d7-cb5603606b59 — exact matches: 1
Design Arc — Testing FB Lanes: Visible — project ID c5384f95-2b8b-46fa-99ee-458010b0f638 — exact matches: 1
```

This is evidence from a genuinely separate Codex task/session that both project homes remained distinct and non-duplicated. It was not an application process restart and is not presented as restart evidence.

Final cleanup set `pinned: false` and `archived: true` for both home fixtures and the verifier task. A post-cleanup visible-task list filtered to all three recorded IDs reported `temporaryAcceptanceTasksStillPinned: 0`. This proves the three temporary acceptance tasks are no longer pinned; it does not claim that archived task records were deleted from storage.

## Historical regression context

The 2026-08-04 standalone workflow sometimes requested a surface for inspection before explicitly establishing the intended outcome, and it did not consistently identify approval-mode provenance. That evidence predates the plugin consolidation and is retained only as historical motivation. It is not proof of current runtime behavior.
