# Getting started

[Home](../README.md) · [Getting started](getting-started.md) · [Using Design Arc](using-design-arc.md) · [Evidence and methodology](evidence-and-methodology.md) · [Upgrades and migration](upgrades-and-migration.md) · [Trust and sources](trust-limitations-and-sources.md)

How do I install Design Arc and begin my first review?

> **Ask Codex:** Install the Design Arc plugin from https://github.com/friedbeef1/mobbin-apple-guidelines-stitch

## Install and set up in 60 seconds

Design Arc is installed once for your Codex profile. Each participating project keeps its own setup and may have one approved, pinned home.

Paste this complete instruction into Codex:

```text
Install Design Arc as a Codex plugin, not as a standalone skill. Add https://github.com/friedbeef1/mobbin-apple-guidelines-stitch as a plugin marketplace using ref `main`, then install `design-arc@design-arc-marketplace`. Do not search skills.sh or the standalone skills registry. Use the terminal commands below; do not use the built-in plugin-install control or `request_plugin_install`. Ask me for download permission if required, verify the plugin is enabled, and tell me to start a new task.
```

These are the two commands Codex should execute:

```bash
codex plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch --ref main
codex plugin install design-arc@design-arc-marketplace
```

No Python knowledge is required. Codex may ask for download permission. Start a new Codex task after installation, then run:

```text
$design-arc setup
```

On first use, Design Arc independently asks you to choose an evidence mode and an approval mode, shows the proposed `.codex/design-arc.yaml` values, and asks before saving them. Benchmarks and Guided are the recommended first-use choices when relevant external access is available and the product direction is new.

### If Codex says “no exact package exists in the skills registry”

That response means Codex used the wrong installation route. Design Arc is a plugin in `design-arc-marketplace`, not a standalone skills.sh package. Paste the complete instruction above, or run the two plugin commands directly. Do not substitute an unrelated skill.

If Codex says the plugin is not in the permitted recommended-plugin list, it used the built-in plugin-install control instead of the terminal commands. Paste the complete instruction again and explicitly approve the scoped `codex plugin marketplace add` and `codex plugin install` terminal commands when Codex asks.

### Local-checkout fallback

For a local checkout, add the directory without the Git-only `--ref` option, then install the same plugin:

```bash
codex plugin marketplace add /path/to/mobbin-apple-guidelines-stitch
codex plugin install design-arc@design-arc-marketplace
```

The canonical embedded skill is `plugins/design-arc/skills/design-arc/`; do not copy it into a global skills directory. Begin a new Codex task so the plugin is loaded.

Next: [Using Design Arc](using-design-arc.md).
