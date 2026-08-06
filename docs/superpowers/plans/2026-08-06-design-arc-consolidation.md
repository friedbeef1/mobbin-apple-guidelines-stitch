# Design Arc Single-Plugin Consolidation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task with test-first changes and independent review after each task.

**Goal:** Replace the two active UX workflow plugins with one adaptive, outcome-led Design Arc plugin while preserving the complete objective, evidence, approval, and release-safety contract.

**Architecture:** One marketplace exposes one `design-arc` plugin and embedded skill. The skill resolves independent evidence and approval preferences, then routes through benchmark or guidelines evidence before converging on the same validation, visualization, approval, and authorized-handoff states.

**Tech stack:** Codex plugin JSON, Agent Skills Markdown/YAML, POSIX shell validation, Python instruction-contract and mutation tests, real isolated Codex CLI installation tests.

## Global Constraints

- Start from public commit `babedca266da243326dc7ad60c22706b9cd0c422`.
- Product, marketplace display, plugin display, and documentation identity: `Design Arc`.
- Marketplace technical ID: `design-arc-marketplace`.
- Plugin and skill ID: `design-arc`; invocation: `$design-arc`; version: `0.2.0`.
- Project preference: `.codex/design-arc.yaml` with `evidence_mode` (`benchmarks|guidelines`), optional benchmark-only `benchmark_provider: mobbin`, and `approval_mode` (`guided|follow-recommendation|fully-automatic`).
- Remove `fb-ux` and `apple-guidelines-stitch` from the active marketplace and repository tree; preserve them only through Git history and migration documentation.
- Keep Apple, Mobbin, and Stitch out of the hero and primary identity. Mention them only in methodology, access, authorization, installation, migration, limitations, and trademark contexts.
- Preserve Objective Confirmation, Direction Gate, Stitch Gate, explicit-objective behavior, active-mode provenance, `meets direction` continuation, Android/web first-party precedence, evidence integrity, and implementation/staging/deployment/release boundaries.
- Benchmark mode requires inspected complete relevant journeys and a reason each chosen example is useful. Library presence, metadata, popularity, or one screenshot is not best-in-class evidence.
- Guidelines mode performs no benchmark lookup and makes no benchmark-evidence claim.
- Missing benchmark access stops and offers a one-run guidelines override or saved switch; never degrade silently.
- No MCP servers, apps, hooks, bundled credentials, provider authorization, official-integration claims, or official marketplace submission.
- Do not push, publish, or change public `main`; stop on a clean reviewed feature branch.

---

### Task 1: Canonical Design Arc package and marketplace identity

**Files:** Replace `.agents/plugins/marketplace.json` entries; create `plugins/design-arc/.codex-plugin/plugin.json` and `plugins/design-arc/skills/design-arc/agents/openai.yaml`; remove both legacy plugin trees; update identity/layout assertions in repository validators.

**Deliverable:** A valid version `0.2.0` plugin with complete author, repository, MIT licence, Productivity category, outcome-led descriptions and prompts, exactly one marketplace entry, and no active legacy package.

- [ ] Add failing layout/manifest/marketplace expectations for the single Design Arc package and prove they fail against the two-plugin baseline.
- [ ] Create the canonical manifest and agent metadata, replace the marketplace identity, and remove the two legacy package trees.
- [ ] Validate the new plugin structure independently, run focused identity tests, and commit.

### Task 2: Adaptive skill, preferences, and behavioral contracts

**Files:** Create `plugins/design-arc/skills/design-arc/SKILL.md`; refactor `scripts/check-workflow-contracts.py` and `scripts/test-workflow-contracts.py`; update behavioral-contract documentation only as required to describe executable coverage.

**Deliverable:** One skill that resolves evidence and approval modes independently, establishes the objective before audit/research, implements both evidence routes, imports old project preferences only after confirmation, and preserves every gate and ownership boundary.

- [ ] Add failing deterministic and mutation scenarios for all six evidence/approval combinations, setup commands, evidence provenance, objective handling, both gate policies, platform precedence, benchmark quality, unavailable access, one-run fallback, and migration conflicts.
- [ ] Add fresh-context skill behavior scenarios that expose failures in the pre-consolidation instructions, record the baseline, then validate the consolidated skill against representative setup, override, fallback, and fully automatic cases.
- [ ] Implement the minimum Design Arc skill instructions needed to make those contracts and scenarios pass without adding provider integrations.
- [ ] Run direct skill validation, deterministic mutation tests, scenario evidence, and commit.

Preference resolution and migration contract:

1. Current-request one-run override.
2. Saved `.codex/design-arc.yaml` value.
3. Confirmed import when the new file is absent.
4. First-use selection for any still-missing choice.

Import mapping:

- `.codex/fb-ux.yaml` -> `evidence_mode: benchmarks`, `benchmark_provider: mobbin`, preserved approval mode.
- `.codex/apple-guidelines-stitch.yaml` -> `evidence_mode: guidelines`, omitted benchmark provider, preserved approval mode.
- If both exist, present both mappings and require the user to select one or start fresh.
- Never silently merge, modify, or delete the legacy files.

### Task 3: Pain-led product documentation and migration

**Files:** Rewrite `README.md`; update `docs/codex-operating-layer.md`, `docs/validation/behavioral-validation.md`, and `examples/prompts.md`.

**Deliverable:** Documentation leads with the vague-feedback and incomplete-journey pain, explains the Design Arc outcome before its machinery, and provides exact first-run, evidence-mode, approval-mode, provider, migration, trust, and limitation guidance.

- [ ] Rewrite the README in this order: pain/outcome; deliverables; compact workflow; confusing-onboarding transformation; evidence choice; 60-second install/setup; trust and approval; detailed methodology, sources, migration, limitations, trademarks.
- [ ] Include the trust statement verbatim: `Design Arc does not silently redesign, implement, or deploy your product. You choose the objective, evidence approach, and approval behavior.`
- [ ] Add “You need Design Arc if…” scenarios covering circular subjective feedback, taste disputes, screen-only redesign, omitted non-happy states, and recommendation without surrendered approval.
- [ ] Document migration commands in safe order: remove installed legacy plugins, remove `fb-ux-marketplace`, add the repository again, install `design-arc@design-arc-marketplace`, start a new Codex task.
- [ ] Update examples and operating-layer boundaries, run documentation and package validation, and commit.

### Task 4: Real installation, migration, and repository regression proof

**Files:** Update `scripts/test-plugin-install.sh`, `scripts/test-validate.sh`, `scripts/test-test-validate.sh`, and `scripts/validate.sh`; add a focused migration-smoke helper only if it reduces duplication.

**Deliverable:** The full suite proves a fresh install exposes only Design Arc and a real isolated CLI migration removes the two-plugin baseline before installing the canonical replacement.

- [ ] Add failing isolated-install expectations for exactly one `design-arc@design-arc-marketplace` plugin, display name `Design Arc`, unique cached `$design-arc` skill, and no active legacy IDs.
- [ ] Add a real isolated migration smoke from baseline commit `babedca` that installs legacy plugins, removes them and `fb-ux-marketplace`, adds the new marketplace, installs Design Arc, and confirms only the canonical plugin remains enabled.
- [ ] Preserve credential-negative, quoted-config, ordinary-prose, media, local-path, cleanup, whitespace-`TMPDIR`, shell/Python syntax, and `git diff --check` coverage.
- [ ] Run the complete repository suite and commit.

### Task 5: Independent review and unpushed handoff

**Deliverable:** Each task has an approved scoped review, the whole branch has an independent final review, any findings have completed fix/re-review loops, and the branch is clean without publication.

- [ ] Verify every task report and scoped review in the SDD ledger.
- [ ] Run a fresh full-suite verification on the final branch.
- [ ] Obtain a whole-branch review against this plan and fix/re-review all load-bearing findings.
- [ ] Confirm remote `main` has not been changed by this work, record the feature-branch SHA and tests, and retain the branch for publication approval.

## Session handoff

- Status: baseline verified; implementation not yet started.
- Baseline: public `main` and local clone both at `babedca266da243326dc7ad60c22706b9cd0c422`; current two-plugin suite passed.
- Workspace: `/private/tmp/ux-evidence-plan-inspect`, branch `feature/design-arc-consolidation`.
- Publication boundary: no push or public-main change is authorized.
- Next step: create the SDD workspace/ledger and dispatch Task 1 implementer.
