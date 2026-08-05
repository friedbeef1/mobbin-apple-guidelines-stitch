---
name: fb-ux
description: Use when a mobile or web interface or end-to-end journey feels inconsistent, cluttered, unclear, or incomplete and the user wants the current product audited, journey directions benchmarked with Mobbin, validated against official platform guidance, and visualized as a complete Stitch proposal.
---

# FB UX

Build an auditable evidence chain from an explicit product objective to an approved journey direction and a newly generated Stitch proposal. Most steps run automatically; the user's project approval preference controls where Codex pauses. The Codex chat is the primary decision surface, and the Stitch board supplies deeper exploration.

## Why This Workflow Exists

Generated screens are not useful unless they solve a goal the user has confirmed and survive evidence checks. A subjective reaction such as “this journey feels wrong” can otherwise become isolated inspiration or an attractive mockup that neither addresses the product problem nor covers the states users encounter. This workflow makes the reasoning inspectable: confirm the intended outcome, evaluate the current journey against it, use official guidance as governing evidence, use Mobbin as observed precedent, and use Stitch to visualize the complete selected journey. It ends at a safe boundary before implementation or deployment.

## Project Approval Preference

At the first FB UX run in a project, look for `.codex/fb-ux.yaml`. If it does not exist and the current request does not explicitly select a mode, ask the user to choose one:

| Mode | Objective | Direction Gate | Stitch Gate |
|---|---|---|---|
| **Guided** — recommended for a new project | Stop to confirm | Stop | Stop |
| **Follow recommendation** | Stop to confirm | Automatically select Codex's recommendation | Stop |
| **Fully automatic** | Continue when the request states an explicit objective; otherwise stop to clarify | Automatically select Codex's recommendation | Continue when validation passes |

After the user chooses, create or update this project-scoped preference:

```yaml
approval_mode: guided
```

The only valid values are `guided`, `follow-recommendation`, and `fully-automatic`. Read the saved preference at the start of every run and state the active mode concisely. Do not silently turn a project preference into a global preference.

Resolve the mode in this order:

1. An explicit one-run override in the current request.
2. The saved value in `.codex/fb-ux.yaml`.
3. First-use selection; if selection cannot be obtained, use Guided.

`$fb-ux mode` reports the current project mode. `$fb-ux mode guided`, `$fb-ux mode follow-recommendation`, or `$fb-ux mode fully-automatic` changes and confirms the saved mode. A request such as `use Guided for this run` is a one-run override and does not rewrite the saved preference.

The mode controls pauses, not rigor. Every mode still requires the audit, current official guidance, inspected Mobbin evidence, synthesis, full validation, Stitch critique, evidence integrity, and ownership boundaries.

## Establish the Objective

Before inspecting the product, researching external sources, or generating anything, establish what outcome the user wants the journey to achieve.

- When the request gives enough context, offer two or three plausible, mutually distinct objectives and always allow free-form input. Do not make the user choose an agent-generated option.
- In Guided or Follow recommendation mode, restate a stated objective concisely and ask the user to confirm or revise it.
- In Fully automatic mode, treat an objective explicitly stated in the current request as pre-confirmed and continue without a separate pause. If the objective is missing or materially ambiguous, stop and ask; never invent it.
- Do not audit the product, look up Apple guidance, search Mobbin, or generate in Stitch until the objective is confirmed or explicitly stated under Fully automatic mode.
- Use the established objective as the evaluation criterion throughout the run. Do not ask for it again unless the scope materially changes.

Objective Confirmation is separate from the two design approval gates. `Follow your recommendation` selects Follow recommendation as a one-run override. `Bypass both gates` remains a backward-compatible one-run alias for Fully automatic, but it can remove the objective pause only when the current request states an explicit objective.

## Workflow

Follow this state machine in order:

`project preference → establish objective → audit → light Apple grounding → Mobbin discovery → directions → Direction Gate policy → full Apple validation → Stitch journey → Codex evidence → Stitch Gate policy → authorized routing`

1. **Resolve the project preference.** Apply an explicit one-run override, otherwise read `.codex/fb-ux.yaml`, otherwise ask the user to choose Guided, Follow recommendation, or Fully automatic and save the choice.
2. **Establish the objective.** Obtain the user’s confirmed outcome, or accept a clearly stated current-request objective under Fully automatic mode, before product inspection or external research.
3. **Audit the current product.** Inspect the live or supplied website/app and its product contract against that objective. Map real entry points, user goals, journey steps, screens, transitions, decision points, success states, empty states, errors, recovery paths, and visible friction. Record platform, orientation, state, region, and any inferred evidence.
4. **Perform light Apple grounding.** Look up current Apple guidance relevant to the intended experience, plus current first-party guidance for every other affected platform. Extract only the principles needed to ground hierarchy, navigation, targets, spacing, safe areas, labels, accessibility, feedback, errors, and recovery before benchmark research.
5. **Discover Mobbin journeys.** Search using the established user goal, screen type, and interaction. Inspect complete flows and images rather than metadata. Cite each mentioned screen or flow with its canonical Mobbin URL. Use official guidance and product context to assess examples; never copy assets, wording, colors, or layouts.
6. **Recommend exact directions.** Synthesize the evidence into one recommended direction plus meaningful alternatives. For each direction, state journey sequence, screens/states to add, remove, merge, or retain, important interaction changes, supporting Mobbin patterns, Apple grounding, benefits, risks, and trade-offs. Make the recommendation unmistakable.
7. **Apply the Direction Gate policy.** In Guided mode, present directions and stop. In Follow recommendation or Fully automatic mode, present the recommendation and alternatives, record that the saved preference selected the recommendation, and continue without pausing.
8. **Fully validate the selected direction.** Rigorously recheck the complete selected journey against current Apple guidance and every other affected platform’s first-party rules. Correct conflicts before generation. Distinguish platform requirements, evidence-backed precedent, and product-specific judgment.
9. **Generate the complete Stitch journey.** Use the existing Stitch project and design system when available. Generate every screen and material state required by the approved journey, including entry, transition, loading, success, empty, error, and recovery states. Specify exact viewports, safe areas, product assets or generic mock imagery, interaction state, and prohibited clutter. Arrange the output as a coherent Stitch board and record project and new screen IDs.
10. **Render honest evidence in Codex.** Verify exported or rendered image dimensions. Embed key journey screens directly in chat, provide a concise journey map and Stitch generator recommendations, and identify project, board, screen IDs, and exact viewports. A user must be able to judge the proposal from Codex without opening Stitch.
11. **Apply the Stitch Gate policy.** Recheck actual renders against the selected direction, official principles, and Mobbin direction. Inspect containment, hierarchy, navigation, targets, spacing, safe areas, text size, orientation, accessibility, errors, and recovery. Give one verdict: `meets direction`, `meets with corrections`, or `does not meet`. Separate mockup validation from native/browser implementation proof. Guided and Follow recommendation stop here. Fully automatic continues only when the verdict is `meets direction`; for either other verdict, stop with corrections or blockers.
12. **Route authorized work.** Only after the user approves the Stitch gate or Fully automatic mode passes it under Approval Modes, update one canonical handoff and its board/index/card entries in a coordinated project. Automatic continuation authorizes routing of the validated proposal only; it never authorizes source implementation, staging, live deployment, release, destructive/provider changes, or work outside the authorized integration lane. Treat refinements as amendments, not duplicate tasks. Source implementation remains with the authorized integration lane.

## Why Every Step Matters

| Step | Why crucial | Failure if skipped |
|---|---|---|
| Project preference | Makes automatic progress and approval pauses follow the user's chosen operating mode. | Codex repeatedly asks for unwanted approval or silently skips a wanted pause. |
| Objective Confirmation | Establishes the user’s intended outcome as the decision criterion. | Research and mockups optimize an inferred or wrong problem. |
| Audit | Grounds the proposal in the actual journey and its friction. | Directions address an imagined product or a single screen. |
| Light Apple grounding | Sets platform constraints before looking for precedent. | Benchmark examples can normalize patterns that conflict with platform rules. |
| Mobbin discovery | Supplies current, inspectable journey precedent. | Recommendations become unsupported taste or copied fragments. |
| Directions | Makes the recommendation, alternatives, risks, and trade-offs decidable. | The user cannot make an informed product choice. |
| Direction Gate | Preserves the user’s control over the proposed journey. | Full validation and generation proceed on an unchosen direction. |
| Full Apple validation | Resolves platform conflicts before the proposal is generated. | Stitch work bakes in avoidable navigation, accessibility, or safe-area defects. |
| Stitch journey | Visualizes the entire chosen journey and its material states. | A polished happy-path screen hides loading, error, empty, and recovery behavior. |
| Codex evidence | Keeps the decision-ready evidence in the conversation. | A stakeholder must reconstruct the rationale in an external board. |
| Stitch Gate | Separates a validated proposal from authorization to act on it. | A mockup is mistaken for implementation, release, or deployment approval. |
| Authorized routing | Hands only approved work to its owning lane. | Duplicate work, ownership conflicts, or unauthorized source changes follow. |

## Approval Modes

| Saved or one-run mode | Objective | Direction Approval Gate | Stitch Approval Gate |
|---|---|---|---|
| **Guided** | Stop to confirm | Stop | Stop |
| **Follow recommendation** | Stop to confirm | Continue with the recommended direction | Stop |
| **Fully automatic** | Continue with an explicit current-request objective; otherwise clarify | Continue with the recommended direction | Continue only after a `meets direction` verdict |

Most workflow steps are automatic in every mode. Gates are optional decision pauses, not optional quality checks. An explicit current-request mode is a one-run override unless the user asks to save it. `Follow your recommendation` maps to Follow recommendation for that run. `Bypass both gates` or `follow all recommendations without stopping` maps to Fully automatic for that run.

When the mode or instruction is ambiguous and no saved preference exists, use Guided. Approval to pass either design gate does not authorize source implementation, staging, live deployment, destructive/provider changes, or release. No mode waives evidence integrity, current-source lookups, external-service payload approval when separately required, accessibility/device proof, or lane ownership.

## Required Output

- **Approval preference:** saved project mode, any one-run override, and which pauses apply.
- **Established objective:** the user-confirmed outcome or explicit Fully automatic objective and the criterion used to evaluate the journey.
- **Current journey:** product surface, platform, entry point, user goal, steps, states, and observed friction.
- **Official grounding:** applicable Apple and other first-party principles with direct links.
- **Mobbin evidence:** inspected journey patterns with canonical links and what each supports or challenges.
- **Directions:** one clearly recommended journey plus alternatives, precise changes, and trade-offs.
- **Gate status:** whether objective, Direction Gate, and Stitch Gate were paused, approved, automatically continued under preference, or blocked.
- **Stitch proposal:** an inline journey map and embedded key renders, followed by exact viewports, project/board, and new screen IDs.
- **Validation:** verdict, corrections made, and remaining implementation/device gates.
- **Status:** design-only or implemented, plus the next authorized owner.

## Integrity Gates

- Do not claim an objective is established without explicit confirmation or an objective stated in the current Fully automatic request.
- Do not claim the current journey was inspected without current product evidence.
- Do not claim guidance was checked without a current-turn first-party lookup.
- Do not say Mobbin supports a decision without a current-turn Mobbin image/flow search.
- Do not say Stitch built the proposal without new generated/edited screen IDs.
- Do not claim an exact viewport from Stitch metadata alone; verify exported or rendered dimensions.
- Do not claim accessibility, safe-area, or device compliance from appearance alone; identify the measured implementation proof still required.
- If the product, Mobbin, official guidance, or Stitch is unavailable, report the blocked evidence gate and do not claim the full workflow is complete.

## Quick Check

`project preference → established objective → current journey → light official grounding → inspected Mobbin flows → recommended directions → Direction Gate policy → rigorous official validation → complete Stitch journey/board → inline Codex evidence → render validation → Stitch Gate policy → authorized handoff`

## Common Mistakes

- Ignoring `.codex/fb-ux.yaml` or making the user choose a mode on every run.
- Rewriting the saved mode for a one-run override.
- Beginning audit or research from an inferred objective.
- Treating Fully automatic as permission to invent a missing objective.
- Reviewing one screen when the user asked to redesign a journey.
- Letting Mobbin examples dictate the recommendation instead of using them as precedent.
- Reusing old guidance, metadata, or a prior Stitch render as current evidence.
- Treating “follow your recommendation” as permission to bypass the later Stitch gate.
- Treating “bypass both gates” as implementation or deployment approval.
- Omitting loading, empty, error, recovery, or transition states from the Stitch journey.
- Showing only a Stitch URL instead of embedding decision-ready evidence in Codex.
- Calling a mockup compliant before measured implementation and device checks.
