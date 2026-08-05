# FB UX

FB UX is a Codex plugin containing the `fb-ux` skill, available at [its canonical plugin path](plugins/fb-ux/skills/fb-ux/). It turns a subjective UI concern into an auditable product-design process: confirm the outcome, inspect the actual journey, ground decisions in current first-party guidance and observed precedent, visualize the complete journey, and preserve the approval and ownership boundaries before implementation.

Mobbin and Stitch are external services that need their own authorization. Apple, Google, Mobbin, and Stitch integrations are not bundled or official. Their marks belong to their respective owners; no affiliation with or endorsement by those owners is implied.

## Install

Paste this request into Codex:

```text
Install the FB UX Codex plugin from https://github.com/friedbeef1/mobbin-apple-guidelines-stitch
```

Codex handles the installation and may ask for download permission. Start a new Codex task after it finishes, then invoke the embedded skill with `$fb-ux`.

## What the plugin does

FB UX takes a mobile or web journey through an ordered, evidence-led review. The project's saved approval preference controls where Codex pauses:

`project preference → objective → current-journey audit → light Apple grounding → Mobbin discovery → directions → Direction Gate policy → full official validation → Stitch journey → Codex evidence → render validation → Stitch Gate policy → authorized routing`

Gates are decision pauses, not skipped quality checks. A generated proposal is not source implementation, staging, deployment, release, or device-compliance proof.

## Codex is the operating layer

Codex establishes intent, inspects the real product, coordinates first-party guidance, Mobbin precedent, and Stitch generation, resolves their conflicts, critiques the result, and makes the evidence and decisions visible in the task. Read [Codex as the operating layer](docs/codex-operating-layer.md) for the responsibilities that stay with Codex and those that stay with the user and external services.

## Choose how Codex should pause

On first use in a project, FB UX asks the user to choose an approval mode and saves it in `.codex/fb-ux.yaml`:

| Mode | Objective | Direction | Stitch |
| --- | --- | --- | --- |
| **Guided** — recommended for a new project | Confirm | Stop | Stop |
| **Follow recommendation** | Confirm | Automatically follow Codex's recommendation | Stop |
| **Fully automatic** | Use an explicit request objective; clarify if missing | Automatically follow Codex's recommendation | Continue only after a `meets direction` verdict |

Later runs use the saved project preference. `$fb-ux mode` reports it; `$fb-ux mode guided`, `$fb-ux mode follow-recommendation`, and `$fb-ux mode fully-automatic` change it. `use Guided for this run` is a one-run override and does not replace the saved preference.

Every mode establishes the objective before inspection, audit, or external research. Guided and Follow recommendation ask the user to confirm it. Fully automatic may treat an objective explicitly stated in the current request as pre-confirmed, but must stop when it is missing or materially ambiguous.

## Establish the objective

Before product inspection, external research, or generation, FB UX establishes the outcome the journey should achieve. When useful context is available, it offers two or three mutually distinct objectives and always permits a free-form objective. The established objective remains the evaluation criterion throughout the run; neither design-gate mode authorizes Codex to invent a missing objective.

## Why each step is crucial

“Performed in / by” names the primary platform, source, or decision-maker for each step. Combined labels show where Codex orchestrates another platform or requires a person’s decision.

| Step | Performed in / by | Why it is crucial |
| --- | --- | --- |
| Objective Confirmation | Codex + user | Prevents optimization for the wrong outcome by making the user-confirmed goal the criterion. |
| Current-journey audit | Codex, using the current website or app | Prevents redesigning an imagined product by mapping real entry points, states, friction, and recovery paths. |
| Light Apple grounding | Codex + Apple Human Interface Guidelines | Prevents precedent from becoming unconstrained imitation by setting platform constraints first. |
| Mobbin discovery | Codex + Mobbin | Supplies inspectable journey precedent that guidance alone does not provide. |
| Direction recommendations | Codex, synthesizing Apple and Mobbin evidence | Exposes benefits, risks, and trade-offs before generation cost is incurred. |
| Direction approval | User in Codex | Preserves user control over product intent before full validation and generation proceed. |
| Full official validation | Codex + applicable first-party guidelines | Catches platform and accessibility conflicts before visualization bakes them into a proposal. |
| Complete Stitch generation | Codex + Google Stitch | Reveals missing transitions, empty, error, and recovery states, and whether the journey coheres. |
| Inline Codex evidence | Codex task | Makes approval possible without reconstructing the proposal in Stitch. |
| Render validation | Codex + target device or runtime | Prevents metadata or attractive appearance from becoming a false compliance claim. |
| Stitch approval | User in Codex, with the Stitch board as supporting evidence | Prevents a generated artifact from silently becoming an implementation mandate. |
| Authorized routing | Codex + authorized Product/Captain/Integration lane | Preserves ownership, staging, and release boundaries when work moves to its proper lane. |

## Approval and ownership boundaries

Guided is the fallback when no preference can be established. `Follow your recommendation` selects Follow recommendation as a one-run override. `Bypass both gates` selects Fully automatic as a backward-compatible one-run override. Fully automatic continues through Stitch only after a `meets direction` verdict; otherwise Codex stops with corrections or blockers.

The selected mode controls approval pauses only. It never skips research, official validation, accessibility reasoning, Stitch critique, or evidence requirements, and it never authorizes source implementation, staging, deployment, release, destructive or provider changes, or work outside the authorized integration lane.

See [prompt examples](examples/prompts.md) for ready-to-use requests.

## Advanced/manual installation

For the Codex CLI, add the repository marketplace and install the named plugin:

```bash
codex plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch --ref main
codex plugin add fb-ux@fb-ux-marketplace
```

For a local checkout, point Codex at the repository's marketplace file, then install the same plugin:

```bash
codex plugin marketplace add /path/to/mobbin-apple-guidelines-stitch
codex plugin add fb-ux@fb-ux-marketplace
```

The canonical embedded-skill path is `plugins/fb-ux/skills/fb-ux/`; do not copy it into a global skills directory. Begin a new Codex task after installation so it loads the plugin.

## Limitations

FB UX helps assess a design proposal; it does not prove a native or browser implementation, accessibility, safe-area behavior, or physical-device behavior. It also cannot claim current guidance, Mobbin precedent, or Stitch generation without corresponding current-task evidence.

## License

This project is licensed under the [MIT License](LICENSE).
