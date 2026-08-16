# Advanced controls

[Home](../README.md) · [Getting started](getting-started.md) · [Using Design Arc](using-design-arc.md) · [Codex](codex.md) · [Claude Code](claude-code.md) · [FAQ](faq.md) · [Advanced controls](advanced-controls.md) · [Evidence and methodology](evidence-and-methodology.md) · [Upgrades and migration](upgrades-and-migration.md) · [Trust and sources](trust-limitations-and-sources.md)

You do not need these commands for normal Design Arc use. They are optional shortcuts for people who want to inspect or change a specific setting directly. In ordinary use, describe what you want and Design Arc asks the necessary questions in plain language.

## Codex shortcuts

| Command | What it does |
| --- | --- |
| `$design-arc setup` | Review this project's saved choices. |
| `$design-arc home` | Report, create, recover, or repin the optional project home. |
| `$design-arc evidence benchmarks` | Use authorized product benchmarks plus official platform guidance. |
| `$design-arc evidence guidelines` | Use official platform guidance without benchmark research. |
| `$design-arc mode` | Report the current approval behavior. |
| `$design-arc mode guided` | Pause for design-direction and visual-proposal approval. |
| `$design-arc mode follow-recommendation` | Follow the recommended direction, then pause for the visual proposal. |
| `$design-arc mode fully-automatic` | Follow recommendations without those two pauses when the objective is explicit. |

The same actions can be requested naturally—for example, “Use official guidelines only” or “Follow your recommended direction.”

## Graph assistance

Graph assistance is optional internal reasoning support. It helps Design Arc connect evidence, requirements, screens, and correction checks. It is not an evidence source, does not add an approval gate, and is not required for a review.

Codex controls:

```text
$design-arc graph
$design-arc graph on
$design-arc graph off
$design-arc graph explain
$design-arc graph rebuild
$design-arc graph clear
$design-arc graph global off
$design-arc graph global on
```

Claude Code controls:

```text
/design-arc:design-arc graph
/design-arc:design-arc graph on
/design-arc:design-arc graph off
/design-arc:design-arc graph explain
/design-arc:design-arc graph rebuild
/design-arc:design-arc graph clear
/design-arc:design-arc graph global off
/design-arc:design-arc graph global on
```

`graph` reports state. `on` and `off` save the project choice. `global off` is a laptop safety ceiling; `global on` removes that ceiling but never forces a project on. `rebuild` reconstructs only the current review relationship record. `clear` is destructive and requires explicit confirmation for the exact graph record.

## Installation commands and troubleshooting

The normal installation path is to ask the active host to install Design Arc from the repository. These commands are fallbacks.

Claude Code:

```bash
claude plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch
claude plugin install design-arc@design-arc-marketplace
```

Codex:

```bash
codex plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch --ref main
codex plugin add design-arc@design-arc-marketplace
```

For a local checkout, replace the GitHub repository with its local path and omit the Git-only `--ref` option. Design Arc is a plugin, not a standalone skills-registry package. If Codex reports that no exact skills-registry package exists, ask it to use the plugin marketplace route above.

```bash
codex plugin marketplace add /path/to/mobbin-apple-guidelines-stitch
codex plugin add design-arc@design-arc-marketplace
```

## Saved state and upgrades

Codex preferences live in `.codex/design-arc.yaml`; Claude Code preferences live in `.claude/design-arc.yaml`. The adapters do not silently merge active reviews. Claude may offer a confirmed one-time import of portable Codex preferences when its own preference file is absent.

Upgrade commands and preservation rules are documented in [Upgrades and migration](upgrades-and-migration.md).

Next: [Evidence and methodology](evidence-and-methodology.md).
