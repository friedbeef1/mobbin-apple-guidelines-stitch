# Design Arc for Google Antigravity

[Home](../README.md) · [Getting started](getting-started.md) · [Using Design Arc](using-design-arc.md) · [Codex](codex.md) · [Claude Code](claude-code.md) · [Google Antigravity](antigravity.md) · [FAQ](faq.md) · [Runtime boundaries](runtime-boundaries.md) · [Advanced controls](advanced-controls.md) · [Evidence and methodology](evidence-and-methodology.md) · [Upgrades and migration](upgrades-and-migration.md) · [Migration history](migration-history.md) · [Trust and sources](trust-limitations-and-sources.md)

Choose the Google Antigravity edition when your product work already happens in Google Antigravity.

## Install

From the repository root, run:

```bash
agy plugin install https://github.com/friedbeef1/design-arc
```

Then open your product project and use `/design-arc` to begin. You can also ask Google Antigravity to use Design Arc in ordinary language; `/design-arc` is the reliable shortcut when you want certainty.

## Where it works

The same workflow is supported in Google Antigravity standalone, IDE, and CLI surfaces when that surface has loaded this extension. Use the edition where you are already working; Design Arc does not send work to Codex or Claude Code unless you explicitly request a cross-platform handoff.

The repository test suite validates the packaged Antigravity adapter and its written contracts. It does not by itself prove a plugin install or `/design-arc` load on standalone, IDE, or CLI. Any install-and-load smoke result names the exact surface that was actually exercised.

## What Google Antigravity adds

- A lightweight static journey board with HTML/CSS, SVG, or specifications for the default route.
- An early Stitch recommendation when polished mockups, editable layouts, visual alternatives, or continued refinement would help.
- Google Antigravity-specific preferences, reviews, and graphs under `.gemini/`.

Google Antigravity does not claim native image generation or build disposable application logic merely to visualize the proposal. Stitch remains optional and separately authorized. Before it is used, Design Arc prepares the complete evidence-grounded journey, requirements, and important-state inventory; the active host validates returned screens and uses the shared proposal-wide correction limit of at most three rounds.

## State and returning later

Google Antigravity owns `.gemini/design-arc.yaml`, `.gemini/design-arc-active-review.json`, and review artifacts under `.gemini/design-arc/reviews/`. In a later clean Google Antigravity session, open the same project and use `/design-arc` again. It has no Codex project home or Claude Code reminder.

Never import, merge, migrate, resume, or continue an active review across runtimes. Every Antigravity review record identifies `runtime: antigravity`; Codex and Claude Code records remain owned by their original runtimes.

## Import portable preferences

Only when `.gemini/design-arc.yaml` is absent can Design Arc offer a one-time, explicitly confirmed preference import from Codex or Claude Code. It validates and proposes only evidence mode, a valid benchmark provider, approval mode, and graph assistance; source-specific homes, reminders, active reviews, review artifacts, graphs, tasks, and sessions remain untouched.

If both source preferences exist, choose exactly one validated source; Design Arc never merges them. Declining, selecting no source, or finding a malformed source changes nothing and continues with fresh Antigravity setup.

## Upgrade

Use a supported Google Antigravity extension update route. Confirm the installed and requested versions, source, and route before changing the extension, then re-read the installed state afterward. The upgrade preserves `.gemini/design-arc.yaml`, active-review records, review artifacts, graphs, product files, and active sessions byte-for-byte; it does not rerun setup, import preferences, or continue an active review.

Start the next review in a clean Google Antigravity session. A running session stays pinned to its existing runtime and workflow version.

## Authorization and limitations

The extension installation does not authorize benchmark, browser, visualization, MCP, provider, or product access. Each external service and any data sent to it requires its own authorization. Design Arc bundles no MCP server, and a board or Stitch proposal is not evidence of accessibility, runtime behavior, physical-device quality, implementation readiness, deployment, or release.

For the shared workflow, read [Using Design Arc](using-design-arc.md). Commands beyond `/design-arc` are intentionally secondary in [Advanced controls](advanced-controls.md).
