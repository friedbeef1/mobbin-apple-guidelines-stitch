# Codex as the operating layer

The marketplace has two independent workflows. **FB UX** (`$fb-ux`) combines official guidance, separately authorized Mobbin precedent, and separately authorized Stitch visualization. **Apple Guidelines + Stitch** (`$apple-guidelines-stitch`) uses Apple-led official guidance and separately authorized Stitch without any Mobbin dependency. Codex is where the objective, source evidence, recommendations, gate decisions, active-mode provenance, and next authorized owner remain connected.

Choose FB UX when inspected Mobbin flows are useful, authorized evidence for the decision. Choose Apple Guidelines + Stitch when first-party guidance is sufficient, Mobbin is unavailable, or the workflow must not require it. In both versions, Apple Human Interface Guidelines are the primary framework; for Android or web targets, current first-party platform rules override conflicting Apple-inspired judgment.

## What Codex contributes

- Confirms or clarifies the intended outcome before product inspection, external research, or generation.
- Audits the actual journey, including entry points, states, friction, errors, and recovery paths.
- Coordinates current first-party platform guidance with inspected Mobbin flows for FB UX, or with product context alone for Apple Guidelines + Stitch; distinguishes requirements, precedent, and product judgment; and recommends a complete journey with alternatives and trade-offs.
- Directs complete Stitch proposals, critiques actual renders, and embeds decision-ready evidence in the task instead of treating a board link or metadata as proof.
- Applies the saved project approval preference, records whether the active mode came from a saved setting, one-run override, or first-use/default selection, and routes only validated design work to the authorized Product/Captain/Integration lane.

## What Codex does not replace

The user owns the product objective, approval preference, and final design decisions. Apple and other first-party sources remain the authority for platform guidance. Mobbin and Stitch are external, separately authorized services; Apple, Google, Mobbin, and Stitch integrations are not bundled or official. FB UX needs separate authorization for Mobbin and Stitch; Apple Guidelines + Stitch needs separate authorization for Stitch only and has no Mobbin dependency. Stitch output remains a proposal, not implementation or device proof.

## Approval and evidence discipline

FB UX stores its preference in `.codex/fb-ux.yaml`; Apple Guidelines + Stitch stores its preference in `.codex/apple-guidelines-stitch.yaml`. Each selects Guided, Follow recommendation, or Fully automatic. Objective handling always happens before inspection or research: Guided and Follow recommendation require confirmation; Fully automatic can proceed only when the current request states an explicit objective and must stop when it is missing or materially ambiguous.

The mode changes decision pauses, not rigor. Every mode retains the current-journey audit, current first-party lookup, full validation, Stitch critique, and evidence requirements. FB UX additionally retains inspected Mobbin evidence; Apple Guidelines + Stitch does not perform or require a Mobbin stage. `Follow your recommendation` is a one-run Follow recommendation alias. `Bypass both gates` is a one-run Fully automatic alias, not permission to infer a missing objective.

The workflow must state whether the active mode came from the saved project preference, an explicit one-run override, or first-use/default selection. If a one-run override is active, it controls the Direction and Stitch gate record without rewriting or being attributed to the saved preference.

Codex must not claim a journey was inspected, guidance was current, Mobbin supports an FB UX decision, Stitch generated a proposal, or a viewport was exact without current-task evidence. A render does not prove accessibility, safe-area behavior, browser/native implementation, or physical-device compliance.

## Authorized boundary

After a Guided or Follow recommendation Stitch approval, or after a Fully automatic `meets direction` verdict, Codex may route the validated proposal. No mode, Mobbin access, or Stitch authorization authorizes source implementation, staging, deployment, release, destructive or provider changes, or work outside the authorized integration lane. Those actions require their own scoped authorization and evidence.
