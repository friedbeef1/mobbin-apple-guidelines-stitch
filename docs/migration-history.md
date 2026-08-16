# Migration history (legacy compatibility)

[Home](../README.md) · [Getting started](getting-started.md) · [Using Design Arc](using-design-arc.md) · [Codex](codex.md) · [Claude Code](claude-code.md) · [FAQ](faq.md) · [Runtime boundaries](runtime-boundaries.md) · [Advanced controls](advanced-controls.md) · [Evidence and methodology](evidence-and-methodology.md) · [Upgrades and migration](upgrades-and-migration.md) · [Migration history](migration-history.md) · [Trust and sources](trust-limitations-and-sources.md)

This page preserves retired replacement and recovery instructions. It is not the current upgrade path.

For current adapter upgrades and preservation rules, read [Upgrades and migration](upgrades-and-migration.md).

## Legacy 0.2 plugin replacement and preference import

Design Arc stores project choices in `.codex/design-arc.yaml`:

```yaml
evidence_mode: benchmarks
benchmark_provider: mobbin
approval_mode: guided
```

If the new file is absent, Design Arc can propose an import. `.codex/fb-ux.yaml` maps to Guidelines + Benchmarks with provider `mobbin`; `.codex/apple-guidelines-stitch.yaml` maps to Guidelines only. Each mapping preserves the former approval mode. Design Arc shows the proposed mapping and asks once before importing. If both legacy files exist, it asks which one to import or offers fresh setup. Never silently merge, rewrite, or delete either legacy preference file.

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
   codex plugin marketplace add friedbeef1/design-arc --ref main
   ```

4. Install the canonical plugin:

   ```bash
   codex plugin add design-arc@design-arc-marketplace
   ```

5. Start a new Codex task.

The legacy project preference files remain untouched for recovery even after a confirmed import.

## Historical 0.3 compatibility and recovery

### Moving to or from 0.3.0

Upgrading to 0.3.0 preserves project preferences, homes, active-review identity and workflow versions, graph records, and product files. Active reviews are not changed mid-review; a later clean review resolves the 0.3.0 default independently.

Downgrading to an older workflow leaves graph records in place but ignores them; it does not delete or reinterpret them. The downgrade likewise preserves preferences, homes, active-review identity and workflow versions, and product files. Neither direction of upgrade turns graph assistance on or off for a project merely by reading existing state.

### Upgrading from 0.3.0 to 0.3.1

Version `0.3.1` adds an activation-integrity boundary. Direct use of `$design-arc`, an explicit request to use Design Arc, or a confirmed project-home starter still begins immediately. If Codex selects the skill for an ordinary suitable request, it asks before Design Arc starts setup, inspection, evidence gathering, or record creation. Automatic selection is not guaranteed, so an unprefixed response is never presented as Design Arc work unless the skill actually loaded.

The patch does not rewrite project preferences, recreate pinned homes, change product files, alter graph records, or convert active reviews. An active review stays pinned to the workflow version under which it began; start the next review from the same home to load the upgraded plugin in a clean task.

## Historical Claude preference import

Claude Code may propose importing portable values from `.codex/design-arc.yaml` only when `.claude/design-arc.yaml` does not exist. It validates the complete portable mapping, shows the proposed values and ignored Codex-only fields, and waits for explicit import approval. Only evidence mode, a valid benchmark provider, approval mode, and graph assistance can be copied.

The operation creates Claude preferences without changing any Codex bytes. Homes, active reviews, review directories, and graph records never cross runtimes. A decline or malformed value imports nothing and routes to fresh Claude setup instead. Once Claude preferences exist, setup uses them and does not offer the import again.

Next: [Trust and sources](trust-limitations-and-sources.md).
