# Upgrades and migration

[Home](../README.md) · [Getting started](getting-started.md) · [Using Design Arc](using-design-arc.md) · [Codex](codex.md) · [Claude Code](claude-code.md) · [FAQ](faq.md) · [Advanced controls](advanced-controls.md) · [Evidence and methodology](evidence-and-methodology.md) · [Upgrades and migration](upgrades-and-migration.md) · [Migration history](migration-history.md) · [Trust and sources](trust-limitations-and-sources.md)

How do I safely upgrade the installed Design Arc adapters today?

## Current adapter upgrades

Codex and Claude Code are independently installed adapters. Upgrading one never installs, removes, upgrades, or synchronizes the other.

| Adapter | Supported upgrade request | State that remains owned by it |
| --- | --- | --- |
| **Codex** | Ask Codex to upgrade Design Arc safely through its configured marketplace. | `.codex/design-arc.yaml`, homes, reviews, graphs, and product files |
| **Claude Code** | `claude plugin update design-arc@design-arc-marketplace` | `.claude/design-arc.yaml`, approved reminder block, reviews, graphs, and product files |

Before either change, verify the installed version, requested version, source, and route. Re-read installed state afterward instead of treating command success as proof. Start a new clean session in the adapter you changed; an already-open session keeps its pinned runtime and workflow version.

A Claude Code adapter change preserves `.claude/design-arc.yaml`, the approved `CLAUDE.md` reminder block, reviews, graphs, product files, and active sessions byte-for-byte. It also leaves all Codex state untouched. The same boundary applies in reverse to a Codex upgrade. Neither route runs project setup, imports preferences, merges reviews, or transfers project state during an adapter change.

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

An already-open review may retain its older task context. Leave it untouched; begin the next review through the runtime's own return path so the clean task or session loads the upgraded adapter. If the normal marketplace upgrade does not expose the requested version, Design Arc stops before any destructive fallback and explains the separately confirmed, restorable remove/add route.

## Claude Code upgrade details

Run the supported Claude Code update command in the Claude Code environment:

```bash
claude plugin update design-arc@design-arc-marketplace
```

Confirm the installed version and source after it completes, then open a clean Claude Code session. This changes only the Claude Code adapter. It does not alter Codex preferences, homes, reviews, graphs, product files, or active tasks.

For legacy plugin replacement, preference import, and 0.2–0.3 recovery, read [Migration history](migration-history.md).

Next: [Trust and sources](trust-limitations-and-sources.md).
