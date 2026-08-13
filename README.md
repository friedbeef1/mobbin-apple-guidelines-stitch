# Design Arc

Product feedback is often vague, redesign discussions become subjective, and teams approve attractive screens without knowing whether the complete journey works.
Move from uncertain product feedback to a complete design direction grounded in credible sources.
Design Arc audits the real journey, checks decisions against current first-party platform guidance and inspected real-product journeys, recommends the strongest path, and designs every important state before implementation begins.

## Documentation

| Page | What it covers |
| --- | --- |
| [Getting started](docs/getting-started.md) | Installation, first use, and troubleshooting. |
| [Using Design Arc](docs/using-design-arc.md) | Project homes, approvals, and everyday review work. |
| [Evidence and methodology](docs/evidence-and-methodology.md) | Evidence modes, complete states, motion, and validation. |
| [Upgrades and migration](docs/upgrades-and-migration.md) | Safe upgrades, preservation, and legacy preferences. |
| [Trust and sources](docs/trust-limitations-and-sources.md) | Boundaries, limitations, and trusted sources. |

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

**Only rows marked 👤 You require your involvement. Design Arc handles every unmarked step.**

| Workflow step | Platform or source handling it | Human involvement |
| --- | --- | --- |
| Describe the outcome you want | Codex | **👤 You** |
| ↓ | | |
| Audit the current journey | Your website or app + Codex | |
| ↓ | | |
| Gather and label evidence | Mobbin + Codex in Benchmarks mode, and official platform guidance + Codex in Guidelines mode | |
| ↓ | | |
| Recommend a design direction | Codex | |
| ↓ | | |
| Approve design direction | Codex | **👤 You** |
| ↓ | | |
| Validate against platform guidance | Apple, Android, Material, or W3C guidance + Codex | |
| ↓ | | |
| Decide on any design motion | Relevant official guidance + inspected motion evidence + Codex | |
| ↓ | | |
| Visualize the complete journey | Codex-generated static journey board by default; optional Google Stitch workspace | |
| ↓ | | |
| Validate every important state | Generated journey screens + Codex | |
| ↓ | | |
| Approve the visual proposal | Codex | **👤 You** |
| ↓ | | |
| Prepare the design handoff | Codex | |

Setup resolves two independent choices: how evidence is gathered and where Codex pauses for approval. Every route establishes the objective before inspection or research, audits the actual product, preserves platform rules, and stops at a design-only handoff boundary.

Codex produces a consolidated static journey board first, without building disposable app logic. Design Arc recommends the optional Stitch workspace early when one genuine canvas need appears—such as multi-screen editing, visual variants, another-day continuation, collaboration, or export—but you always choose whether to move.

## Install

**Ask Codex:** Install the Design Arc plugin from
https://github.com/friedbeef1/mobbin-apple-guidelines-stitch

Codex handles the installation and may request download permission.

## Start a review

`$design-arc` Help me make our onboarding less confusing.

Use `$design-arc`, ask for Design Arc by name, or choose a starter from the project home. Codex may recognize an unprefixed journey request and offer Design Arc, but automatic skill selection is not guaranteed.
[Learn how to use Design Arc.](docs/using-design-arc.md)

## Trust

Design Arc does not silently redesign, implement, or deploy your product. You choose the objective, evidence approach, and approval behavior.

[Evidence and methodology](docs/evidence-and-methodology.md) · [Trust and sources](docs/trust-limitations-and-sources.md)

## License

[MIT License](LICENSE)
