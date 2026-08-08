# Design Arc Hybrid Graph-Assisted Workflow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Release a tested Design Arc 0.3.0 candidate that adds project-isolated, reconstructable graph assistance to every new review without replacing the authoritative workflow loop.

**Architecture:** Design Arc remains a skill-only plugin with no database, MCP server, app, or external graph service. Codex writes and validates a versioned local JSON review record, uses valid relationships only to improve correction planning, and falls back to the unchanged complete-proposal loop whenever graph assistance is unavailable or untrustworthy.

**Tech Stack:** Codex skill Markdown, JSON Schema, dependency-free Python validation, shell integration tests, deterministic Python mutation tests.

## Global Constraints

- Build from tested Design Arc 0.2.3 candidate `489988474dce4a4b0da7a5c48104e9d548c107bd`; package target is exactly `0.3.0`.
- Graph assistance is active for every new review under 0.3.0, including existing projects whose preferences contain no graph field. Already-active reviews retain their recorded workflow version.
- Activation never rewrites an existing preference or pinned-home record. A user may disable graph assistance for one review, one project, or the whole laptop.
- Store review graphs at `.codex/design-arc/reviews/<review_id>/graph.json` with schema version `design-arc.graph/v1`.
- The graph advises correction planning only. The existing workflow loop remains authoritative, including one initial proposal, at most three proposal-wide correction rounds, complete reinspection, Objective Confirmation, Direction Gate, Stitch Gate, and implementation/release boundaries.
- Invalid, corrupt, incomplete, contradictory, unsupported, unproven, or cross-project graph data is ignored and reported; it never blocks the standard loop.
- Do not add a database, MCP server, app, external graph service, dependency, or additional approval gate. Do not modify project `.gitignore` files.
- Preserve preferences, pinned homes, product files, graph records, and active reviews during upgrade and downgrade tests. Do not push, publish, deploy, or upgrade the installed user profile.
- Follow strict TDD: change tests first, capture the expected RED failure, then implement the minimum contract and capture GREEN.

---

### Task 1: Versioned Graph Record Schema and Validator

**Files:**
- Create: `plugins/design-arc/skills/design-arc/references/graph-record.schema.json`
- Create: `scripts/validate-graph-record.py`
- Create: `scripts/test-graph-records.py`
- Create: `scripts/fixtures/graph-records/valid.json`
- Create: focused invalid fixtures under `scripts/fixtures/graph-records/`
- Modify: `scripts/validate.sh`
- Modify: `scripts/test-test-validate.sh`

**Interfaces:**
- Produces schema identifier `design-arc.graph/v1` and a CLI `python3 scripts/validate-graph-record.py GRAPH_PATH EXPECTED_PROJECT_ID EXPECTED_REVIEW_ID` that exits 0 only for a usable project-local record.
- Produces node types `confirmed_objective`, `evidence_source`, `platform_requirement`, `design_decision`, `journey`, `screen`, `state`, `transition`, `stitch_render`, `observed_mismatch`, `correction`, `approval`, and `exception`.
- Produces edge types `supports`, `requires`, `applies_to`, `conflicts_with`, `depends_on`, `rendered_as`, `corrected_by`, `supersedes`, and `approved_by`.
- Every edge carries provenance kind, source reference, observed-at timestamp, and support status. Supported provenance kinds are `inspected_evidence`, `official_guidance`, `user_confirmed_objective`, and `design_arc_judgment`.

- [ ] Write validator tests and literal fixtures first for valid, corrupt JSON, incomplete required fields, unsupported schema/type/provenance, duplicate IDs, missing endpoints, wrong project/review identity, unproven relationship, and explicitly contradictory active relationships.
- [ ] Run `python3 scripts/test-graph-records.py` and record RED because the validator/schema are absent.
- [ ] Add the schema and dependency-free validator. Validation must reject the full record rather than silently repair it; the workflow layer will report the limitation and fall back.
- [ ] Add the graph-record test to `scripts/validate.sh` and make `scripts/test-test-validate.sh` prove the repository harness fails closed when that test is deliberately broken.
- [ ] Run focused tests, `sh scripts/validate.sh`, and `git diff --check`; commit the task.

### Task 2: Graph Controls, Resolution, and Workflow Integration

**Files:**
- Modify: `plugins/design-arc/skills/design-arc/SKILL.md`
- Modify: `scripts/check-workflow-contracts.py`
- Modify: `scripts/test-workflow-contracts.py`

**Interfaces:**
- Add `$design-arc graph`, `graph on|off`, `graph explain`, `graph rebuild`, `graph clear`, and `graph global off|on`, plus equivalent natural-language requests.
- Project setting is `graph_assistance: on|off` in `.codex/design-arc.yaml`. Laptop safety state is isolated under the Codex profile and may disable but never force-enable a project; explicit one-review off, project off, and global off each disable assistance.
- A missing project graph setting resolves to active for each new 0.3.0 review without rewriting the preference. The active state and provenance are reported at review start.
- Each new review gets a stable `review_id` and `workflow_version: 0.3.0`; active older reviews retain their prior version.

- [ ] Add exactly 24 graph-specific mutations first, raising the deterministic total from 151 to 175. Cover commands and precedence, default activation for existing and new projects, active-review pinning, project isolation, provenance, invalid-data fallback, graph-not-authority, platform/accessibility/evidence precedence, repair batching, complete reinspection, three-round limit, gates, runtime proof, rebuild/clear scope, and implementation/release boundaries.
- [ ] Extend the deterministic checker with the intended graph contract and run it against the unchanged skill to capture RED for the missing behavior.
- [ ] Update the skill with graph resolution, storage, validation, tracing, fallback, explanation, rebuild, clear confirmation, and downgrade behavior. Creating a graph adds no design approval gate; `graph clear` remains destructive and requires explicit confirmation.
- [ ] Require graph-assisted corrections to trace render → screen/state → approved requirement → provenance → dependent states → regression checks, then perform the unchanged complete-proposal inspection.
- [ ] Run the checker and mutation suite for GREEN, confirm exactly 24 new cases and 175 total, run `sh scripts/validate.sh` and `git diff --check`, then commit.

### Task 3: User Documentation and Trust Explanation

**Files:**
- Modify: `docs/using-design-arc.md`
- Modify: `docs/evidence-and-methodology.md`
- Modify: `docs/upgrades-and-migration.md`
- Modify: `docs/trust-limitations-and-sources.md`
- Modify: `scripts/test-design-arc-docs.sh`

**Interfaces:**
- Use this exact positioning: “Design Arc understands how requirements, evidence and screens affect one another, helping it make more precise corrections without surrendering approval control.”
- Keep graph technology out of the README hero and installation CTA.

- [ ] Add documentation expectations first for the before/after outcome, automatic 0.3.0 activation for new reviews in existing and new projects, no new gate, controls, provenance, fallback, rebuild/clear, upgrade/downgrade preservation, and graph-not-proof boundary; capture RED.
- [ ] Update the deeper documentation pages, using plain language and explaining that existing active reviews are untouched while their next clean review gains graph assistance.
- [ ] Keep source roles unchanged: first-party guidance is authoritative for its platform, authorized benchmark evidence is precedent, Stitch is visualization, and the graph is relationship context only.
- [ ] Run documentation tests, full validation, and `git diff --check`; commit.

### Task 4: Package 0.3.0, Upgrade/Downgrade Preservation, and Final Verification

**Files:**
- Modify: `plugins/design-arc/.codex-plugin/plugin.json`
- Modify: identity/install/migration/upgrade test scripts and state helper
- Modify: `docs/validation/behavioral-validation.md`

**Interfaces:**
- Manifest version is exactly `0.3.0`; canonical identity remains `design-arc@design-arc-marketplace` and invocation remains `$design-arc`.
- Test immutable public 0.2.2 and exact local 0.2.3 candidate `489988474dce4a4b0da7a5c48104e9d548c107bd` as upgrade baselines.

- [ ] Change release expectations first and capture independent RED failures while the manifest remains 0.2.3.
- [ ] Extend isolated fixtures to include two products, existing preferences without graph fields, ready homes, product sentinels, graph records, and active reviews pinned to their starting workflow versions.
- [ ] Prove 0.2.2→0.3.0 and 0.2.3→0.3.0 preserve all existing bytes, create zero homes, continue zero active reviews, and activate graph assistance only when a subsequent new review resolves 0.3.0 behavior.
- [ ] Prove a simulated downgrade to exact 0.2.3 ignores graph records while preserving them and all pre-existing project state byte-for-byte.
- [ ] Update the manifest and truthful validation evidence, then run independent plugin/skill validation, all 175 mutations, schema fixtures, documentation, credential/media/local-path safety, syntax, isolated install/migration/upgrades/downgrade, `sh scripts/validate.sh`, and `git diff --check`.
- [ ] Obtain independent task review and whole-branch review, apply only reviewed fix loops, and stop on a clean local branch without push, publication, or installed-profile upgrade.
