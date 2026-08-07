# Design Arc Project Homes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development task-by-task, with test-first changes and an independent review after each task.

**Goal:** Make installed Design Arc easy to rediscover without commands by offering one approved, pinned, project-specific launchpad while keeping concurrent products and their preferences separate.

**Architecture:** The Design Arc skill remains the only runtime capability. It uses Codex task-management tools when available to resolve the current saved project, find or create one pinned project home, and launch clean same-project design tasks. The home is an opt-in launchpad, never a global task or a place where product work accumulates. Static instruction contracts, fresh-context agent scenarios, and bounded Codex desktop acceptance checks validate the behavior.

**Baseline:** Start from clean commit `e8d27ee1bd921ff6295402a5d03ef9907963379b`, which contains an unpublished `0.2.1` installation-routing fix on top of public `8e2318496d8e2dbc3c75e19ddde997b598188755`. Preserve that commit and keep the combined release version at `0.2.1` because neither change has been published.

## Global Constraints

- Plugin/skill ID remains `design-arc`; display name remains `Design Arc`; version remains `0.2.1`.
- Installation is once per Codex profile. Project homes and `.codex/design-arc.yaml` remain project-scoped.
- No global Design Arc home. A project without confirmed Design Arc setup creates no home or sidebar item.
- Canonical home title: `Design Arc — <Project Name>` using Codex saved-project name, then workspace-folder fallback.
- Home creation is included in the setup proposal and requires explicit user confirmation. Preference saving may succeed even when task tools are unavailable.
- Match homes by both canonical title and project identity. Reuse and pin an existing match; never reuse another project's home or create a known duplicate.
- Never delete, archive, merge, or silently rename existing tasks. If multiple same-project matches already exist, use the most recent canonical match and report the others for user cleanup.
- A home is a launchpad only. It displays project identity, installed status, active/saved evidence and approval preferences, plain-language starters, and preference controls; it does not perform the journey audit itself.
- Setup confirmation explicitly authorizes the home to launch a new task in the same saved project when the user submits a journey starter there. Launched tasks use the saved project directly (`environment: local`) because Design Arc is design-only and must inspect the user's current product state without creating a code worktree.
- If task creation/pinning is unavailable or fails, complete preference setup, return the exact home title and starter card, and tell the user how to create/pin it manually. Do not claim a home exists without task evidence.
- Natural-language product-journey requests outside the home continue in the current task and briefly disclose that Design Arc is being used; `$design-arc` remains optional.
- Add `$design-arc home` to report, create, repair, or repin the current project's home under the same confirmation and deduplication rules.
- Preserve every existing objective, evidence, provenance, approval-gate, platform-precedence, provider-authorization, implementation, staging, deployment, and release boundary.
- Do not modify the user's real project files or create permanent test homes during automated checks. Any authorized desktop acceptance tasks must be clearly temporary and archived after evidence is captured.
- Stop on a clean, tested, independently reviewed feature branch. Do not push or publish without separate approval.

---

### Task 1: Project-home skill behavior and executable contracts

**Files:** `plugins/design-arc/skills/design-arc/SKILL.md`, workflow contract checker and mutation suite, plus focused scenario evidence/report files as needed.

**Deliverable:** Design Arc setup and `$design-arc home` can safely create or recover exactly one project-scoped launchpad, launch clean same-project journey tasks after the user's standing setup authorization, and fall back honestly when Codex task tools are unavailable.

- [ ] Add failing deterministic/mutation expectations before editing the skill for project resolution, confirmation, project/title deduplication, no global task, duplicate handling, pinned-home content, clean-task launch behavior, natural-language activation, and unavailable-tool fallback.
- [ ] Run fresh-context baseline scenarios without the new guidance and record where agents create global homes, mix projects, duplicate tasks, silently claim success, or fail to explain re-entry.
- [ ] Implement the minimum skill guidance and `$design-arc home` command needed to pass the contracts while preserving the complete `0.2.0` workflow behavior.
- [ ] Run representative fresh-context scenarios with the updated skill for two projects, repeat setup, natural-language activation, clean-task launch, and tool-unavailable fallback.
- [ ] Validate the skill directly, run all workflow mutations, syntax, and `git diff --check`; commit and report.

### Task 2: Returning-user product documentation and starter interface

**Files:** `README.md`, plugin manifest starter prompts, `agents/openai.yaml`, `examples/prompts.md`, operating/behavioral validation docs, and focused documentation tests.

**Deliverable:** Non-technical users understand the before/after journey: install once, approve one home per participating project, return through that project's pinned task, and use ordinary language without remembering a command.

- [ ] Add failing documentation/interface expectations for the exact first-use, next-day, new-product, multi-product, no-global-home, deduplication, and manual-fallback story.
- [ ] Add a prominent “Coming back tomorrow” section after installation and a simple first-day/next-day/new-product explanation.
- [ ] Replace command-dependent starter prompts with plain-language journey starters while keeping explicit setup/mode commands available.
- [ ] Document that the home is a launchpad, launched work stays in the same project, and projects with no Design Arc setup receive no sidebar item.
- [ ] Preserve the unpublished installation-routing fix from `e8d27ee`; run focused docs, identity, workflow, plugin/skill, syntax, and diff checks; commit and report.

### Task 3: Upgrade, integration, and bounded desktop acceptance proof

**Files:** installation/upgrade smoke scripts and behavioral-validation evidence only as required.

**Deliverable:** Existing `0.2.0` users can reach the combined `0.2.1` release without losing project preferences, and Codex desktop evidence demonstrates separate, persistent, non-duplicated homes with safe cleanup.

- [ ] Add a failing isolated upgrade expectation from published `0.2.0`/commit `8e23184` to the branch's `0.2.1`, preserving a representative `.codex/design-arc.yaml`.
- [ ] Verify marketplace upgrade behavior on the installed CLI; use documented remove/add fallback only if refresh does not expose `0.2.1`.
- [ ] Run an authorized bounded desktop acceptance using two temporary project-scoped homes: create/title/pin, verify both appear separately, repeat discovery without duplication, simulate a later/new task, then archive the temporary tasks.
- [ ] Record actual tool evidence and distinguish it from deterministic instruction contracts and qualitative agent scenarios.
- [ ] Run the complete repository suite, isolated fresh install and migration/upgrade smokes, credential/media/local-path/cleanup safety checks, syntax, and `git diff --check`; commit and report.

### Task 4: Independent whole-branch review and unpushed handoff

**Deliverable:** Every scoped task has an approved review, the combined `e8d27ee` plus project-home branch passes a fresh whole-branch review, and the branch is retained without publication.

- [ ] Verify the SDD ledger, scoped reports, and review verdicts.
- [ ] Run a fresh full-suite verification on final HEAD.
- [ ] Obtain a whole-branch review against this plan and public `8e23184`, including overlap with the unpublished installation-routing fix.
- [ ] Fix and re-review all load-bearing findings in one bounded wave.
- [ ] Confirm public `main` remains unchanged, record final branch/SHA/tests, and stop for publication approval.

## Session handoff

- Workspace: `/private/tmp/ux-evidence-plan-inspect`
- Branch: `feature/design-arc-project-homes`
- Baseline: clean `e8d27ee1bd921ff6295402a5d03ef9907963379b`; full repository suite passed before feature work.
- Existing unpublished work: installation-routing fix `e8d27ee` must remain intact and be reviewed with this release.
- Publication boundary: no push or public-main change is authorized.
- Next step: initialize the SDD workspace and dispatch Task 1 implementer.
