---
name: design-arc
description: Use when a mobile or web product journey feels confusing, incomplete, inconsistent, or subject to taste-based redesign debate, or when a team needs evidence-backed directions and complete material states before implementation.
argument-hint: "[setup|mode|graph] [options]"
user-invocable: true
---

## Claude Code entry points

Use `/design-arc:design-arc setup` to resolve Design Arc setup,
`/design-arc:design-arc mode` to report or change approval mode, and
`/design-arc:design-arc graph` to report or manage graph assistance. The
same workflow applies when a natural-language request explicitly asks to use
Design Arc or describes a journey review; do not require slash-command syntax.

External tools and services remain separately authorized. This plugin bundles
no MCP server, agent, or hook and does not imply connectivity to a benchmark,
visualization, or other external service.
