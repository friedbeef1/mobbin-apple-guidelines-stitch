# Design Arc for Codex

[Home](../README.md) · [Getting started](getting-started.md) · [Using Design Arc](using-design-arc.md) · [Codex](codex.md) · [Claude Code](claude-code.md) · [FAQ](faq.md) · [Runtime boundaries](runtime-boundaries.md) · [Advanced controls](advanced-controls.md) · [Evidence and methodology](evidence-and-methodology.md) · [Upgrades and migration](upgrades-and-migration.md) · [Migration history](migration-history.md) · [Trust and sources](trust-limitations-and-sources.md)

Choose the Codex edition when your product work already happens in Codex.

## Install

Ask Codex:

> Install the Design Arc plugin from https://github.com/friedbeef1/design-arc

Then open the product project and say:

> Use Design Arc to help me improve our onboarding.

That ordinary-language request is the recommended start. If you prefer a shortcut, use `$design-arc`; the paired Claude Code form is `/design-arc:design-arc`.

## What Codex adds

- A pinned project home, created only with your approval, so Design Arc is easy to find later.
- Static screen images and complete journey boards directly in Codex by default.
- Optional Google Stitch escalation when canvas editing, alternatives, collaboration, or sustained visual refinement would materially help.
- Codex-specific preferences and review records under `.codex/`.

## Returning later

With your approval, Codex can create one pinned project home for this saved product. It is a launchpad for plain-language starters: each starter opens a clean local task in the same project. Use `$design-arc home` only when you want to inspect, create, recover, or repin that Codex-only return path.

Claude Code has no project home. Its separate, optional return aid is an approved `CLAUDE.md` reminder; see [Design Arc for Claude Code](claude-code.md).

## Commands when you want them

Every shared setting has matching Codex and Claude Code syntax in [Advanced controls](advanced-controls.md). For example, use `$design-arc evidence guidelines` in Codex or `/design-arc:design-arc evidence guidelines` in Claude Code. These shortcuts are optional: “Use official guidelines only” means the same thing for the current review.

## What stays the same

The objective confirmation, credible-source grounding, evidence modes, approval gates, complete-state validation, graph-assisted reasoning, optional Stitch workflow, three-round correction loop, and implementation boundaries are the same Design Arc methodology used by the Claude Code edition.

The pinned project home is a return shortcut, not a second product or a separate copy of your application. See the [FAQ](faq.md#what-is-a-project-home) for the plain-language explanation.

Commands are optional and live in [Advanced controls](advanced-controls.md).
