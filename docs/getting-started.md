# Getting started

[Home](../README.md) · [Getting started](getting-started.md) · [Using Design Arc](using-design-arc.md) · [Evidence and methodology](evidence-and-methodology.md) · [Upgrades and migration](upgrades-and-migration.md) · [Trust and sources](trust-limitations-and-sources.md)

How do I install Design Arc and begin my first review?

## Choose your host

Choose the host where the product review will happen. The methodology is the same, but the command, saved state, and return path are intentionally separate.

| Host | Direct invocation | Project preferences | Return later |
| --- | --- | --- | --- |
| **Codex** | `$design-arc` | `.codex/design-arc.yaml` | A confirmed pinned project home |
| **Claude Code** | `/design-arc:design-arc` | `.claude/design-arc.yaml` | A clean project session; optional approved `CLAUDE.md` reminder |

Installing one adapter does not install the other. If a team uses both, install and upgrade each independently.

## Install in Claude Code

From a trusted checkout or terminal, add the repository marketplace and install its Claude Code package:

```bash
claude plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch
claude plugin install design-arc@design-arc-marketplace
```

Start a new Claude Code session, then run:

```text
/design-arc:design-arc setup
```

Claude setup offers a one-time import only when `.claude/design-arc.yaml` is absent and `.codex/design-arc.yaml` contains a completely valid portable preference mapping. It shows the proposed values, ignores Codex-only home and review state, and copies only after explicit import approval; the Codex file remains byte-for-byte unchanged. A declined or invalid import leaves Codex state untouched and continues with fresh Claude setup.

After preferences are confirmed, setup may separately propose a marked reminder for the project’s `CLAUDE.md`. Preference or import approval does not authorize a `CLAUDE.md` edit. Review the exact block and approve that write separately, or skip it and invoke Design Arc directly when needed.

For the platform’s broader marketplace and reload behavior, see [Anthropic’s plugin guide](https://code.claude.com/docs/en/discover-plugins). Design Arc’s exact commands above remain the primary installation path.

## Install in Codex

> **Ask Codex:** Install the Design Arc plugin from https://github.com/friedbeef1/mobbin-apple-guidelines-stitch

### Install and set up in 60 seconds

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

## Troubleshooting

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

For a local Claude Code checkout, replace the GitHub repository in the Claude marketplace command with the checkout path. Keep this fallback for development; normal users should prefer the simple repository command above.

Next: [Using Design Arc](using-design-arc.md).
