# FB UX Marketplace

This marketplace offers two independently installable Codex plugins for turning a UI concern into an auditable journey proposal. FB UX is a plugin containing the `fb-ux` skill; Apple Guidelines + Stitch contains the `apple-guidelines-stitch` skill. They deliberately share the same safety and approval model but differ in their evidence source:

| Choose | Use it when | Evidence model |
| --- | --- | --- |
| **FB UX** (`$fb-ux`) | You want Apple guidance, inspected product-journey precedent from Mobbin, and a Stitch proposal. | Apple and other applicable first-party guidance govern; Mobbin supplies separately authorized, inspected precedent; Stitch visualizes the selected journey. |
| **Apple Guidelines + Stitch** (`$apple-guidelines-stitch`) | You want a first-party-guidance-led review and Stitch proposal without a Mobbin account, search, or dependency. | Apple Human Interface Guidelines lead; current Android or web first-party rules override conflicting Apple-inspired judgment; Stitch visualizes the selected journey. |

Two variants exist so teams can choose the evidence they have authority and need to use. FB UX is for a review where comparative, inspected Mobbin flows add useful product precedent. Apple Guidelines + Stitch is for teams that want an official-guidance-only research path, have no Mobbin access, or must keep that external service out of the workflow. Neither variant treats a generated mockup as implementation or release proof.

Mobbin and Stitch are external services that need their own authorization. Apple, Google, Mobbin, and Stitch integrations are not bundled or official. Their marks belong to their respective owners; no affiliation with or endorsement by those owners is implied.

## Install

Paste one of these requests into Codex:

```text
Install the FB UX Codex plugin from https://github.com/friedbeef1/mobbin-apple-guidelines-stitch
```

```text
Install the Apple Guidelines + Stitch Codex plugin from https://github.com/friedbeef1/mobbin-apple-guidelines-stitch
```

Codex handles the installation and may ask for download permission. Start a new Codex task after it finishes. If both plugins are installed, invoke the one you want explicitly: `$fb-ux` for the Apple + Mobbin + Stitch workflow, or `$apple-guidelines-stitch` for the Apple-led, no-Mobbin workflow.

## What both plugins do

Both plugins establish the user’s outcome before inspection, preserve the same three approval modes, require current first-party validation, and stop at an authorized handoff boundary. Gates are decision pauses, not skipped quality checks. A generated proposal is not source implementation, staging, deployment, release, or device-compliance proof.

The workflows differ only where their evidence sources differ:

```text
FB UX: project preference → objective → audit → light Apple grounding → Mobbin discovery → directions → Direction Gate → full cross-platform validation → Stitch journey → Codex evidence → render validation → Stitch Gate → authorized routing

Apple Guidelines + Stitch: project preference → objective → audit → Apple-led official grounding → directions → Direction Gate → full cross-platform validation → Stitch journey → Codex evidence → render validation → Stitch Gate → authorized routing
```

For both, Apple Human Interface Guidelines are the primary framework. For Android or web targets, current first-party platform rules override conflicting Apple-inspired judgment.

## Codex is the operating layer

Codex establishes intent, inspects the real product, reconciles current first-party guidance with the selected evidence model, critiques the result, and makes decisions visible in the task. Read [Codex as the operating layer](docs/codex-operating-layer.md) for responsibilities that stay with Codex, the user, and external services.

## Choose how Codex should pause

Each plugin saves its own project preference: FB UX uses `.codex/fb-ux.yaml`; Apple Guidelines + Stitch uses `.codex/apple-guidelines-stitch.yaml`.

| Mode | Objective | Direction | Stitch |
| --- | --- | --- | --- |
| **Guided** — recommended for a new project | Confirm | Stop | Stop |
| **Follow recommendation** | Confirm | Automatically follow Codex's recommendation | Stop |
| **Fully automatic** | Use an explicit request objective; clarify if missing | Automatically follow Codex's recommendation | Continue only after a `meets direction` verdict |

Later runs use the saved preference. `$fb-ux mode` and `$apple-guidelines-stitch mode` report the respective mode; append `guided`, `follow-recommendation`, or `fully-automatic` to save a new one. `use Guided for this run` is a one-run override and does not replace the saved preference.

Every mode establishes the objective before inspection, audit, external research, or generation. Guided and Follow recommendation ask the user to confirm it. Fully automatic may treat an objective explicitly stated in the current request as pre-confirmed, but must stop when it is missing or materially ambiguous. The active-mode record must state whether it came from a saved project preference, an explicit one-run override, or first-use/default selection; an override must never be presented as the saved preference.

`Follow your recommendation` selects Follow recommendation as a one-run override. `Bypass both gates` selects Fully automatic as a backward-compatible one-run override, but never authorizes Codex to invent a missing objective.

## Why each step is crucial

“Performed in / by” names the primary platform, source, or decision-maker. Combined labels show where Codex orchestrates another platform or requires a person’s decision.

| Step | Performed in / by | Why it is crucial |
| --- | --- | --- |
| Project preference and provenance | Codex + user | Keeps approval pauses predictable and makes clear whether a saved setting, one-run override, or first-use choice controls the run. |
| Objective Confirmation | Codex + user | Prevents optimizing for the wrong outcome by making the user-confirmed goal the criterion. |
| Current-journey audit | Codex, using the current website or app | Prevents redesigning an imagined product by mapping real entry points, states, friction, and recovery paths. |
| Official grounding | Codex + Apple HIG and affected-platform first-party guidance | Sets governing platform constraints; Android or web first-party guidance prevails over conflicting Apple-inspired judgment. |
| Mobbin discovery — FB UX only | Codex + Mobbin | Supplies separately authorized, inspectable journey precedent that guidance alone does not provide. |
| Direction recommendations | Codex | Makes the recommended journey, alternatives, benefits, risks, and trade-offs decidable before generation cost is incurred. |
| Direction Gate | User in Codex, or active automatic mode | Preserves user control where selected and records why automatic progress is allowed where selected. |
| Full cross-platform validation | Codex + applicable first-party guidance | Catches accessibility, navigation, safe-area, and platform conflicts before visualization bakes them into a proposal. |
| Complete Stitch generation | Codex + Google Stitch | Reveals missing transitions, loading, empty, error, success, and recovery states across the whole journey. |
| Inline Codex evidence and render validation | Codex + target device or runtime | Makes the proposal reviewable in the task and prevents attractive metadata or appearance from becoming a false compliance claim. |
| Stitch Gate | User in Codex, or Fully automatic after `meets direction` | Separates a validated proposal from authority to route it, implement it, or release it. |
| Authorized routing | Codex + authorized Product/Captain/Integration lane | Preserves ownership, staging, and release boundaries when validated design work moves to its proper lane. |

## Approval, external-service, and release boundaries

The selected mode controls approval pauses only. It never skips the audit, official validation, accessibility reasoning, Stitch critique, evidence requirements, or ownership boundaries, and it never authorizes source implementation, staging, deployment, release, destructive or provider changes, or work outside the authorized integration lane.

FB UX requires separately authorized use of both Mobbin and Stitch; Mobbin is observed precedent, never a bundled integration or copy source. Apple Guidelines + Stitch has no Mobbin dependency: only Stitch is external and separately authorized. In either workflow, external-service access or payload approval does not authorize product-source changes. After the Direction and Stitch gates are satisfied, Codex may route a validated design proposal only; the authorized integration lane needs its own scope and evidence to implement, stage, deploy, or release it.

See [prompt examples](examples/prompts.md) and [behavioral validation](docs/validation/behavioral-validation.md) for copyable mode-specific requests and current scenarios.

## Advanced/manual installation

For the Codex CLI, add the repository marketplace once, then install the named plugin you need:

```bash
codex plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch --ref main
codex plugin add fb-ux@fb-ux-marketplace
codex plugin add apple-guidelines-stitch@fb-ux-marketplace
```

For a local checkout, point Codex at the repository marketplace file, then use the same exact named-plugin commands:

```bash
codex plugin marketplace add /path/to/mobbin-apple-guidelines-stitch
codex plugin add fb-ux@fb-ux-marketplace
codex plugin add apple-guidelines-stitch@fb-ux-marketplace
```

The canonical embedded-skill paths are `plugins/fb-ux/skills/fb-ux/` and `plugins/apple-guidelines-stitch/skills/apple-guidelines-stitch/`; do not copy either into a global skills directory. Begin a new Codex task after installation so it loads the plugin.

## Limitations

The plugins help assess a design proposal; they do not prove native or browser implementation, accessibility, safe-area behavior, or physical-device behavior. They also cannot claim current guidance, Mobbin precedent (FB UX only), or Stitch generation without corresponding current-task evidence.

## License

This project is licensed under the [MIT License](LICENSE).
