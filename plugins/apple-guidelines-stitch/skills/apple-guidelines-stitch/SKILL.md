---
name: apple-guidelines-stitch
description: Use when a mobile or web interface or end-to-end journey feels inconsistent, cluttered, unclear, or incomplete and the user wants the current product audited, grounded in Apple-led official guidance, validated across affected platforms, and visualized as a complete Stitch proposal.
---

# Apple Guidelines + Stitch

Build an auditable evidence chain from an explicit product objective to an approved journey direction and a newly generated Stitch proposal. Apple Human Interface Guidelines are the primary design framework. For Android or web targets, current first-party platform rules override conflicting Apple-inspired judgment. The Codex chat is the primary decision surface, and Stitch supplies deeper exploration.

## Project Approval Preference

At the first Apple Guidelines + Stitch run in a project, look for `.codex/apple-guidelines-stitch.yaml`. If it does not exist and the current request does not explicitly select a mode, ask the user to choose one:

| Mode | Objective | Direction Gate | Stitch Gate |
|---|---|---|---|
| **Guided** — recommended for a new project | Stop to confirm | Stop | Stop |
| **Follow recommendation** | Stop to confirm | Automatically select Codex's recommendation | Stop |
| **Fully automatic** | Continue when the request states an explicit objective; otherwise stop to clarify | Automatically select Codex's recommendation | Continue when validation passes |

After the user chooses, create or update this project-scoped preference:

```yaml
approval_mode: guided
```

The only valid values are `guided`, `follow-recommendation`, and `fully-automatic`. Read the saved preference at the start of every run and state the active mode concisely. Also state whether that active mode came from the saved project preference, an explicit one-run override, or first-use/default selection. Do not silently turn a project preference into a global preference.

Resolve the mode in this order:

1. An explicit one-run override in the current request.
2. The saved value in `.codex/apple-guidelines-stitch.yaml`.
3. First-use selection; if selection cannot be obtained, use Guided.

`$apple-guidelines-stitch mode` reports the current project mode. `$apple-guidelines-stitch mode guided`, `$apple-guidelines-stitch mode follow-recommendation`, or `$apple-guidelines-stitch mode fully-automatic` changes and confirms the saved mode. A request such as `use Guided for this run` is a one-run override and does not rewrite the saved preference.

The mode controls pauses, not rigor. Every mode still requires the audit, current official guidance, synthesis, full cross-platform validation, Stitch critique, evidence integrity, and ownership boundaries.

## Establish the Objective

Before inspecting the product, researching external sources, or generating anything, establish what outcome the user wants the journey to achieve.

- When the request gives enough context, offer two or three plausible, mutually distinct objectives and always allow free-form input. Do not make the user choose an agent-generated option.
- In Guided or Follow recommendation mode, restate a stated objective concisely and ask the user to confirm or revise it.
- In Fully automatic mode, treat an objective explicitly stated in the current request as pre-confirmed and continue without a separate pause. If the objective is missing or materially ambiguous, stop and ask; never invent it.
- Do not audit the product, look up official guidance, or generate in Stitch until the objective is confirmed or explicitly stated under Fully automatic mode.
- Use the established objective as the evaluation criterion throughout the run. Do not ask for it again unless the scope materially changes.

Objective Confirmation is separate from the two design approval gates. `Follow your recommendation` selects Follow recommendation as a one-run override. `Bypass both gates` remains a backward-compatible one-run alias for Fully automatic, but it can remove the objective pause only when the current request states an explicit objective.

## Workflow

Follow this state machine in order:

`project preference → establish objective → audit → Apple-led official grounding → directions → Direction Gate policy → full cross-platform validation → Stitch journey → Codex evidence → Stitch Gate policy → authorized routing`

1. **Resolve the project preference.** Apply an explicit one-run override, otherwise read `.codex/apple-guidelines-stitch.yaml`, otherwise ask the user to choose Guided, Follow recommendation, or Fully automatic and save the choice. At resolution, record the active mode and whether it came from the saved project preference or an explicit one-run override; if neither supplied it, identify the first-use/default selection instead.
2. **Establish the objective.** Obtain the user’s confirmed outcome, or accept a clearly stated current-request objective under Fully automatic mode, before product inspection or external research.
3. **Audit the current product.** Inspect the live or supplied website/app and its product contract against that objective. Map real entry points, user goals, journey steps, screens, transitions, decision points, success states, empty states, errors, recovery paths, and visible friction. Record platform, orientation, state, region, and any inferred evidence.
4. **Perform Apple-led official grounding.** Look up current Apple Human Interface Guidelines relevant to the intended experience, plus current first-party guidance for every other affected platform. Extract the principles needed to ground hierarchy, navigation, targets, spacing, safe areas, labels, accessibility, feedback, errors, and recovery. For Android or web, current first-party platform rules override conflicting Apple-inspired judgment.
5. **Recommend exact directions.** Synthesize the evidence into one recommended direction plus meaningful alternatives. For each direction, state journey sequence, screens/states to add, remove, merge, or retain, important interaction changes, official grounding, benefits, risks, and trade-offs. Make the recommendation unmistakable.
6. **Apply the Direction Gate policy.** In Guided mode, present directions, record the active mode and its provenance, and stop. In Follow recommendation or Fully automatic mode, present the recommendation and alternatives, record that the active mode selected the recommendation, include whether the active mode came from the saved project preference or an explicit one-run override, and continue without pausing; never attribute the selection to the saved preference when an explicit one-run override is active.
7. **Fully validate the selected direction.** Rigorously recheck the complete selected journey against current Apple guidance and every other affected platform’s first-party rules. Correct conflicts before generation. Distinguish platform requirements, evidence-backed precedent, and product-specific judgment. For Android or web targets, current first-party platform rules override conflicting Apple-inspired judgment.
8. **Generate the complete Stitch journey.** Stitch is external and separately authorized; do not claim an official integration. Use the existing Stitch project and design system when available. Generate every screen and material state required by the approved journey, including entry, transition, loading, success, empty, error, and recovery states. Specify exact viewports, safe areas, product assets or generic mock imagery, interaction state, and prohibited clutter. Arrange the output as a coherent Stitch board and record project and new screen IDs.
9. **Render honest evidence in Codex.** Verify exported or rendered image dimensions. Embed key journey screens directly in chat, provide a concise journey map and Stitch generator recommendations, and identify project, board, screen IDs, and exact viewports. A user must be able to judge the proposal from Codex without opening Stitch.
10. **Apply the Stitch Gate policy.** Recheck actual renders against the selected direction and official principles. Inspect containment, hierarchy, navigation, targets, spacing, safe areas, text size, orientation, accessibility, errors, and recovery. Give one verdict: `meets direction`, `meets with corrections`, or `does not meet`. Separate mockup validation from native/browser implementation proof. Guided and Follow recommendation stop here. Fully automatic continues only when the verdict is `meets direction`; for either other verdict, stop with corrections or blockers.
11. **Route authorized work.** Only after the user approves the Stitch gate or Fully automatic mode passes it under Approval Modes, update one canonical handoff and its board/index/card entries in a coordinated project. Automatic continuation authorizes routing of the validated proposal only; it never authorizes source implementation, staging, live deployment, release, destructive or provider changes, or work outside the authorized integration lane. Treat refinements as amendments, not duplicate tasks. Source implementation remains with the authorized integration lane.

## Approval Modes

| Saved or one-run mode | Objective | Direction Approval Gate | Stitch Approval Gate |
|---|---|---|---|
| **Guided** | Stop to confirm | Stop | Stop |
| **Follow recommendation** | Stop to confirm | Continue with the recommended direction | Stop |
| **Fully automatic** | Continue with an explicit current-request objective; otherwise clarify | Continue with the recommended direction | Continue only after a `meets direction` verdict |

Most workflow steps are automatic in every mode. Gates are optional decision pauses, not optional quality checks. An explicit current-request mode is a one-run override unless the user asks to save it. `Follow your recommendation` maps to Follow recommendation for that run. `Bypass both gates` or `follow all recommendations without stopping` maps to Fully automatic for that run.

When the mode or instruction is ambiguous and no saved preference exists, use Guided. Approval to pass either design gate does not authorize source implementation, staging, live deployment, destructive/provider changes, or release. No mode waives evidence integrity, current-source lookups, external-service payload approval when separately required, accessibility/device proof, or lane ownership.

## Required Output

- **Approval preference:** saved project mode, any one-run override, the active mode and its provenance, and which pauses apply.
- **Established objective:** the user-confirmed outcome or explicit Fully automatic objective and the criterion used to evaluate the journey.
- **Current journey:** product surface, platform, entry point, user goal, steps, states, and observed friction.
- **Official grounding:** applicable Apple and other first-party principles with direct links.
- **Directions:** one clearly recommended journey plus alternatives, precise changes, and trade-offs.
- **Gate status:** whether objective, Direction Gate, and Stitch Gate were paused, approved, automatically continued under preference, or blocked.
- **Stitch proposal:** an inline journey map and embedded key renders, followed by exact viewports, project/board, and new screen IDs.
- **Validation:** verdict, corrections made, and remaining implementation/device gates.
- **Status:** design-only or implemented, plus the next authorized owner.

## Integrity Gates

- Do not claim an objective is established without explicit confirmation or an objective stated in the current Fully automatic request.
- Do not claim the current journey was inspected without current product evidence.
- Do not claim guidance was checked without a current-turn first-party lookup.
- Do not say Stitch built the proposal without new generated or edited screen IDs.
- Do not claim an exact viewport from Stitch metadata alone; verify exported or rendered dimensions.
- Do not claim accessibility, safe-area, or device compliance from appearance alone; identify the measured implementation proof still required.
- If the product, official guidance, or Stitch is unavailable, report the blocked evidence gate and do not claim the full workflow is complete.

## Quick Check

`project preference → established objective → current journey → Apple-led official grounding → recommended directions → Direction Gate policy → full cross-platform validation → complete Stitch journey/board → inline Codex evidence → render validation → Stitch Gate policy → authorized handoff`

## Common Mistakes

- Ignoring `.codex/apple-guidelines-stitch.yaml` or making the user choose a mode on every run.
- Rewriting the saved mode for a one-run override.
- Beginning audit or research from an inferred objective.
- Treating Fully automatic as permission to invent a missing objective.
- Reviewing one screen when the user asked to redesign a journey.
- Letting generic precedent dictate the recommendation instead of current official guidance and product context.
- Reusing old guidance or a prior Stitch render as current evidence.
- Treating `follow your recommendation` as permission to bypass the later Stitch gate.
- Treating `bypass both gates` as implementation or deployment approval.
- Omitting loading, empty, error, recovery, or transition states from the Stitch journey.
- Showing only a Stitch URL instead of embedding decision-ready evidence in Codex.
- Calling a mockup compliant before measured implementation and device checks.
