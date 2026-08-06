---
name: design-arc
description: Use when a mobile or web product journey feels confusing, incomplete, inconsistent, or subject to taste-based redesign debate, or when a team needs evidence-backed directions and complete material states before implementation.
---

# Design Arc

Turn an explicit product outcome into a complete, evidence-backed journey proposal. Audit the real experience, compare meaningful directions, recommend one path, and visualize every material state while preserving the user's approval and release boundaries.

## Non-negotiable order

Resolve setup before product inspection, external research, or generation. Then establish the user's objective before any of those activities.

Use this state machine:

`setup → objective → current-journey audit → evidence → directions → Direction Gate → full first-party validation → complete Stitch journey → render validation → Stitch Gate → authorized handoff`

Setup controls how evidence is gathered and where approval pauses occur. It never lowers evidence quality.

## Setup and project preference

Store project-scoped choices in `.codex/design-arc.yaml`:

```yaml
evidence_mode: benchmarks
benchmark_provider: mobbin
approval_mode: guided
```

Valid evidence modes are `benchmarks` and `guidelines`. `benchmark_provider` is valid only with Benchmarks; currently document `mobbin` when the user chooses that external provider. Valid approval modes are `guided`, `follow-recommendation`, and `fully-automatic`. Do not create a global preference.

### Commands

- `$design-arc setup` — resolve migration and any missing project choices.
- `$design-arc evidence benchmarks` — save Benchmarks for this project after confirming provider access.
- `$design-arc evidence guidelines` — save Guidelines and omit `benchmark_provider`.
- `$design-arc mode` — report the saved and active approval mode and provenance.
- `$design-arc mode guided` — save Guided.
- `$design-arc mode follow-recommendation` — save Follow recommendation.
- `$design-arc mode fully-automatic` — save Fully automatic.

A natural-language request such as “use Guidelines for this run” or “follow your recommendation this time” is a one-run override, not permission to rewrite the file. A setting command explicitly authorizes changing only that named project preference.

### Resolution precedence

Resolve evidence and approval independently, in this order:

1. Explicit one-run override in the current request; do not save it unless asked.
2. Saved `.codex/design-arc.yaml` value.
3. Confirmed legacy import, only when the new file is absent.
4. First-use selection for every choice still missing.

Always report the active evidence mode and approval mode, and the provenance of each independently. Use one of: current-request one-run override, saved Design Arc preference, confirmed legacy import, or first-use selection. Never attribute an overridden value to the saved file.

For first use, ask the user to choose independently:

- **Benchmarks — recommended when relevant access is available.** Use inspected real-product journeys plus current first-party guidance.
- **Guidelines.** Use current first-party platform guidance without benchmark research.
- **Guided — recommended for a new project.** Stop at Objective Confirmation, Direction Gate, and Stitch Gate.
- **Follow recommendation.** Stop at Objective Confirmation, automatically select the marked direction, and stop at Stitch Gate.
- **Fully automatic.** Continue only from an explicit current-request objective, select the marked direction, and pass Stitch Gate only on `meets direction`.

Allow free-form input. Before saving first-use choices, state the proposed file values and obtain confirmation.

### Legacy preference import

Only consider import when `.codex/design-arc.yaml` is absent.

- `.codex/fb-ux.yaml` maps to `evidence_mode: benchmarks`, `benchmark_provider: mobbin`, and its preserved approval mode.
- `.codex/apple-guidelines-stitch.yaml` maps to `evidence_mode: guidelines`, omits `benchmark_provider`, and preserves its approval mode.
- Show the proposed mapping and ask once before importing it.
- If both legacy files exist, present both mappings and require the user to choose one or start fresh.
- Never silently merge, rewrite, or delete either legacy preference file.

Import writes only the new Design Arc preference after confirmation. Retain the old file or files untouched for recovery.

### The six valid combinations

Evidence selection and approval behavior remain independent:

| Evidence | Approval | Gate behavior |
|---|---|---|
| Benchmarks | Guided | Direction Gate stops; Stitch Gate stops |
| Benchmarks | Follow recommendation | Direction Gate continues with the marked recommendation; Stitch Gate stops |
| Benchmarks | Fully automatic | Direction Gate continues; Stitch Gate continues only on `meets direction` |
| Guidelines | Guided | Direction Gate stops; Stitch Gate stops |
| Guidelines | Follow recommendation | Direction Gate continues with the marked recommendation; Stitch Gate stops |
| Guidelines | Fully automatic | Direction Gate continues; Stitch Gate continues only on `meets direction` |

## Establish the objective

Make the user's desired outcome the criterion for every audit finding, evidence choice, direction, and render verdict.

- When the request is broad, offer two or three distinct plausible objectives and allow the user to enter their own.
- In Guided or Follow recommendation mode, restate a stated objective and ask the user to confirm or revise it.
- Fully automatic may skip the objective pause only when the current request states an explicit objective.
- If the objective is missing or materially ambiguous, stop and ask; never invent it.
- Do not inspect, research, or generate until the objective is confirmed or is explicit under Fully automatic.

Objective Confirmation is separate from the two design gates. “Follow your recommendation” changes the Direction Gate policy for one run; it does not confirm an objective or bypass Stitch Gate. “Bypass both gates” is a one-run Fully automatic alias, but still requires an explicit current-request objective.

## Audit the real journey

Inspect the live or supplied product and its product contract against the established objective. Map the complete relevant journey, not an isolated screen:

- platform, orientation, viewport, region, entry point, and user goal;
- steps, screens, transitions, choices, and exits;
- loading, empty, error, success, cancellation, and recovery states;
- observed friction versus clearly labeled inference.

Do not redesign an imagined product. If current product evidence is unavailable, report the blocked audit and stop.

## Gather evidence

### Benchmarks

Confirm external benchmark access before research. Apply a light current first-party constraint check before looking for precedent so examples do not normalize a platform conflict.

Inspect complete, relevant real-product journeys and explain why each selected pattern is useful for the established objective. Library presence, metadata, popularity, or one screenshot never proves best-in-class quality. Record the product, journey, relevant states, current canonical link, inspection context, supported decision, limitations, and observed-versus-inferred status.

Mobbin is an optional external benchmark provider, not a bundled or official Design Arc integration. Access and authorization remain external and separate.

If benchmark access is missing, stop; never degrade silently. Offer either a one-run Guidelines fallback that does not rewrite the saved preference, or a confirmed saved switch to Guidelines. Do not continue until the user chooses, and do not describe a fallback result as benchmark-backed.

### Guidelines

In Guidelines mode, perform no benchmark lookup and make no benchmark-evidence claim. Look up current first-party guidance for every affected platform and link directly to the principles that constrain hierarchy, navigation, targets, labels, feedback, accessibility, errors, safe areas, and recovery.

Use Apple Human Interface Guidelines as first-party authority for Apple targets. For Android or web targets, current first-party platform rules override conflicting Apple-inspired judgment. Distinguish platform requirements from product-specific judgment.

## Recommend directions and apply the Direction Gate

Synthesize the audit and selected evidence into one recommended direction and meaningful alternatives. For each direction state:

- journey sequence and outcome logic;
- screens and states to add, remove, merge, or retain;
- key interaction changes and supporting evidence;
- benefits, risks, trade-offs, and unresolved questions.

At the Direction Gate, present one unmistakably marked recommendation plus meaningful alternatives and their trade-offs.

- **Guided:** report the active settings and provenance, then stop for the user's direction choice.
- **Follow recommendation:** record that the active mode selected the marked recommendation, then continue.
- **Fully automatic:** record the same automatic selection, then continue.

An automatic selection is still visible and auditable; never hide the alternatives or their trade-offs.

## Validate and visualize the selected journey

Recheck the complete selected direction against current first-party guidance for every affected platform. Resolve conflicts before generation and report any product-specific judgment separately.

Stitch is an external visualization service, not a bundled or official Design Arc integration. Obtain whatever separate access and payload authorization the environment requires. Use an existing project and design system when supplied. Generate every material state required by the selected journey, including entry, transition, loading, empty, error, success, cancellation, and recovery. Record exact requested viewports, safe areas, assets, interaction states, project or board identifiers, and new screen identifiers.

Return decision-ready evidence in Codex: an inline journey map, embedded key renders, concise generator recommendations, exact verified render dimensions, identifiers, and evidence provenance. A board offers deeper exploration; it is not a substitute for the evidence in chat.

Inspect the actual renders for journey coherence, hierarchy, navigation, targets, spacing, containment, safe areas, orientation, text size, accessibility, errors, and recovery. Give exactly one Stitch verdict: `meets direction`, `meets with corrections`, or `does not meet`.

## Apply the Stitch Gate and hand off

- **Guided and Follow recommendation:** stop after the verdict and request approval.
- **Fully automatic:** Fully automatic continues only when the Stitch verdict is `meets direction`; `meets with corrections` and `does not meet` both stop.

Passing Stitch Gate authorizes only a coordinated handoff of the validated design proposal. Design approval never authorizes source implementation, staging, live deployment, release, destructive changes, provider changes, or work outside the authorized integration lane. Treat later refinements as amendments to one canonical handoff rather than duplicate tasks.

## Required run record

Report these fields in the Codex conversation:

- **Setup:** active evidence mode, active approval mode, provenance of each, saved values, and one-run overrides.
- **Objective:** confirmed outcome or explicit Fully automatic objective and evaluation criterion.
- **Current journey:** surface, platform, entry, steps, material states, friction, and evidence status.
- **Evidence:** source type, current links, inspected scope, what each source supports, and limitations.
- **Directions:** marked recommendation, alternatives, exact journey changes, and trade-offs.
- **Gates:** Objective Confirmation, Direction Gate, and Stitch Gate status and reason.
- **Proposal:** journey map, embedded key renders, viewports, identifiers, and material states.
- **Validation:** Stitch verdict, corrections, blocked proof, and remaining device or implementation checks.
- **Authority:** design-only status and next authorized owner.

## Evidence and authorization integrity

Do not claim product inspection, first-party guidance, benchmark evidence, or new Stitch output without current evidence for that exact claim. Do not claim exact render dimensions from metadata alone. Do not claim accessibility, safe-area, browser, native, or device compliance from appearance alone; identify the measured implementation proof still required.

No approval mode waives current-source evidence, external authorization, platform precedence, complete-state coverage, render critique, or ownership. If any required source or service is unavailable, report the exact blocked gate and the partial evidence that remains valid.

## Common mistakes

- Treating the two choices as one combined “mode” instead of resolving evidence and approval independently.
- Inspecting the product or researching before setup and Objective Confirmation.
- Rewriting a saved preference because of a one-run override.
- Silently importing or merging legacy preferences.
- Falling back from Benchmarks without the user's choice.
- Calling a popular screenshot “best in class” without inspecting its journey.
- Looking up benchmarks or implying benchmark support in Guidelines mode.
- Inventing a missing objective under Fully automatic.
- Hiding alternatives because Follow recommendation is active.
- Treating `meets with corrections` as permission to pass Stitch Gate.
- Omitting non-happy states from the generated journey.
- Treating a design approval as implementation or release authorization.
