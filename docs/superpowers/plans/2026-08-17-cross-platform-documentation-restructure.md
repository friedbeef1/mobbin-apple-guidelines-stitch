# Cross-Platform Design Arc Documentation Restructure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the public documentation shared-first and platform-specific only where Codex and Claude Code genuinely differ.

**Architecture:** Shared pages describe the Design Arc product and workflow using Design Arc or the active host. Codex and Claude Code pages own runtime-specific installation, invocation, return paths, visual capabilities, state, and upgrade details. Historical migration instructions remain available outside the primary reading path.

**Tech Stack:** Markdown documentation, shell/Python documentation contracts, repository validation scripts.

**Spec:** User-approved plan in the main Design Arc conversation dated 2026-08-17.

## Global Constraints

- Documentation-only: do not modify plugin packages, methodology, manifests, stored preference values, runtime behavior, or version `0.4.0`.
- Preserve historical plans, specifications, handoffs, validation records, and retrospectives verbatim.
- Keep `https://github.com/friedbeef1/design-arc` as the repository URL.
- Never imply cross-runtime synchronization or claim Claude native image generation, mandatory Stitch in Codex, or default Claude-to-Codex handoff.
- Stop on a clean tested branch; do not publish, merge, or upgrade installed plugins.

---

### Task 1: Shared-first public journey and runtime boundaries

**Files:**
- Modify: `scripts/test-design-arc-docs.sh`
- Modify: `README.md`
- Modify: `docs/getting-started.md`
- Modify: `docs/using-design-arc.md`
- Modify: `docs/evidence-and-methodology.md`
- Modify: `docs/trust-limitations-and-sources.md`
- Modify: `docs/faq.md`
- Create: `docs/runtime-boundaries.md`
- Modify: `docs/codex-operating-layer.md`

**Interfaces:** Shared pages use “Design Arc” or “the active host”; runtime differences link to the platform pages. The old operating-layer path becomes a compatibility pointer to the shared boundary page.

- [ ] Add documentation assertions for the shared-first path, preserved workflow contracts, runtime-boundary page, compatibility pointer, and forbidden Codex-default phrases.
- [ ] Run `sh scripts/test-design-arc-docs.sh` and confirm the new assertions fail for missing shared-first content.
- [ ] Rewrite the shared pages, preserving Objective Confirmation, both evidence modes, both gates, platform precedence, complete-state validation, optional Stitch, three correction rounds, and implementation/release boundaries.
- [ ] Run `sh scripts/test-design-arc-docs.sh` and `git diff --check`; both must pass.
- [ ] Commit the task.

### Task 2: Platform pages, command parity, and prompt examples

**Files:**
- Modify: `scripts/test-design-arc-docs.sh`
- Modify: `docs/codex.md`
- Modify: `docs/claude-code.md`
- Modify: `docs/advanced-controls.md`
- Modify: `examples/prompts.md`

**Interfaces:** Shared actions receive paired Codex and Claude Code syntax. Project homes remain Codex-only; the approved `CLAUDE.md` reminder remains Claude-only.

- [ ] Add assertions that reject Codex-first examples, require plain-language starters, enforce command parity, and protect runtime-only exceptions and visualization claims.
- [ ] Run the focused documentation test and confirm the new assertions fail for the existing Codex-first surfaces.
- [ ] Expand the two platform pages, rewrite Advanced Controls as a paired action matrix, and make prompt examples command-free first with paired advanced syntax.
- [ ] Run `sh scripts/test-design-arc-docs.sh` and `git diff --check`; both must pass.
- [ ] Commit the task.

### Task 3: Current upgrades, historical migration archive, and navigation

**Files:**
- Modify: `scripts/test-design-arc-docs.sh`
- Modify: `docs/upgrades-and-migration.md`
- Create: `docs/migration-history.md`
- Modify: current public navigation in `README.md` and `docs/*.md`

**Interfaces:** The current upgrade page covers independent Codex and Claude Code upgrades and preservation. Legacy plugin replacement and 0.2–0.3 details move verbatim or faithfully into the historical page.

- [ ] Add assertions for the simplified current upgrade path, historical-page label, compatibility links, platform preservation, and complete public navigation.
- [ ] Run the focused documentation test and confirm the new assertions fail before the restructure.
- [ ] Move historical guidance out of the primary path, update navigation, and preserve runtime isolation and upgrade safety.
- [ ] Run `sh scripts/test-design-arc-docs.sh` and `git diff --check`; both must pass.
- [ ] Commit the task.

### Task 4: Whole-documentation verification and release checkpoint

**Files:**
- Modify only if verification reveals a real documentation defect.

**Interfaces:** Reader reviews cover a new Codex user, a new Claude Code user, and a returning non-technical user.

- [ ] Run focused documentation validation and the full `scripts/validate.sh` suite.
- [ ] Run repository-relative link, credential/local-path, package isolation, syntax, and `git diff --check` verification through the authoritative validator.
- [ ] Review the complete diff from the three reader perspectives and record concrete findings.
- [ ] Correct only verified defects, rerun affected checks, and commit any repair separately.
- [ ] Confirm the branch is clean and report that publishing and installed-plugin upgrades remain unperformed.
