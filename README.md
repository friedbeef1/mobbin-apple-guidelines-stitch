# Mobbin - Apple Guidelines - Stitch

UI work can jump from “this feels wrong” to an attractive screen without confirming the user outcome or validating the full journey. This repository packages a Codex skill that makes that reasoning auditable: the user confirms the objective, Apple guidance supplies platform constraints, Mobbin supplies inspected journey precedent, Stitch visualizes the selected journey, and Codex keeps the evidence and decisions visible in the conversation.

It is a standalone Codex skill, not a plugin or an official Mobbin, Apple, Google, or Stitch integration.

## What the skill does

The skill takes a mobile or web journey from a confirmed product objective through an ordered, evidence-led review:

`Objective Confirmation → current-journey audit → light Apple grounding → Mobbin discovery → directions → Direction Gate → full official validation → Stitch journey → Codex evidence → render validation → Stitch Gate → authorized routing`

It stops at the relevant design gate by default. A generated proposal is not source implementation, staging, deployment, release, or device-compliance proof.

## Why each step is crucial

| Step | Why it is crucial |
| --- | --- |
| Objective Confirmation | Prevents optimization for the wrong outcome by making the user-confirmed goal the criterion. |
| Current-journey audit | Prevents redesigning an imagined product by mapping the real entry points, states, friction, and recovery paths. |
| Light Apple grounding | Prevents Mobbin examples from becoming unconstrained imitation by setting platform constraints before benchmark research. |
| Mobbin discovery | Supplies real journey precedent that Apple guidance does not provide. |
| Direction recommendations | Exposes benefits, risks, and trade-offs before generation cost is incurred. |
| Direction approval | Preserves user control over product intent before full validation and generation proceed. |
| Full official validation | Catches platform and accessibility conflicts before visualization bakes them into a proposal. |
| Complete Stitch generation | Reveals missing transitions, empty, error, and recovery states, as well as whether the journey coheres. |
| Inline Codex evidence | Makes approval possible without reconstructing the proposal in Stitch. |
| Render validation | Prevents metadata or an attractive appearance from becoming a false compliance claim. |
| Stitch approval | Prevents a generated artifact from silently becoming an implementation mandate. |
| Authorized routing | Preserves ownership, staging, and release boundaries when work moves to its proper lane. |

## Install

Install directly from the future public repository:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo friedbeef1/mobbin-apple-guidelines-stitch \
  --path skills/validating-ui-with-guidelines-and-mobbin
```

As a manual fallback, copy `skills/validating-ui-with-guidelines-and-mobbin` into your Codex skills directory. The skill becomes available on the next Codex turn.

Mobbin and Stitch access are external and are not bundled with this repository or the skill. Apple and other platform guidance are looked up as current first-party sources during use.

## Approval and ownership boundaries

The skill always requires Objective Confirmation. By default, it stops at both the Direction Gate and Stitch Gate. Saying `Follow your recommendation` allows the recommended direction to proceed, but still stops at Stitch. Saying `Bypass both gates` allows the validated design proposal to be routed after Stitch, but never authorizes source implementation, staging, deployment, release, destructive or provider changes, or work outside the authorized integration lane.

See [prompt examples](examples/prompts.md) for ready-to-use requests.

## Limitations and marks

The skill helps assess a design proposal; it does not prove a native or browser implementation, accessibility, safe-area behavior, or physical-device behavior. It also cannot claim current guidance, Mobbin precedent, or Stitch generation without the corresponding current-turn evidence.

Mobbin, Apple, Google, and Stitch marks belong to their respective owners. No affiliation with or endorsement by those owners is implied.

## License

This project is licensed under the [MIT License](LICENSE).
