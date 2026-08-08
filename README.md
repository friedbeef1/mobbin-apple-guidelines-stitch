# Design Arc

Product feedback is often vague, redesign discussions become subjective, and teams approve attractive screens without knowing whether the complete journey works.

**Move from uncertain product feedback to a complete design direction grounded in credible sources.**<br>
### Grounded, not guessed

Design Arc gives teams a stronger basis for making design decisions. Instead of asking everyone to trust a polished screen or one person's taste, it connects each recommendation to the product's real journey, the rules of its platform, relevant patterns observed in complete products, and clearly labeled product judgment. That makes the proposed direction easier to understand, challenge, approve, and carry into implementation with confidence.

This matters because attractive screens can still fail when they ignore familiar platform behavior, borrow an isolated pattern without understanding the surrounding journey, or present opinion as fact. Grounding keeps the reasoning visible without pretending that a source can make the product decision for you.

| Grounding layer | Pain point | How Design Arc solves it | Credible sources used |
| --- | --- | --- | --- |
| Platform requirements | Designs can feel unfamiliar, exclude users, or conflict with platform conventions. | Validate the journey against current guidance for its actual platform. | Apple HIG; Android and Material guidance; W3C web accessibility standards. |
| Product precedent | Teams copy attractive screenshots without understanding the complete journey or failure states. | Inspect relevant end-to-end product journeys and explain why a pattern fits the objective. | Authorized benchmark research through a provider such as Mobbin. |
| Product judgment | Opinions and trade-offs can be presented as if a source proved them. | Tie recommendations to the confirmed objective and label judgment separately from observed evidence. | User-confirmed objective and documented Design Arc synthesis—not an external authority. |
| Visualization and validation | Polished screens can conceal missing transitions, errors, and recovery states. | Visualize the complete journey and inspect every important state before approving it for frontend implementation. | Google Stitch as a visualization tool—not an evidence authority. |

If you want the underlying detail, you can also [see which trusted sources Design Arc uses and why](docs/trusted-sources/README.md).

Design Arc audits the real journey, checks decisions against current first-party platform guidance and inspected real-product journeys, recommends the strongest path, and designs every important state before implementation begins.

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
      → Direction Gate → full first-party validation → motion specification
      → complete visual journey
      → render validation → Stitch Gate → authorized design handoff
```

**What you need to do:** Tell Codex what outcome you want. On first use, choose how evidence and approvals should work; later, only authorize external access or approve a gate when your chosen mode asks. Codex handles the audit, research, recommendations, platform checks, motion specification, visual journey, and validation.

Setup resolves two independent choices: how evidence is gathered and where Codex pauses for approval. Every route establishes the objective before inspection or research, audits the actual product, preserves platform rules, and stops at a design-only handoff boundary.

## Example: from “confusing onboarding” to a complete direction

**Input:** “Our onboarding feels confusing.”

**Design Arc first establishes the objective:** for example, help a new user reach their first useful result with less uncertainty, while still collecting the information the product genuinely needs.

It then maps the existing entry points, choices, transitions, abandonment points, validation errors, loading behavior, success confirmation, and recovery paths. It separates observed friction from inference, compares evidence-backed alternatives, and recommends the strongest complete journey against the confirmed objective.

Instead of returning one polished welcome screen, it proposes the full sequence: entry, progressive decisions, permission timing, validation, loading, empty or unavailable cases, success, cancellation, and recovery. The direction is validated before the team treats the proposal as ready for an implementation handoff.

## Choose how Design Arc grounds its recommendations

| Evidence mode | Choose it when | What it means |
| --- | --- | --- |
| **Benchmarks** — recommended when relevant access is available | Inspected real-product journeys would add useful precedent to current platform guidance. | Design Arc inspects complete, relevant journeys, explains why each pattern helps the objective, and records limits. A library listing, popularity, metadata, or one screenshot is never proof of best-in-class quality. |
| **Guidelines** | You want a first-party-guidance-led review without benchmark research or do not have authorized benchmark access. | Design Arc performs no benchmark lookup and makes no benchmark-evidence claim. It uses current first-party guidance for every affected platform. |

The evidence choice is independent from approval behavior. Design Arc reports the active evidence mode, approval mode, and provenance of each at the start of every run.

## Install and set up in 60 seconds

Design Arc is installed once for your Codex profile. Each participating project keeps its own setup and may have one approved, pinned home.

Paste this complete instruction into Codex:

```text
Install Design Arc as a Codex plugin, not as a standalone skill. Add https://github.com/friedbeef1/mobbin-apple-guidelines-stitch as a plugin marketplace using ref `main`, then install `design-arc@design-arc-marketplace`. Do not search skills.sh or the standalone skills registry. Use the terminal commands below; do not use the built-in plugin-install control or `request_plugin_install`. Ask me for download permission if required, verify the plugin is enabled, and tell me to start a new task.
```

These are the two commands Codex should execute:

```bash
codex plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch --ref main
codex plugin add design-arc@design-arc-marketplace
```

No Python knowledge is required. Codex may ask for download permission. Start a new Codex task after installation, then run:

```text
$design-arc setup
```

On first use, Design Arc independently asks you to choose an evidence mode and an approval mode, shows the proposed `.codex/design-arc.yaml` values, and asks before saving them. Benchmarks and Guided are the recommended first-use choices when relevant external access is available and the product direction is new.

Useful commands:

```text
$design-arc home
$design-arc evidence benchmarks
$design-arc evidence guidelines
$design-arc mode
$design-arc mode guided
$design-arc mode follow-recommendation
$design-arc mode fully-automatic
```

Natural-language requests such as “use Guidelines for this run” or “follow your recommendation this time” are one-run overrides; they do not rewrite the saved project preference.

### If Codex says “no exact package exists in the skills registry”

That response means Codex used the wrong installation route. Design Arc is a plugin in `design-arc-marketplace`, not a standalone skills.sh package. Paste the complete instruction above, or run the two plugin commands directly. Do not substitute an unrelated skill.

If Codex says the plugin is not in the permitted recommended-plugin list, it used the built-in plugin-install control instead of the terminal commands. Paste the complete instruction again and explicitly approve the scoped `codex plugin marketplace add` and `codex plugin add` terminal commands when Codex asks.

### Local-checkout fallback

For a local checkout, add the directory without the Git-only `--ref` option, then install the same plugin:

```bash
codex plugin marketplace add /path/to/mobbin-apple-guidelines-stitch
codex plugin add design-arc@design-arc-marketplace
```

The canonical embedded skill is `plugins/design-arc/skills/design-arc/`; do not copy it into a global skills directory. Begin a new Codex task so the plugin is loaded.

## Coming back tomorrow

You do not need to remember a command for ordinary journey work. Setup can add one approved, pinned home named `Design Arc — <Project Name>` to each project where you choose to use Design Arc.

| When | What you do |
| --- | --- |
| First day | Open the project, run `$design-arc setup`, choose the two project preferences, and approve or decline its proposed home. |
| Next day | Open that project’s pinned `Design Arc — <Project Name>` task and describe the journey in ordinary language. |
| New product | Open the new saved project and run setup there once. Its preferences and optional home stay separate from every other product. |

Try one of these:

- “Help me make our onboarding less confusing.”
- “Audit how customers complete checkout and propose a better complete journey.”
- “Redesign account recovery so people can get back in without weakening security.”

Each home is a launchpad, not a workspace for the design review. Every journey starter opens a clean local task in that same saved project, while the pinned home stays available for the next request.

There is no global Design Arc home. A project with no confirmed Design Arc setup receives no home and no sidebar item. Design Arc reuses an existing home for the same title and project instead of creating a duplicate. If it finds extra same-project homes, it reports them for you to clean up; it never deletes them.

If Codex cannot create or pin the task, Design Arc saves confirmed preferences, says clearly that no home is ready, and gives you the exact title, starter card, and manual create-and-pin steps. Run `$design-arc home` later to report, create, recover, or repin the current project’s home.

## Upgrade once without rebuilding projects

Tell Codex:

> Upgrade Design Arc safely. Preserve every project's preferences, pinned home, files, and active reviews.

The upgrade changes the shared Design Arc plugin on the laptop. It does not rerun setup in participating projects, recreate their homes, or rewrite `.codex/design-arc.yaml`. Existing homes remain the entry points for their original products.

### What users should expect

| Moment | What Design Arc does | What happens to projects |
| --- | --- | --- |
| Before upgrading | Reports the installed version, available version, marketplace source, and projects it can verify. | Read-only checks; no project setup or design work begins. |
| Normal upgrade | Updates the one shared Codex-profile installation and verifies the installed result. | Preferences, homes, product files, and active reviews remain untouched. |
| If the normal route fails | Stops with the current plugin intact. It explains any remove-and-reinstall fallback before asking separately for permission. | Nothing is recreated or reset while waiting for that decision. |
| After upgrading | Reports the resulting version, installed-copy count, verified preservation scope, and whether fallback was used. | Existing homes remain where they were; the next clean review uses the new plugin. |

A remove-and-reinstall fallback is never automatic. Before removal, Design Arc must have either an exact immutable commit or ref, or a verified, isolated local package backup proven to restore the exact installed version. If restoration cannot be proven, it leaves the working version installed. If fallback fails, it restores and verifies the previous version instead of leaving a partial installation.

Afterward, Design Arc reports the installed version and the preservation result. A successful zero-disruption upgrade should end with:

```text
Installed copies: 1
Project homes recreated: 0
Project preferences changed: 0
Product files changed: 0
Active reviews interrupted: 0
```

If Codex cannot inventory every project, it names the narrower scope it actually verified instead of claiming complete preservation.

An already-open review may retain its older task context. Leave it untouched; begin the next review from the same pinned home so the clean task loads the upgraded plugin. If the normal marketplace upgrade does not expose the requested version, Design Arc stops before any destructive fallback and explains the separately confirmed, restorable remove/add route.

## Approval and trust controls

> Design Arc does not silently redesign, implement, or deploy your product. You choose the objective, evidence approach, and approval behavior.

| Approval mode | Objective | Stitch Gate |
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
| Motion specification | Codex + affected-platform guidance + inspected motion evidence | Defines what moves, why, how it behaves, its reduced-motion alternative, and what still requires implementation proof. |
| Complete Stitch generation | Codex + Google Stitch | Exposes missing transitions and loading, empty, error, success, cancellation, and recovery states across the complete journey. |
| Inline evidence and render validation | Codex + target device or runtime | Keeps the proposal reviewable in the task and prevents attractive output or metadata from becoming a false compliance claim. |
| Stitch Gate | User in Codex, or Fully automatic after `meets direction` | Separates a validated design proposal from authority to route it, implement it, or release it. |
| Authorized routing | Codex + authorized Product/Captain/Integration owner | Preserves source, staging, deployment, and release ownership after design approval. |

### Motion grounding and implementation proof

Design Arc specifies material on-screen animations and screen-to-screen transitions before frontend implementation. It first checks the product's existing motion system and standard native behavior, then current first-party platform guidance, actually inspected motion precedent, and finally clearly labeled Design Arc judgment.

Every material motion, including retained native or existing behavior, gets a contract with: Motion ID; journey location; purpose; trigger; start/end state; spatial behavior; choreography; timing; easing/spring; interruption; reduced motion; evidence; provenance; implementation target; implementation source; proof status. Unsupported values are `unverified`.

Static screens or sequences support only start/end state, changing element, journey location, and transition intent; they cannot support exact duration, easing, springs, velocity, interruption, or choreography. Directly applicable native or current first-party specifications and inspected playable evidence can support temporal behavior; otherwise temporal values remain labeled Design Arc judgment or `unverified`.

Stitch prototypes are design evidence, not staging or device implementation proof. When Stitch cannot represent required motion faithfully, Design Arc returns the start and end states plus the motion contract. The authorized implementation owner later builds it with the product's actual stack and validates the result in staging or on the target device.

Each direction explains motion purpose and restraint, relevant precedent and platform guidance, provenance labels, reduced-motion implications, motion-specific risks, implementation complexity, and remaining proof. A Stitch verdict evaluates the same motion requirements and contract alignment, and `meets direction` records prototype limitations and remaining runtime proof before Fully automatic may continue.

For the nontechnical explanation of what motion evidence can establish, when a recording is needed, and why a prototype is not runtime proof, read the [motion grounding guide](docs/trusted-sources/motion.md).

### External evidence and visualization sources

Apple Human Interface Guidelines are first-party authority for Apple targets. For Android or web targets, current first-party platform rules override conflicting Apple-inspired judgment. Requirements are kept distinct from product-specific judgment.

Mobbin can be selected as a benchmark provider in Benchmarks mode. It remains an external source requiring separate access and authorization. Its examples are observed precedent, not a bundled integration or a source to copy. If access is unavailable, Design Arc stops and offers either a one-run Guidelines fallback or a confirmed saved switch; it never silently degrades or calls the result benchmark-backed.

Google Stitch is an external visualization service requiring separate access and payload authorization. The board supports deeper exploration, while Codex must still return a reviewable journey map, key renders, identifiers, and validation verdict in the task. Apple, Google, Mobbin, and Stitch access is not bundled or official, and none of those services authorizes product-source changes.

### Plugin discovery boundary

Design Arc is not listed in Codex’s built-in recommended-plugin directory. Codex CLI 0.146 introduced workspace plugin publishing, but this account exposes no `codex plugin publish` command and current official documentation provides no documented public third-party directory submission route. The GitHub marketplace commands above are therefore the canonical public installation path. Do not claim that bare-name discovery, skills.sh, or an official marketplace listing is available. See the [official Codex 0.146 update](https://learn.chatgpt.com/docs/whats-new#organize-sessions-and-extend-codex-cli-01460).

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
