---
name: validating-ui-with-guidelines-and-mobbin
description: Use when a mobile or web interface or end-to-end journey feels inconsistent, cluttered, unclear, or incomplete and the user wants the current product audited, journey directions benchmarked with Mobbin, validated against official platform guidance, and visualized as a complete Stitch proposal.
---

# Validate UI Journeys With Guidelines, Mobbin, and Stitch

Build an auditable evidence chain from a user-confirmed product objective to an approved journey direction and a newly generated Stitch proposal. The Codex chat is the primary decision surface; the Stitch board supplies deeper exploration.

## Why This Workflow Exists

Generated screens are not useful unless they solve a goal the user has confirmed and survive evidence checks. A subjective reaction such as “this journey feels wrong” can otherwise become isolated inspiration or an attractive mockup that neither addresses the product problem nor covers the states users encounter. This workflow makes the reasoning inspectable: confirm the intended outcome, evaluate the current journey against it, use official guidance as governing evidence, use Mobbin as observed precedent, and use Stitch to visualize the complete selected journey. It ends at a safe boundary before implementation or deployment.

## Objective Confirmation

Before inspecting the product, researching external sources, or generating anything, ask what outcome the user wants the journey to achieve.

- When the request gives enough context, offer two or three plausible, mutually distinct objectives and always allow free-form input. Do not make the user choose an agent-generated option.
- When the request already states an objective, restate it concisely and ask the user to confirm or revise it.
- Do not audit the product, look up Apple guidance, search Mobbin, or generate in Stitch until the objective is confirmed.
- Use the confirmed objective as the evaluation criterion throughout the run. Do not ask for it again unless the scope materially changes.

Objective Confirmation is separate from the two design approval gates. “Follow your recommendation” and “bypass both gates” never bypass unconfirmed intent.

## Workflow

Follow this state machine in order:

`Objective Confirmation → audit → light Apple grounding → Mobbin discovery → directions → Direction Gate → full Apple validation → Stitch journey → Codex evidence → Stitch Gate → authorized routing`

1. **Confirm the objective.** Obtain the user’s confirmed outcome before product inspection or external research.
2. **Audit the current product.** Inspect the live or supplied website/app and its product contract against that objective. Map real entry points, user goals, journey steps, screens, transitions, decision points, success states, empty states, errors, recovery paths, and visible friction. Record platform, orientation, state, region, and any inferred evidence.
3. **Perform light Apple grounding.** Look up current Apple guidance relevant to the intended experience, plus current first-party guidance for every other affected platform. Extract only the principles needed to ground hierarchy, navigation, targets, spacing, safe areas, labels, accessibility, feedback, errors, and recovery before benchmark research.
4. **Discover Mobbin journeys.** Search using the confirmed user goal, screen type, and interaction. Inspect complete flows and images rather than metadata. Cite each mentioned screen or flow with its canonical Mobbin URL. Use official guidance and product context to assess examples; never copy assets, wording, colors, or layouts.
5. **Recommend exact directions.** Synthesize the evidence into one recommended direction plus meaningful alternatives. For each direction, state journey sequence, screens/states to add, remove, merge, or retain, important interaction changes, supporting Mobbin patterns, Apple grounding, benefits, risks, and trade-offs. Make the recommendation unmistakable.
6. **Apply the Direction Approval Gate.** By default, present directions and stop. Continue only after the user chooses a direction or explicitly authorizes the recommendation.
7. **Fully validate the selected direction.** Rigorously recheck the complete selected journey against current Apple guidance and every other affected platform’s first-party rules. Correct conflicts before generation. Distinguish platform requirements, evidence-backed precedent, and product-specific judgment.
8. **Generate the complete Stitch journey.** Use the existing Stitch project and design system when available. Generate every screen and material state required by the approved journey, including entry, transition, loading, success, empty, error, and recovery states. Specify exact viewports, safe areas, product assets or generic mock imagery, interaction state, and prohibited clutter. Arrange the output as a coherent Stitch board and record project and new screen IDs.
9. **Render honest evidence in Codex.** Verify exported or rendered image dimensions. Embed key journey screens directly in chat, provide a concise journey map and Stitch generator recommendations, and identify project, board, screen IDs, and exact viewports. A user must be able to judge the proposal from Codex without opening Stitch.
10. **Apply the Stitch Approval Gate.** Recheck actual renders against the selected direction, official principles, and Mobbin direction. Inspect containment, hierarchy, navigation, targets, spacing, safe areas, text size, orientation, accessibility, errors, and recovery. Give one verdict: `meets direction`, `meets with corrections`, or `does not meet`. Separate mockup validation from native/browser implementation proof. By default, stop after presenting and validating the Stitch proposal.
11. **Route authorized work.** Only after the user approves the Stitch gate or explicitly bypasses it under Approval Modes, update one canonical handoff and its board/index/card entries in a coordinated project. An explicit Stitch-gate bypass authorizes routing of the validated proposal only; it never authorizes source implementation, staging, live deployment, release, destructive/provider changes, or work outside the authorized integration lane. Treat refinements as amendments, not duplicate tasks. Source implementation remains with the authorized integration lane.

## Why Every Step Matters

| Step | Why crucial | Failure if skipped |
|---|---|---|
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

| User instruction | Direction Approval Gate | Stitch Approval Gate |
|---|---|---|
| No bypass instruction | Stop | Stop |
| “Follow your recommendation” or an explicit equivalent | Continue with the recommended direction | Stop |
| “Bypass both gates,” “follow all recommendations without stopping,” or an equally explicit instruction naming both gates | Continue with the recommended direction | Continue through Stitch and route the validated proposal |

When the instruction is ambiguous, preserve both gates. Approval to pass either design gate does not authorize source implementation, staging, live deployment, destructive/provider changes, or release. Gate bypass never waives Objective Confirmation, evidence integrity, current-source lookups, external-service payload approval when separately required, accessibility/device proof, or lane ownership.

## Required Output

- **Confirmed objective:** the user-confirmed outcome and the criterion used to evaluate the journey.
- **Current journey:** product surface, platform, entry point, user goal, steps, states, and observed friction.
- **Official grounding:** applicable Apple and other first-party principles with direct links.
- **Mobbin evidence:** inspected journey patterns with canonical links and what each supports or challenges.
- **Directions:** one clearly recommended journey plus alternatives, precise changes, and trade-offs.
- **Gate status:** the applicable approval mode and whether Objective Confirmation, Direction Gate, and Stitch Gate are pending, approved, or explicitly bypassed.
- **Stitch proposal:** an inline journey map and embedded key renders, followed by exact viewports, project/board, and new screen IDs.
- **Validation:** verdict, corrections made, and remaining implementation/device gates.
- **Status:** design-only or implemented, plus the next authorized owner.

## Integrity Gates

- Do not claim an objective is confirmed without an explicit user confirmation or stated confirmation that has been accepted.
- Do not claim the current journey was inspected without current product evidence.
- Do not claim guidance was checked without a current-turn first-party lookup.
- Do not say Mobbin supports a decision without a current-turn Mobbin image/flow search.
- Do not say Stitch built the proposal without new generated/edited screen IDs.
- Do not claim an exact viewport from Stitch metadata alone; verify exported or rendered dimensions.
- Do not claim accessibility, safe-area, or device compliance from appearance alone; identify the measured implementation proof still required.
- If the product, Mobbin, official guidance, or Stitch is unavailable, report the blocked evidence gate and do not claim the full workflow is complete.

## Quick Check

`confirmed objective → current journey → light official grounding → inspected Mobbin flows → recommended directions → Direction Gate → rigorous official validation → complete Stitch journey/board → inline Codex evidence → render validation → Stitch Gate → authorized handoff`

## Common Mistakes

- Beginning audit or research from an inferred objective.
- Treating “bypass both gates” as permission to skip Objective Confirmation.
- Reviewing one screen when the user asked to redesign a journey.
- Letting Mobbin examples dictate the recommendation instead of using them as precedent.
- Reusing old guidance, metadata, or a prior Stitch render as current evidence.
- Treating “follow your recommendation” as permission to bypass the later Stitch gate.
- Treating “bypass both gates” as implementation or deployment approval.
- Omitting loading, empty, error, recovery, or transition states from the Stitch journey.
- Showing only a Stitch URL instead of embedding decision-ready evidence in Codex.
- Calling a mockup compliant before measured implementation and device checks.
