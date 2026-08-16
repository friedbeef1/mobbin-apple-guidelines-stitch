# Design Arc for Claude Code

[Home](../README.md) · [Getting started](getting-started.md) · [Using Design Arc](using-design-arc.md) · [Codex](codex.md) · [Claude Code](claude-code.md) · [FAQ](faq.md) · [Advanced controls](advanced-controls.md) · [Evidence and methodology](evidence-and-methodology.md) · [Upgrades and migration](upgrades-and-migration.md) · [Trust and sources](trust-limitations-and-sources.md)

Choose the Claude Code edition when your product work already happens in Claude Code.

## Install

Ask Claude Code:

> Add the Design Arc marketplace from https://github.com/friedbeef1/design-arc and install Design Arc.

Then open the product project and say:

> Use Design Arc to help me improve our onboarding.

That ordinary-language request is the recommended start. The reliable command shortcut is `/design-arc:design-arc`; the paired Codex form is `$design-arc`. You do not need either command for ordinary use when you ask for Design Arc by name.

## What Claude Code adds

- An optional, approved `CLAUDE.md` reminder so the project retains a visible Design Arc entry point.
- Lightweight HTML/CSS, SVG, specifications, and static journey boards inside Claude Code.
- An early Google Stitch recommendation when polished mockups, editable layouts, visual alternatives, or continued refinement would help.
- Claude-specific preferences and review records under `.claude/`.

Claude Code does not create a Codex project home. It also does not claim native image generation or send work to Codex unless you explicitly request a cross-platform handoff.

## Returning later

With your approval, Claude Code can add one visible `CLAUDE.md` reminder block for this project. It suggests the `/design-arc:design-arc` shortcut in a later clean Claude Code session, without changing your unrelated instructions. This is a Claude Code-only reminder, not a project home.

Codex project homes remain Codex-only. For that separate return path, see [Design Arc for Codex](codex.md).

## Commands when you want them

Every shared setting has matching Claude Code and Codex syntax in [Advanced controls](advanced-controls.md). For example, use `/design-arc:design-arc evidence guidelines` in Claude Code or `$design-arc evidence guidelines` in Codex. These shortcuts are optional: “Use official guidelines only” means the same thing for the current review.

## What stays the same

The objective confirmation, credible-source grounding, evidence modes, approval gates, complete-state validation, graph-assisted reasoning, optional Stitch workflow, three-round correction loop, and implementation boundaries are the same Design Arc methodology used by the Codex edition.

Claude Code support does not imply Claude Desktop support or bundled access to Mobbin, official guidance providers, or Google Stitch. External access remains separate and authorized by you.

Commands are optional and live in [Advanced controls](advanced-controls.md).
