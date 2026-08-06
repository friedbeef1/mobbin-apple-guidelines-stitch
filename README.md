# Design Arc

Product feedback is often vague, redesign discussions become subjective, and teams approve attractive screens without knowing whether the complete journey works.

**Move from uncertain product feedback to a complete, evidence-backed design direction.**<br>
Design Arc audits the real journey, explores meaningful alternatives, recommends the strongest path, and designs every important state before implementation begins.

It turns comments such as “this feels confusing” into a product objective, an auditable journey diagnosis, meaningful alternatives, one clear recommendation, and a complete design proposal that can be evaluated before implementation starts.

## You need Design Arc if…

- Feedback such as “this feels confusing” keeps producing circular discussion instead of a testable product decision.
- Stakeholders disagree based on taste because no shared objective or evidence distinguishes the alternatives.
- Redesigns improve isolated screens without proving the complete journey, transitions, or recovery paths.
- Loading, empty, error, success, and recovery states are repeatedly omitted until implementation.
- Your team wants a strong recommendation without surrendering approval control.

## What Design Arc produces

- A confirmed product objective and the criterion used to judge every finding.
- An audit of the real current journey, including friction, transitions, exits, and non-happy states.
- Evidence appropriate to the product and platform, with current links, limitations, and observed-versus-inferred status.
- One unmistakably recommended direction plus meaningful alternatives, benefits, risks, and trade-offs.
- A complete visual proposal covering entry, transition, loading, empty, error, success, cancellation, and recovery states.
- Decision-ready evidence in the Codex task: journey map, key renders, identifiers, validation verdict, gate record, and next authorized owner.

## The workflow

```text
setup → objective → current-journey audit → evidence → directions
      → Direction Gate → full first-party validation → complete visual journey
      → render validation → Visual Gate → authorized design handoff
```

Setup resolves two independent choices: how evidence is gathered and where Codex pauses for approval. Every route establishes the objective before inspection or research, audits the actual product, preserves platform rules, and stops at a design-only handoff boundary.

## Example: from “confusing onboarding” to a complete direction

**Input:** “Our onboarding feels confusing.”

**Design Arc first establishes the objective:** for example, help a new user reach their first useful result with less uncertainty, while still collecting the information the product genuinely needs.

It then maps the existing entry points, choices, transitions, abandonment points, validation errors, loading behavior, success confirmation, and recovery paths. It separates observed friction from inference, compares evidence-backed alternatives, and recommends the strongest complete journey against the confirmed objective.

Instead of returning one polished welcome screen, it proposes the full sequence: entry, progressive decisions, permission timing, validation, loading, empty or unavailable cases, success, cancellation, and recovery. The direction is validated before the team treats the proposal as ready for an implementation handoff.

## Choose your evidence approach

| Evidence mode | Choose it when | What it means |
| --- | --- | --- |
| **Benchmarks** — recommended when relevant access is available | Inspected real-product journeys would add useful precedent to current platform guidance. | Design Arc inspects complete, relevant journeys, explains why each pattern helps the objective, and records limits. A library listing, popularity, metadata, or one screenshot is never proof of best-in-class quality. |
| **Guidelines** | You want a first-party-guidance-led review without benchmark research or do not have authorized benchmark access. | Design Arc performs no benchmark lookup and makes no benchmark-evidence claim. It uses current first-party guidance for every affected platform. |

The evidence choice is independent from approval behavior. Design Arc reports the active evidence mode, approval mode, and provenance of each at the start of every run.

## Install and set up in 60 seconds

Paste this into Codex:

```text
Install the Design Arc Codex plugin from https://github.com/friedbeef1/mobbin-apple-guidelines-stitch
```

Codex handles the installation and may ask for download permission. No Python knowledge is required. Start a new Codex task after installation, then run:

```text
$design-arc setup
```

On first use, Design Arc independently asks you to choose an evidence mode and an approval mode, shows the proposed `.codex/design-arc.yaml` values, and asks before saving them. Benchmarks and Guided are the recommended first-use choices when relevant external access is available and the product direction is new.

Useful commands:

```text
$design-arc evidence benchmarks
$design-arc evidence guidelines
$design-arc mode
$design-arc mode guided
$design-arc mode follow-recommendation
$design-arc mode fully-automatic
```

Natural-language requests such as “use Guidelines for this run” or “follow your recommendation this time” are one-run overrides; they do not rewrite the saved project preference.

### Advanced CLI fallback

If the natural-language installation is unavailable, use the Codex CLI:

```bash
codex plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch --ref main
codex plugin add design-arc@design-arc-marketplace
```

For a local checkout, replace the GitHub repository argument with the checkout path. The canonical embedded skill is `plugins/design-arc/skills/design-arc/`; do not copy it into a global skills directory. Begin a new Codex task so the plugin is loaded.

## Approval and trust controls

> Design Arc does not silently redesign, implement, or deploy your product. You choose the objective, evidence approach, and approval behavior.

| Approval mode | Objective | Visual Gate |
| --- | --- | --- |
| **Guided** — recommended for a new project | Confirm; stop at Direction Gate | Stop for approval |
| **Follow recommendation** | Confirm; continue at Direction Gate with the visibly marked recommendation | Stop for approval |
| **Fully automatic** | The current request must state an explicit objective; continue at Direction Gate with the visibly marked recommendation | Continue only after a `meets direction` verdict |

“Follow your recommendation” is a one-run Follow recommendation alias. “Bypass both gates” is a one-run Fully automatic alias, but it never permits Design Arc to invent a missing objective. Automatic modes change decision pauses, not the audit, evidence, complete-state, validation, or ownership requirements.

## Methodology, sources, migration, and limitations

### Why each step is crucial

“Performed in / by” names the primary platform, source, or decision-maker. Combined labels show where Codex orchestrates an external platform or requires a person’s decision.

| Step | Performed in / by | Why it is crucial |
| --- | --- | --- |
| Setup and provenance | Codex + user | Makes the evidence and approval choices independent and records whether each came from the current request, saved preference, confirmed import, or first-use selection. |
| Objective Confirmation | Codex + user | Prevents optimization for the wrong outcome by making the confirmed goal the evaluation criterion. |
| Current-journey audit | Codex, using the supplied website or app | Maps the real entry points, states, friction, transitions, exits, and recovery paths instead of redesigning an imagined product. |
| Evidence gathering | Codex + selected sources | Supplies relevant constraints or inspected precedent without confusing requirements, observations, and product judgment. |
| Direction recommendations | Codex | Makes the strongest journey, alternatives, benefits, risks, and trade-offs decidable before visualization cost is incurred. |
| Direction Gate | User in Codex, or the active automatic mode | Preserves user control where selected and records why automatic selection is allowed where selected. |
| Full cross-platform validation | Codex + affected-platform first-party guidance | Catches navigation, accessibility, safe-area, and platform conflicts before they are baked into a proposal. |
| Complete Stitch generation | Codex + Google Stitch | Exposes missing transitions and loading, empty, error, success, cancellation, and recovery states across the complete journey. |
| Inline evidence and render validation | Codex + target device or runtime | Keeps the proposal reviewable in the task and prevents attractive output or metadata from becoming a false compliance claim. |
| Stitch Gate | User in Codex, or Fully automatic after `meets direction` | Separates a validated design proposal from authority to route it, implement it, or release it. |
| Authorized routing | Codex + authorized Product/Captain/Integration owner | Preserves source, staging, deployment, and release ownership after design approval. |

### External evidence and visualization sources

Apple Human Interface Guidelines are first-party authority for Apple targets. For Android or web targets, current first-party platform rules override conflicting Apple-inspired judgment. Requirements are kept distinct from product-specific judgment.

Mobbin can be selected as a benchmark provider in Benchmarks mode. It remains an external source requiring separate access and authorization. Its examples are observed precedent, not a bundled integration or a source to copy. If access is unavailable, Design Arc stops and offers either a one-run Guidelines fallback or a confirmed saved switch; it never silently degrades or calls the result benchmark-backed.

Google Stitch is an external visualization service requiring separate access and payload authorization. The board supports deeper exploration, while Codex must still return a reviewable journey map, key renders, identifiers, and validation verdict in the task. Apple, Google, Mobbin, and Stitch access is not bundled or official, and none of those services authorizes product-source changes.

### Saved preferences and migration

Design Arc stores project choices in `.codex/design-arc.yaml`:

```yaml
evidence_mode: benchmarks
benchmark_provider: mobbin
approval_mode: guided
```

If the new file is absent, Design Arc can propose an import. `.codex/fb-ux.yaml` maps to Benchmarks with provider `mobbin`; `.codex/apple-guidelines-stitch.yaml` maps to Guidelines. Each mapping preserves the former approval mode. Design Arc shows the proposed mapping and asks once before importing. If both legacy files exist, it asks which one to import or offers fresh setup. Never silently merge, rewrite, or delete either legacy preference file.

To replace the former installed plugins, use this safe order:

1. Remove both installed legacy plugins:

   ```bash
   codex plugin remove fb-ux@fb-ux-marketplace
   codex plugin remove apple-guidelines-stitch@fb-ux-marketplace
   ```

2. Remove the former marketplace:

   ```bash
   codex plugin marketplace remove fb-ux-marketplace
   ```

3. Add the repository again so Codex reads the renamed marketplace:

   ```bash
   codex plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch --ref main
   ```

4. Install the canonical plugin:

   ```bash
   codex plugin add design-arc@design-arc-marketplace
   ```

5. Start a new Codex task.

The legacy project preference files remain untouched for recovery even after a confirmed import.

### Evidence, implementation, and release boundaries

Design Arc must not claim current product inspection, first-party guidance, benchmark evidence, new Stitch output, exact render dimensions, accessibility, safe-area behavior, native/browser behavior, or physical-device compliance without corresponding current-task proof.

A validated visual journey remains a design proposal. No evidence mode, approval mode, external-service access, provider authorization, Direction decision, or Stitch verdict authorizes source implementation, staging, deployment, live release, destructive or provider changes, or work outside the authorized integration lane. Those actions require their own scope, owner, authorization, and evidence.

### Trademarks

Apple, Google, Mobbin, and Stitch are trademarks of their respective owners. Design Arc is not affiliated with or endorsed by those owners, and no official integration is claimed.

## License

This project is licensed under the [MIT License](LICENSE).
