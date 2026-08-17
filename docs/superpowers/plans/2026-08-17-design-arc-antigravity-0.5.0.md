# Design Arc 0.5.0 for Google Antigravity

## Goal

Extend Design Arc to Google Antigravity while retaining one canonical methodology and independent Codex, Claude Code, and Antigravity runtime adapters. Stop on a clean, tested, reviewed branch. Do not merge, push, publish, or upgrade installed plugins.

## Global Constraints

- Product version is `0.5.0` across all three adapters.
- Existing Codex and Claude package paths, invocation, preferences, reviews, homes/reminders, and runtime behavior remain compatible.
- Antigravity is a third thin adapter generated from the canonical methodology plus a runtime overlay.
- Antigravity support covers standalone, IDE, and CLI, but verification claims must identify the surface actually exercised.
- Antigravity preferences live at `.gemini/design-arc.yaml`; reviews and graphs live under `.gemini/design-arc/reviews/`; records identify `antigravity` as their runtime.
- Runtime state never synchronizes. First Antigravity setup may copy confirmed settings from Codex or Claude, but never merges active reviews or modifies source files.
- Antigravity creates HTML/CSS, SVG, specifications, and lightweight journey boards locally. It recommends Stitch early for polished mockups, editable layouts, alternatives, or sustained refinement, without claiming native image generation.
- Stitch remains optional, separately authorized, and is never an evidence authority. The active host validates returned screens and applies one initial proposal plus at most three proposal-wide correction rounds.
- Never direct Antigravity users to Codex or Claude unless they explicitly request a cross-platform handoff.
- Do not add agents, hooks, MCP servers, external services, or implied Mobbin/Stitch connectivity.
- Keep normal onboarding command-light. Technical commands, graph controls, and storage details remain secondary.

## Task 1: Antigravity Packaging and Canonical Composition

- Add failing expectations for a root `gemini-extension.json`, a self-contained `skills/design-arc/SKILL.md`, version `0.5.0`, and deterministic three-adapter composition.
- Add an Antigravity overlay and extend the composer/sync validator without duplicating the canonical methodology.
- Generate the Antigravity skill and update the existing Codex and Claude manifests/artifacts to `0.5.0` without changing their stable identities.
- Validate all three manifests and packaged skills independently; reject broken parent-directory references.
- Commit the bounded package/composition slice.

## Task 2: Antigravity Runtime Contracts

- Encode Antigravity invocation, setup, independent `.gemini/` state, runtime provenance, and explicitly confirmed preference import from Codex or Claude.
- If both source preferences exist, require the user to choose one. Reject malformed imports and never merge reviews or alter source runtime state.
- Enforce lightweight-board behavior, early Stitch recommendation, optional Stitch authority boundaries, complete pre-Stitch inventory, active-host validation, and the three-round correction limit.
- Add behavioral tests rejecting native image-generation claims, default Codex/Claude handoffs, missing Stitch recommendations for polished/editable requests, state leakage, and weakened workflow gates.
- Commit the bounded runtime-contract slice.

## Task 3: Cross-Platform Documentation

- Present “One Design Arc, available for Codex, Claude Code, and Google Antigravity.”
- Add Antigravity to the README platform chooser and create a focused Antigravity page covering the simple install command, `/design-arc`, supported surfaces, returning later, visualization behavior, state isolation, imports, upgrades, external authorization, and limitations.
- Keep shared pages runtime-neutral and preserve the primary path: README → Getting started → Using Design Arc → chosen platform page.
- Extend Advanced Controls and upgrade guidance with separate Antigravity columns/sections while keeping technical controls secondary.
- Preserve historical files without rewriting their original terminology and retain all repository-relative links.
- Commit the bounded documentation slice.

## Task 4: Integrated Verification and Release Checkpoint

- Test new setup, existing preferences, accepted/declined Codex and Claude imports, dual-source conflict, malformed inputs, runtime isolation, all evidence/approval combinations, graph behavior, visualization policy, gates, and correction exhaustion.
- Test upgrades and downgrades without modifying preferences, reviews, graphs, product files, homes, reminders, or active sessions.
- Run independent package/skill validation, deterministic sync, documentation checks, credential/local-path scans, complete repository validation, and `git diff --check`.
- Perform a genuine isolated `agy plugin install https://github.com/friedbeef1/design-arc` and `/design-arc` load smoke if an Antigravity CLI capable of repository plugin installation is available. If unavailable, retain deterministic package proof and record the live install smoke as an explicit release blocker rather than overstating verification.
- Obtain one independent whole-candidate review covering the three runtime perspectives. Apply at most one consolidated final repair and one scoped re-review.
- Stop on the clean reviewed branch without merge, push, publication, or installed-plugin changes.

## Task Interfaces and Dependencies

| Producer | Consumer | Contract |
| --- | --- | --- |
| Task 1 canonical composer and Antigravity artifact | Task 2 runtime tests | Runtime behavior is generated from canonical methodology plus the Antigravity overlay. |
| Task 1 package paths and manifest | Tasks 3–4 docs and install proof | Installation points at the repository root and auto-discovers `skills/design-arc/SKILL.md`. |
| Task 2 behavior terminology | Task 3 documentation | Documentation describes tested behavior without becoming its only enforcement. |
| Tasks 1–3 complete candidate | Task 4 verification | Final proof covers the integrated branch, not isolated task snapshots. |

## Release Boundary

Implementation ends on a local reviewed branch. Publishing, merging, pushing, and upgrading any installed Design Arc adapter require separate user approval.
