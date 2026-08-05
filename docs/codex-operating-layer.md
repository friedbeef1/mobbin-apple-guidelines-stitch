# Codex as the operating layer

FB UX uses Codex as the place where the product objective, source evidence, recommendations, gate decisions, and next authorized owner remain connected. Mobbin supplies external precedent and Stitch supplies external visualization; neither replaces product judgment, current first-party guidance, or the user's authority to decide.

## What Codex contributes

- Confirms or clarifies the intended outcome before product inspection or external research.
- Audits the actual journey, including entry points, states, friction, errors, and recovery paths.
- Coordinates current first-party platform guidance with inspected Mobbin flows, distinguishes requirements from precedent and judgment, and recommends a complete journey with alternatives and trade-offs.
- Directs complete Stitch proposals, critiques their actual renders, and embeds decision-ready evidence in the task instead of treating a board link or metadata as proof.
- Applies the saved project approval preference, records why a gate was passed or paused, and routes only validated design work to the authorized Product/Captain/Integration lane.

## What Codex does not replace

The user owns the product objective, approval preference, and final design decisions. Apple and other first-party sources remain the authority for platform guidance. Mobbin and Stitch are external, separately authorized services; Apple, Google, Mobbin, and Stitch integrations are not bundled or official. Stitch output remains a proposal, not implementation or device proof.

## Approval and evidence discipline

The project preference in `.codex/fb-ux.yaml` selects Guided, Follow recommendation, or Fully automatic behavior. Objective handling always happens before inspection or research: Guided and Follow recommendation require confirmation; Fully automatic can proceed only when the current request states an explicit objective and must stop when it is missing or materially ambiguous.

The mode changes decision pauses, not rigor. Every mode retains the current-journey audit, current first-party lookup, inspected Mobbin evidence, full validation, Stitch critique, and evidence requirements. `Follow your recommendation` is a one-run Follow recommendation alias. `Bypass both gates` is a one-run Fully automatic alias, not permission to infer a missing objective.

Codex must not claim a journey was inspected, guidance was current, Mobbin supports a decision, Stitch generated a proposal, or a viewport was exact without current-task evidence. A render does not prove accessibility, safe-area behavior, browser/native implementation, or physical-device compliance.

## Authorized boundary

After a Guided or Follow recommendation Stitch approval, or after a Fully automatic `meets direction` verdict, Codex may route the validated proposal. No mode authorizes source implementation, staging, deployment, release, destructive or provider changes, or work outside the authorized integration lane. Those actions require their own scoped authorization and evidence.
