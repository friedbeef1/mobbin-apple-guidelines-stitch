# Design Arc cross-platform documentation handoff

Date: 2026-08-16
Branch: `feature/design-arc-claude-code-0.4.0`

## Outcome

Design Arc is now presented as one product available for Codex and Claude Code, rather than as two products that could drift apart.

Public framing:

> One Design Arc, available for Codex and Claude Code.

The shared methodology and existing runtime packages remain unchanged. This was a documentation and positioning restructure only.

## Commits added

- `e6f3c06` — Rename the user-facing evidence modes to **Guidelines only** and **Guidelines + Benchmarks** while retaining the stored values `guidelines` and `benchmarks` for backward compatibility.
- `2eee7ea` — Add a dedicated FAQ and explain the optional Codex project home in plain language.
- `dcf3b0d` — Present Design Arc as one cross-platform product and add focused Codex and Claude Code pages.

## Documentation structure

- `README.md` — One-product positioning and platform chooser.
- `docs/getting-started.md` — Simple installation and first use.
- `docs/codex.md` — Codex installation, project home, native screen generation, Stitch escalation, and `.codex/` state.
- `docs/claude-code.md` — Claude installation, optional `CLAUDE.md` reminder, lightweight visual outputs, early Stitch recommendation, and `.claude/` state.
- `docs/faq.md` — Plain-language answers, including project homes and why Codex and Claude Code are editions of the same product.
- `docs/advanced-controls.md` — Optional commands and technical controls.

All main documentation pages link to both platform pages and the FAQ.

## Product model to preserve

Shared across both editions:

- Objective Confirmation
- Guidelines only and Guidelines + Benchmarks
- Evidence provenance and platform-guidance precedence
- Direction and Visual Proposal gates
- Complete-state validation
- Graph-assisted reasoning
- Optional Stitch workflow and three-round correction loop
- Implementation and release boundaries

Platform-specific behavior remains separate:

| Area | Codex | Claude Code |
| --- | --- | --- |
| Invocation | `$design-arc` | `/design-arc:design-arc` |
| Preferences | `.codex/design-arc.yaml` | `.claude/design-arc.yaml` |
| Return path | Optional pinned project home | Optional approved `CLAUDE.md` reminder |
| Default visuals | Static screen images and journey boards | HTML/CSS, SVG, specifications, and lightweight boards |
| Stitch | Recommend when canvas editing or sustained refinement materially helps | Recommend early for polished, editable, or exploratory mockups |

Do not merge preferences, active reviews, or runtime records across Codex and Claude Code.

## Verification completed

- Focused documentation validation passed.
- Repository-relative link validation passed.
- `git diff --check` passed.
- Full `scripts/validate.sh` completed successfully after the documentation restructure.
- A genuine isolated Claude Code marketplace install and skill-load smoke passed with Claude Code `2.1.207`, using a temporary profile that was removed afterward.

## Release boundary

Nothing from these commits was pushed, published, merged, or installed into the active Design Arc plugin by this side conversation.

The main chat should inspect the branch and current Git status before integration. Publishing, merging, pushing, or upgrading an installed plugin still requires the user’s explicit approval in the main conversation.
