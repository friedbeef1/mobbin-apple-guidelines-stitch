# Design Arc 0.4.0 Codex and Claude Code Implementation Plan

> **For agentic workers:** Use `superpowers:subagent-driven-development` to implement this plan task-by-task.

**Goal:** Add a distributable Claude Code adapter while keeping one canonical Design Arc methodology and the existing Codex experience stable.

**Architecture:** Canonical shared methodology sources are composed with small Codex and Claude overlays into self-contained packaged skills. The existing Codex package path stays stable; a separate Claude plugin package and repository marketplace are added.

**Tech Stack:** Markdown skills, JSON manifests and schemas, Python and shell validators.

**Spec:** User-approved plan in the originating Codex task, reproduced by the requirements below.

## Global Constraints

- Base work on renderer-choice candidate `f695eec` and release both adapters as `0.4.0`.
- Preserve the existing Codex marketplace identity and `plugins/design-arc` path.
- Do not add agents, hooks, MCP servers, Claude Desktop support, or implied Mobbin/Stitch connectivity.
- Never alter installed plugins, publish, merge, or push during implementation.
- Claude preferences and reviews stay under `.claude`; Codex data remains untouched.
- TDD applies: add failing contract expectations before implementation.

---

### Task 1: Cross-platform contract and canonical composition

- Add failing tests for the shared-source layout, deterministic composition, self-contained packages, adapter-specific paths, and version parity.
- Add canonical methodology sources plus small Codex and Claude overlays.
- Add a deterministic composer/checker and regenerate the Codex skill without changing its approved behavior.
- Prove the packaged skills contain no references outside their plugin roots.
- Commit the independently passing slice.

### Task 2: Claude Code package and marketplace

- Add failing manifest and marketplace validation expectations.
- Add `claude-plugins/design-arc/.claude-plugin/plugin.json`, its generated `skills/design-arc/SKILL.md`, required local graph assets, and root `.claude-plugin/marketplace.json`.
- Expose `/design-arc:design-arc` with `setup`, `mode`, and `graph` arguments and natural-language activation guidance.
- Keep external tools separately authorized and declare no MCP, agent, or hook components.
- Commit the independently passing slice.

### Task 3: Claude setup, preference import, reminder, and upgrade contracts

- Add failing tests for new setup, confirmed Codex preference import, declined/malformed import, existing Claude preferences, unrelated `CLAUDE.md`, idempotent reminder insertion, denied reminder permission, and manual fallback.
- Specify `.claude/design-arc.yaml`, `.claude/design-arc/reviews/`, runtime provenance, no cross-runtime active-review merging, and byte-preserving Codex import behavior.
- Specify upgrade/downgrade preservation for preferences, reminders, reviews, graphs, product files, and active sessions.
- Commit the independently passing slice.

### Task 4: Documentation and complete verification

- Add failing documentation expectations for the Codex/Claude platform chooser, simple Claude installation, re-entry model, preference import, independent upgrades, external authorization, and Claude Code versus Desktop/MCP limits.
- Update the README and focused documentation, keeping advanced troubleshooting secondary.
- Run independent manifest and skill validation, sync checks, mutation contracts, isolated Codex and Claude installation tests where the installed CLIs support them, safety scans, full validation, and `git diff --check`.
- Commit the independently passing slice.

### Task 5: Whole-candidate review and release checkpoint

- Review the complete diff against this plan, with one consolidated repair pass only if required.
- Re-run focused and full verification after any repair.
- Confirm the branch is clean, ahead of `f695eec`, and neither pushed nor installed.
- Record the exact commits, tests, unsupported environmental proofs, and remaining risks for publication approval.
