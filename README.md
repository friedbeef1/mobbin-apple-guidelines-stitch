# Design Arc

One Design Arc, available for Codex and Claude Code.

Product feedback is often vague, redesign discussions become subjective, and teams approve attractive screens without knowing whether the complete journey works.
Move from uncertain product feedback to a complete design direction grounded in credible sources.
Design Arc audits the real journey, checks decisions against current first-party platform guidance and inspected real-product journeys, recommends the strongest path, and designs every important state before implementation begins.

## Documentation

| Page | What it covers |
| --- | --- |
| [Getting started](docs/getting-started.md) | Simple installation and first use. |
| [Using Design Arc](docs/using-design-arc.md) | Project homes, approvals, and everyday review work. |
| [Design Arc for Codex](docs/codex.md) | Codex installation, project homes, visuals, and return path. |
| [Design Arc for Claude Code](docs/claude-code.md) | Claude installation, project reminders, visuals, and return path. |
| [FAQ](docs/faq.md) | Plain-language answers about project homes, commands, and returning later. |
| [Advanced controls](docs/advanced-controls.md) | Optional commands, graph controls, and technical troubleshooting. |
| [Evidence and methodology](docs/evidence-and-methodology.md) | Evidence modes, complete states, motion, and validation. |
| [Upgrades and migration](docs/upgrades-and-migration.md) | Safe upgrades, preservation, and legacy preferences. |
| [Trust and sources](docs/trust-limitations-and-sources.md) | Boundaries, limitations, and trusted sources. |

## One product, two platform editions

Choose the edition for the place where you already work. Both editions use the same Design Arc methodology, evidence rules, and approval gates.

| Use | Choose it when | Start Design Arc |
| --- | --- | --- |
| [**Codex**](docs/codex.md) | Your product work already runs in Codex and you want a pinned project home for returning later. | Ask Codex to use Design Arc. |
| [**Claude Code**](docs/claude-code.md) | Your product work runs in Claude Code and you want an optional project reminder. | Ask Claude Code to use Design Arc. |

The product and workflow are shared. Only installation, invocation, saved project state, return path, and platform-specific visualization behavior differ.

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
- Decision-ready evidence in the active Codex task or Claude Code session: journey map, key renders, identifiers, validation verdict, gate record, and next authorized owner.

## The workflow

**Only rows marked 👤 You require your involvement. Design Arc handles every unmarked step.**

| Workflow step | Platform or source handling it | Human involvement |
| --- | --- | --- |
| Describe the outcome you want | Codex or Claude Code | **👤 You** |
| ↓ | | |
| Audit the current journey | Your website or app + the active host | |
| ↓ | | |
| Gather and label evidence | Mobbin + the active host in Guidelines + Benchmarks mode, and official platform guidance + the active host in Guidelines only mode | |
| ↓ | | |
| Recommend a design direction | Codex or Claude Code | |
| ↓ | | |
| Approve design direction | Codex or Claude Code | **👤 You** |
| ↓ | | |
| Validate against platform guidance | Apple, Android, Material, or W3C guidance + the active host | |
| ↓ | | |
| Decide on any design motion | Relevant official guidance + inspected motion evidence + the active host | |
| ↓ | | |
| Visualize the complete journey | Static journey board in the active host by default; optional Google Stitch workspace | |
| ↓ | | |
| Validate every important state | Generated journey screens + the active host | |
| ↓ | | |
| Approve the visual proposal | Codex or Claude Code | **👤 You** |
| ↓ | | |
| Prepare the design handoff | Codex or Claude Code | |

Setup resolves two independent choices: how evidence is gathered and where Design Arc pauses for approval. Every route establishes the objective before inspection or research, audits the actual product, preserves platform rules, and stops at a design-only handoff boundary.

The active host produces a consolidated static journey board first, without building disposable app logic. Design Arc recommends the optional Stitch workspace early when one genuine canvas need appears—such as multi-screen editing, visual variants, another-day continuation, collaboration, or export—but you always choose whether to move.

## Install

**Ask Codex:** Install the Design Arc plugin from
https://github.com/friedbeef1/design-arc

**Ask Claude Code:** Add the Design Arc marketplace from
https://github.com/friedbeef1/design-arc and install `design-arc@design-arc-marketplace`.

Follow the exact platform commands in [Getting started](docs/getting-started.md). Installation may require download permission.

## Start a review

> Use Design Arc to help me make our onboarding less confusing.

You do not need to remember a command. Ask for Design Arc by name in either host, or choose a starter from an existing Codex project home. Design Arc guides any first-time choices in plain language. Automatic skill selection for an unprefixed request is not guaranteed.
[Learn how to use Design Arc.](docs/using-design-arc.md)

## Trust

Design Arc does not silently redesign, implement, or deploy your product. You choose the objective, evidence approach, and approval behavior.

[Evidence and methodology](docs/evidence-and-methodology.md) · [Trust and sources](docs/trust-limitations-and-sources.md)

## License

[MIT License](LICENSE)
