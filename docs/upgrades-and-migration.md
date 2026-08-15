# Upgrades and migration

[Home](../README.md) · [Getting started](getting-started.md) · [Using Design Arc](using-design-arc.md) · [FAQ](faq.md) · [Advanced controls](advanced-controls.md) · [Evidence and methodology](evidence-and-methodology.md) · [Upgrades and migration](upgrades-and-migration.md) · [Trust and sources](trust-limitations-and-sources.md)

What happens when Design Arc is upgraded or replaces an older plugin?

## Upgrade Codex and Claude Code independently

The Codex and Claude Code packages share the Design Arc release version, but they are separate installations. Upgrading one adapter never installs, removes, or upgrades the other.

| Adapter | Supported upgrade request | State that remains owned by it |
| --- | --- | --- |
| **Codex** | Ask Codex to upgrade Design Arc safely through its configured marketplace. | `.codex/design-arc.yaml`, homes, reviews, graphs, and product files |
| **Claude Code** | `claude plugin update design-arc@design-arc-marketplace` | `.claude/design-arc.yaml`, approved reminder block, reviews, graphs, and product files |

Before either change, verify the installed version, requested version, source, and route. Re-read installed state afterward instead of treating command success as proof. Start a new clean session in the adapter you changed; an already-open session keeps its pinned runtime and workflow version.

A Claude Code adapter change preserves `.claude/design-arc.yaml`, the approved `CLAUDE.md` reminder block, reviews, graphs, product files, and active sessions byte-for-byte. It also leaves all Codex state untouched. The same boundary applies in reverse to a Codex upgrade. Neither route runs project setup or imports preferences during an adapter change.

## Codex upgrade details

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

### Moving to or from 0.3.0

Upgrading to 0.3.0 preserves project preferences, homes, active-review identity and workflow versions, graph records, and product files. Active reviews are not changed mid-review; a later clean review resolves the 0.3.0 default independently.

Downgrading to an older workflow leaves graph records in place but ignores them; it does not delete or reinterpret them. The downgrade likewise preserves preferences, homes, active-review identity and workflow versions, and product files. Neither direction of upgrade turns graph assistance on or off for a project merely by reading existing state.

### Upgrading from 0.3.0 to 0.3.1

Version `0.3.1` adds an activation-integrity boundary. Direct use of `$design-arc`, an explicit request to use Design Arc, or a confirmed project-home starter still begins immediately. If Codex selects the skill for an ordinary suitable request, it asks before Design Arc starts setup, inspection, evidence gathering, or record creation. Automatic selection is not guaranteed, so an unprefixed response is never presented as Design Arc work unless the skill actually loaded.

The patch does not rewrite project preferences, recreate pinned homes, change product files, alter graph records, or convert active reviews. An active review stays pinned to the workflow version under which it began; start the next review from the same home to load the upgraded plugin in a clean task.

## Saved preferences and migration

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
   codex plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch --ref main
   ```

4. Install the canonical plugin:

   ```bash
   codex plugin add design-arc@design-arc-marketplace
   ```

5. Start a new Codex task.

The legacy project preference files remain untouched for recovery even after a confirmed import.

## Claude preference import is one-time and optional

Claude Code may propose importing portable values from `.codex/design-arc.yaml` only when `.claude/design-arc.yaml` does not exist. It validates the complete portable mapping, shows the proposed values and ignored Codex-only fields, and waits for explicit import approval. Only evidence mode, a valid benchmark provider, approval mode, and graph assistance can be copied.

The operation creates Claude preferences without changing any Codex bytes. Homes, active reviews, review directories, and graph records never cross runtimes. A decline or malformed value imports nothing and routes to fresh Claude setup instead. Once Claude preferences exist, setup uses them and does not offer the import again.

Next: [Trust and sources](trust-limitations-and-sources.md).
