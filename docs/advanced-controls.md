# Advanced controls

[Home](../README.md) · [Getting started](getting-started.md) · [Using Design Arc](using-design-arc.md) · [Codex](codex.md) · [Claude Code](claude-code.md) · [FAQ](faq.md) · [Runtime boundaries](runtime-boundaries.md) · [Advanced controls](advanced-controls.md) · [Evidence and methodology](evidence-and-methodology.md) · [Upgrades and migration](upgrades-and-migration.md) · [Migration history](migration-history.md) · [Trust and sources](trust-limitations-and-sources.md)

You do not need these commands for normal Design Arc use. Start by describing the outcome in ordinary language; Design Arc asks the necessary questions. The command forms below are optional shortcuts for the same shared actions.

## Shared action matrix

| Action | Ask in ordinary language | Codex | Claude Code |
| --- | --- | --- | --- |
| Start a review | “Use Design Arc to help me improve our onboarding.” | `$design-arc` | `/design-arc:design-arc` |
| Review setup | “Show this project’s Design Arc choices.” | `$design-arc setup` | `/design-arc:design-arc setup` |
| Upgrade safely | “Upgrade Design Arc safely.” | `$design-arc upgrade` | `/design-arc:design-arc upgrade` |
| Use Guidelines + Benchmarks | “Use authorized benchmarks and official guidance.” | `$design-arc evidence benchmarks` | `/design-arc:design-arc evidence benchmarks` |
| Use Guidelines only | “Use official guidelines only.” | `$design-arc evidence guidelines` | `/design-arc:design-arc evidence guidelines` |
| Report approval behavior | “What approval mode is active?” | `$design-arc mode` | `/design-arc:design-arc mode` |
| Save Guided | “Pause for both approvals in this project.” | `$design-arc mode guided` | `/design-arc:design-arc mode guided` |
| Save Follow recommendation | “Follow the recommendation, then show me the visual proposal.” | `$design-arc mode follow-recommendation` | `/design-arc:design-arc mode follow-recommendation` |
| Save Fully automatic | “Bypass both gates for this explicit objective.” | `$design-arc mode fully-automatic` | `/design-arc:design-arc mode fully-automatic` |

A natural-language request such as “use Guidelines only for this run” or “follow your recommendation this time” changes only the current review unless you explicitly ask to save it.

## Graph assistance matrix

Graph assistance is optional internal reasoning support. It connects evidence, requirements, screens, and correction checks; it is not an evidence source, does not add an approval gate, and is not required for a review.

| Action | Ask in ordinary language | Codex | Claude Code |
| --- | --- | --- | --- |
| Report graph state | “Is graph assistance active for this review?” | `$design-arc graph` | `/design-arc:design-arc graph` |
| Save this project on | “Turn graph assistance on for this project.” | `$design-arc graph on` | `/design-arc:design-arc graph on` |
| Save this project off | “Turn graph assistance off for this project.” | `$design-arc graph off` | `/design-arc:design-arc graph off` |
| Explain state | “Explain why graph assistance has this state.” | `$design-arc graph explain` | `/design-arc:design-arc graph explain` |
| Rebuild this review | “Rebuild this review’s graph from the current workflow evidence.” | `$design-arc graph rebuild` | `/design-arc:design-arc graph rebuild` |
| Clear this review | “Clear this review’s graph; ask me to confirm first.” | `$design-arc graph clear` | `/design-arc:design-arc graph clear` |
| Set laptop safety off | “Turn graph assistance off on this laptop.” | `$design-arc graph global off` | `/design-arc:design-arc graph global off` |
| Remove laptop safety ceiling | “Remove the laptop-wide graph safety ceiling.” | `$design-arc graph global on` | `/design-arc:design-arc graph global on` |

`graph` reports state. `on` and `off` save the project choice. `global off` is a laptop safety ceiling; `global on` removes that ceiling but never forces a project on. `rebuild` reconstructs only the current review relationship record. `clear` is destructive and requires explicit confirmation for the exact graph record.

## Runtime-only return paths

These are intentionally not paired commands.

| Action | Codex | Claude Code |
| --- | --- | --- |
| Return through a project home | `$design-arc home` | Not available; Claude Code does not create a project home. |
| Add a project reminder | Not available; Codex does not use a `CLAUDE.md` reminder. | Optional approved `CLAUDE.md` reminder; no command. |

`$design-arc home` reports, creates, recovers, or repins the optional Codex project home after the required confirmation. The optional Claude Code reminder never creates a Codex home and preserves unrelated `CLAUDE.md` content. Read the [Codex](codex.md) and [Claude Code](claude-code.md) pages for the exact return-path boundaries.

## Installation commands and troubleshooting

The normal installation path is to ask the active host to install Design Arc from the repository. These commands are fallbacks.

Claude Code:

```bash
claude plugin marketplace add friedbeef1/design-arc
claude plugin install design-arc@design-arc-marketplace
```

Codex:

```bash
codex plugin marketplace add friedbeef1/design-arc --ref main
codex plugin add design-arc@design-arc-marketplace
```

For a local checkout, replace the GitHub repository with its local path and omit the Git-only `--ref` option. Design Arc is a plugin, not a standalone skills-registry package. If Codex reports that no exact skills-registry package exists, ask it to use the plugin marketplace route above.

```bash
codex plugin marketplace add /path/to/design-arc
codex plugin add design-arc@design-arc-marketplace
```

## Saved state and upgrades

Codex preferences live in `.codex/design-arc.yaml`; Claude Code preferences live in `.claude/design-arc.yaml`. The adapters do not silently merge active reviews. Claude may offer a confirmed one-time import of portable Codex preferences when its own preference file is absent.

Upgrade commands and preservation rules are documented in [Upgrades and migration](upgrades-and-migration.md).

Next: [Evidence and methodology](evidence-and-methodology.md).
