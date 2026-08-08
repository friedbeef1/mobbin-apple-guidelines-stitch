# Design Arc Render-Repair Loop Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Release a tested Design Arc 0.2.3 candidate that automatically corrects straightforward Stitch render drift in at most three batched rounds, reinspects every result, and flags unresolved mismatches before the Stitch Gate.

**Architecture:** Keep the behaviour instruction-driven inside the canonical `design-arc` skill. Add one bounded render-repair section, enforce it through the existing deterministic checker and negative mutation harness, explain it in the existing user documentation, and verify packaging through the existing isolated Codex installation, migration, and upgrade fixtures.

**Tech Stack:** Markdown skill and documentation contracts, Python deterministic checkers and mutation tests, POSIX shell repository validators, JSON plugin metadata, Codex CLI isolated `CODEX_HOME` smoke tests.

## Global Constraints

- One initial Stitch proposal is followed by zero to three correction rounds; the initial proposal is not a correction round.
- Every round batches all currently known repairable mismatches for the entire proposal.
- Codex must inspect the newly generated render before claiming any mismatch is fixed.
- Ordinary rendering drift is corrected without user interruption.
- A product-direction decision, missing authorization, or runtime-only proof is never disguised as repairable drift.
- Early stopping for non-convergence requires two consecutive corrected proposals with no improvement or oscillation.
- `meets direction` is forbidden while an unexplained Stitch-expressible mismatch remains.
- Guided and Follow recommendation stop at the Stitch Gate after repair; Fully automatic continues only on `meets direction`.
- Preserve evidence modes, Objective Confirmation, the Direction Gate, platform precedence, motion evidence integrity, project homes, safe upgrades, external authorization, and implementation/release boundaries.
- Package version is `0.2.3`; immutable upgrade baseline is public `0.2.2` commit `1c9b3796e6f5f0648bae5984f1b8e3013eeac56f`.
- Do not publish to GitHub or upgrade the user's installed Design Arc plugin during this plan.

---

### Task 1: Enforce the render-repair behaviour contract

**Files:**
- Modify: `scripts/check-workflow-contracts.py`
- Modify: `scripts/test-workflow-contracts.py`
- Modify: `plugins/design-arc/skills/design-arc/SKILL.md`

**Interfaces:**
- Consumes: the existing complete-Stitch-generation, actual-render inspection, three-verdict, and Stitch Gate contracts.
- Produces: a locally scoped `### Repair Stitch drift before the Stitch Gate` contract enforced by 14 new negative mutations; the mutation total becomes 151.

- [ ] **Step 1: Read the honest-test rules before changing the mutation harness**

Read:

```text
/Users/jamesyeang/.codex/plugins/cache/claude-plugins-official/superpowers/6.2.0/skills/test-driven-development/writing-good-tests.md
```

Record which production change would make each planned mutation pass incorrectly: removing the three-round bound, changing proposal-wide batching, asking the user to repair ordinary drift, accepting a correction note as proof, skipping reinspection, automatically changing direction, retrying runtime-only proof, stopping after one unchanged round, omitting exhaustion handling, allowing unexplained mismatches, omitting the run record, bypassing Guided/Follow repair, or bypassing Fully automatic verdict discipline.

- [ ] **Step 2: Add the failing deterministic contract assertions**

In `scripts/check-workflow-contracts.py`, add a section-local contract:

```python
RENDER_REPAIR_HEADING = "### Repair Stitch drift before the Stitch Gate"

RENDER_REPAIR_CONTRACTS = {
    "proposal-wide three-round bound": (
        "Use one initial Stitch proposal followed by at most three batched correction rounds for the entire proposal.",
        "The initial proposal is not a correction round, so the maximum is four rendered proposals.",
    ),
    "conformance matrix": (
        "Before assigning a Stitch verdict, create a conformance matrix for every material screen and state.",
        "Each row records the screen or state identifier; approved requirement and provenance; observed render evidence; classification; exact correction or next action; and inspected render identifier.",
    ),
    "classification boundary": (
        "Classify every mismatch as `match`, `repairable drift`, `direction decision required`, or `runtime proof`.",
        "Correct `repairable drift` automatically without asking the user because it does not change the approved direction.",
        "Stop before correction when a direction decision or new external authorization is required.",
        "Carry `runtime proof` forward as unverified implementation evidence; do not retry Stitch or claim the prototype proves it.",
    ),
    "inspection integrity": (
        "A correction note, provider status, or command success is not proof of correction; only inspection of the newly generated render can change a mismatch to `match`.",
        "After every correction round, inspect the complete resulting proposal again, including previously matching requirements that may have regressed.",
    ),
    "bounded convergence": (
        "Stop early only when two consecutive corrected proposals show no improvement, two consecutive corrected proposals oscillate by fixing one requirement while breaking another, access becomes unavailable, the next correction changes direction, or new authorization is required.",
        "After the third unsuccessful correction round, stop and assign `meets with corrections` or `does not meet` from the remaining mismatch scope.",
    ),
    "verdict integrity": (
        "Assign `meets direction` only after the most recent complete proposal is inspected and every Stitch-expressible requirement matches.",
        "Guided and Follow recommendation perform the repair loop before stopping at the Stitch Gate.",
        "Fully automatic performs the same repair loop and continues past the Stitch Gate only on `meets direction`.",
    ),
    "repair record": (
        "Record the initial proposal identifiers; each conformance matrix; correction round number; batched correction request and provenance; fixed, remaining, and newly introduced mismatches; stop reason; final Stitch verdict; and remaining runtime proof.",
    ),
}
```

Use `markdown_section(text, RENDER_REPAIR_HEADING, "## ")` in `main()`. Fail when the section is absent or any fragment is outside that section.

- [ ] **Step 3: Add 14 negative mutations**

Add these labels to `MUTATIONS` in `scripts/test-workflow-contracts.py`, each replacing exactly one corresponding fragment above with the unsafe opposite:

```python
"repair round maximum"
"proposal-wide batching"
"repair before user involvement"
"conformance matrix completeness"
"correction proof requires render"
"complete reinspection"
"direction decision stop"
"runtime proof boundary"
"two-round early-stop evidence"
"third-round exhaustion verdict"
"no unexplained meets-direction verdict"
"repair run record"
"guided and follow repair timing"
"fully automatic repair verdict"
```

Keep `mutation_count = len(MUTATIONS) + len(CONTRADICTION_MUTATIONS) + 4`; the expected final line becomes:

```text
PASS: rejected 151 deterministic contract mutations
```

- [ ] **Step 4: Prove RED against the unchanged skill**

Run:

```bash
python3 scripts/check-workflow-contracts.py
python3 scripts/test-workflow-contracts.py
```

Expected: both fail because `### Repair Stitch drift before the Stitch Gate` and its required clauses are absent. Confirm the failure names the render-repair section rather than a syntax or fixture error.

- [ ] **Step 5: Implement the minimal skill contract**

Insert `### Repair Stitch drift before the Stitch Gate` after the existing actual-render inspection paragraph and before `## Apply the Stitch Gate and hand off` in `plugins/design-arc/skills/design-arc/SKILL.md`.

Use the exact contract sentences from Step 2. Add the operational sequence:

```text
initial complete proposal
→ conformance inspection
→ batched repairable-drift correction
→ complete reinspection
→ repeat for at most three correction rounds
→ final verdict
→ existing Stitch Gate policy
```

State that each correction names the source render and affected screen/state IDs, preserves matching requirements, records new identifiers, and includes newly introduced drift in the next round. State that a clearly labeled user exception cannot change the verdict to `meets direction` or waive first-party platform or accessibility requirements.

- [ ] **Step 6: Prove GREEN and commit**

Run:

```bash
python3 scripts/check-workflow-contracts.py
python3 scripts/test-workflow-contracts.py
sh scripts/test-test-validate.sh
git diff --check
```

Expected: checker pass, exactly 151 rejected mutations, validator self-test pass, and no whitespace errors.

Commit:

```bash
git add plugins/design-arc/skills/design-arc/SKILL.md scripts/check-workflow-contracts.py scripts/test-workflow-contracts.py
git commit -m "feat: add bounded Stitch render repair"
```

---

### Task 2: Explain and protect the user-facing repair flow

**Files:**
- Modify: `scripts/test-design-arc-docs.sh`
- Modify: `docs/using-design-arc.md`
- Modify: `docs/evidence-and-methodology.md`
- Modify: `docs/codex-operating-layer.md`
- Modify: `docs/validation/behavioral-validation.md`

**Interfaces:**
- Consumes: Task 1's render-repair terminology, counting, classifications, and gate behaviour.
- Produces: a nontechnical explanation that matches the enforced skill without lengthening the short README.

- [ ] **Step 1: Add failing documentation assertions**

In `scripts/test-design-arc-docs.sh`, require these exact statements:

```text
Design Arc corrects straightforward Stitch drift before asking you to approve the visual proposal.
The initial proposal may be followed by at most three correction rounds for the whole proposal.
Each round batches every known repairable mismatch, generates a new proposal, and reinspects the complete result.
If the proposal still does not match, Design Arc stops and flags every unresolved mismatch and the attempts already made.
A written correction is not a corrected proposal; only the inspected replacement render proves the change.
```

Require the first four in `docs/using-design-arc.md`, the counting/reinspection/proof boundaries in `docs/evidence-and-methodology.md`, and a platform-ownership explanation in `docs/codex-operating-layer.md`. Do not add them to `README.md`.

Require this bounded-evidence statement in `docs/validation/behavioral-validation.md`:

```text
Fourteen render-repair mutations prove that the written contract rejects unbounded retries, per-mismatch retrying, user-dependent ordinary corrections, uninspected correction claims, skipped reinspection, unsafe direction changes, runtime-proof retries, premature early stopping, missing exhaustion handling, unexplained `meets direction`, incomplete repair records, and approval-mode bypasses.
```

- [ ] **Step 2: Prove RED**

Run:

```bash
sh scripts/test-design-arc-docs.sh
```

Expected: FAIL on the first missing render-repair sentence.

- [ ] **Step 3: Add the everyday-use explanation**

Add `## What happens after Stitch renders` to `docs/using-design-arc.md` before `## Approval and trust controls`:

```markdown
## What happens after Stitch renders

Design Arc corrects straightforward Stitch drift before asking you to approve the visual proposal. The initial proposal may be followed by at most three correction rounds for the whole proposal. Each round batches every known repairable mismatch, generates a new proposal, and reinspects the complete result.

If the proposal still does not match, Design Arc stops and flags every unresolved mismatch and the attempts already made. It asks sooner only when the correction would change the approved direction, requires new authorization, or cannot be proven in a prototype.
```

- [ ] **Step 4: Add methodology and ownership detail**

Add `### Render conformance and repair` to `docs/evidence-and-methodology.md` after the grounding workflow table. Include the exact proof sentence:

```text
A written correction is not a corrected proposal; only the inspected replacement render proves the change.
```

Explain the four mismatch classifications, the initial-plus-three counting, complete reinspection, early-stop evidence, final verdicts, and the runtime-proof boundary.

In `docs/codex-operating-layer.md`, extend “What Codex contributes” with:

```text
Codex compares the complete Stitch proposal with the approved direction, batches straightforward drift into at most three correction rounds, and reinspects every replacement render before assigning the Stitch verdict.
```

Keep Stitch described as an external visualizer rather than a compliance authority.

In `docs/validation/behavioral-validation.md`, update the deterministic mutation total from 137 to 151 and add the exact bounded-evidence statement from Step 1. State that these are static instruction-contract mutations; they do not execute Stitch or prove that every future agent will follow the contract.

- [ ] **Step 5: Prove GREEN and commit**

Run:

```bash
sh scripts/test-design-arc-docs.sh
python3 scripts/test-workflow-contracts.py
git diff --check
```

Expected: documentation pass, 151 mutation rejections, and no whitespace errors.

Commit:

```bash
git add docs/using-design-arc.md docs/evidence-and-methodology.md docs/codex-operating-layer.md docs/validation/behavioral-validation.md scripts/test-design-arc-docs.sh
git commit -m "docs: explain automatic Stitch corrections"
```

---

### Task 3: Package and prove Design Arc 0.2.3 safely

**Files:**
- Modify: `scripts/test-design-arc-identity.sh`
- Modify: `scripts/test-plugin-install.sh`
- Modify: `scripts/test-plugin-migration.sh`
- Modify: `scripts/test-plugin-upgrade.sh`
- Modify: `scripts/test-plugin-upgrade-state.py`
- Modify: `scripts/test-design-arc-docs.sh`
- Modify: `plugins/design-arc/.codex-plugin/plugin.json`
- Modify: `docs/validation/behavioral-validation.md`

**Interfaces:**
- Consumes: the completed 0.2.3 behaviour and documentation from Tasks 1–2 and immutable public 0.2.2 commit `1c9b3796e6f5f0648bae5984f1b8e3013eeac56f`.
- Produces: one canonical 0.2.3 package plus isolated fresh-install, legacy-migration, and byte-preserving 0.2.2-to-0.2.3 upgrade evidence.

- [ ] **Step 1: Change release expectations before the manifest**

Update target expectations from `0.2.2` to `0.2.3` in:

```text
scripts/test-design-arc-identity.sh
scripts/test-plugin-install.sh
scripts/test-plugin-migration.sh
```

In `scripts/test-plugin-upgrade.sh`, set:

```sh
published_sha=1c9b3796e6f5f0648bae5984f1b8e3013eeac56f
published_checkout="$task_temp_dir/published-0.2.2"
current_checkout="$task_temp_dir/current-0.2.3"
```

Change every baseline version, filename, diagnostic, rollback assertion, and cache expectation from `0.2.1` to `0.2.2`, and every target from `0.2.2` to `0.2.3`. Apply the same baseline/target transition in `scripts/test-plugin-upgrade-state.py`. Preserve all injected-failure cases and the two-project byte snapshots.

- [ ] **Step 2: Prove release RED**

Run:

```bash
sh scripts/test-design-arc-identity.sh
sh scripts/test-plugin-install.sh
sh scripts/test-plugin-migration.sh
sh scripts/test-plugin-upgrade.sh
```

Expected: each fails because the unchanged plugin manifest still reports `0.2.2` while the tests require `0.2.3`. The upgrade test must use the immutable 0.2.2 baseline and fail before claiming a 0.2.3 target.

- [ ] **Step 3: Bump the canonical manifest only**

Change in `plugins/design-arc/.codex-plugin/plugin.json`:

```json
"version": "0.2.3"
```

Do not add MCP servers, apps, hooks, dependencies, or provider integrations. The marketplace manifest has no duplicated version field and remains unchanged.

- [ ] **Step 4: Run the focused release suite**

Run:

```bash
sh scripts/test-design-arc-identity.sh
sh scripts/test-plugin-install.sh
sh scripts/test-plugin-migration.sh
sh scripts/test-plugin-upgrade.sh
```

Expected:

```text
PASS: Design Arc identity
PASS: isolated Design Arc plugin installation smoke
PASS: isolated Design Arc plugin migration smoke
PASS: isolated Design Arc 0.2.2 to 0.2.3 upgrade
```

The upgrade evidence must also prove two preferences, two ready homes, two product sentinels, and two active reviews remain byte-identical; zero homes are created and zero reviews continue.

- [ ] **Step 5: Record bounded validation evidence**

Append `## Isolated 0.2.2 to 0.2.3 upgrade evidence — 2026-08-08` to `docs/validation/behavioral-validation.md`. State:

- immutable baseline SHA `1c9b3796e6f5f0648bae5984f1b8e3013eeac56f`;
- temporary `CODEX_HOME` and temporary two-project fixture only;
- RED manifest mismatch and GREEN 0.2.3 result;
- normal marketplace-upgrade attempt and the observed route;
- immutable restoration preflight and injected rollback coverage;
- exact preserved preference, home, product, and active-review scope; and
- that this is local deterministic evidence, not publication, real-profile upgrade, real Stitch execution, or product-runtime proof.

Add matching exact assertions to `scripts/test-design-arc-docs.sh` before writing the evidence, prove the focused docs test RED, then add the evidence and prove it GREEN.

- [ ] **Step 6: Commit the release candidate**

Run:

```bash
sh scripts/test-design-arc-docs.sh
git diff --check
```

Commit:

```bash
git add plugins/design-arc/.codex-plugin/plugin.json scripts/test-design-arc-identity.sh scripts/test-plugin-install.sh scripts/test-plugin-migration.sh scripts/test-plugin-upgrade.sh scripts/test-plugin-upgrade-state.py scripts/test-design-arc-docs.sh docs/validation/behavioral-validation.md
git commit -m "release: prepare Design Arc 0.2.3"
```

---

### Task 4: Validate and review the complete candidate

**Files:**
- Verify: all files changed since `005d1ee`
- Do not modify: the user's installed Codex plugin profile or any product project

**Interfaces:**
- Consumes: Tasks 1–3 as one branch candidate.
- Produces: a clean, independently reviewed Design Arc 0.2.3 branch ready for a separate publish decision.

- [ ] **Step 1: Run complete repository validation**

Run:

```bash
sh scripts/validate.sh
git diff --check 005d1ee..HEAD
git status --short
```

Expected: complete validation passes, including plugin/skill validation, documentation, 151 deterministic mutations, credential/media/local-path checks, shell/Python syntax, isolated install, migration, and 0.2.2-to-0.2.3 upgrade. Status is clean.

- [ ] **Step 2: Obtain independent task reviews**

After each task commit, use `superpowers:requesting-code-review` with that task's recorded base and head. Resolve every P0–P2 finding with a fresh failing regression where behaviour changed, rerun the task's focused checks, and obtain scoped re-review.

- [ ] **Step 3: Obtain one whole-branch review**

Review `005d1ee..HEAD` against:

```text
docs/superpowers/specs/2026-08-08-design-arc-render-repair-loop-design.md
docs/superpowers/plans/2026-08-08-design-arc-render-repair-loop.md
```

Require explicit verification of the three-round counting, batching, complete reinspection, mismatch classifications, early stopping, verdict integrity, approval modes, external authorization, 0.2.3 packaging, upgrade preservation, and release boundary.

- [ ] **Step 4: Run controller verification after review**

Run fresh:

```bash
sh scripts/validate.sh
git diff --check 005d1ee..HEAD
git status --short
git log --oneline 005d1ee..HEAD
```

Read the complete output before claiming readiness.

- [ ] **Step 5: Stop before publication**

Report the candidate commit, exact checks, review verdict, and remaining limitation that static instruction/mutation tests do not prove how every future agent or Stitch model behaves. Do not push, publish, or run `$design-arc upgrade`. Those require separate explicit approval.
