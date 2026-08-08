# Design Arc GitHub Documentation Navigation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the 316-line Design Arc README with a short understand-and-install landing page and five focused, consistently navigable documentation pages.

**Architecture:** Keep the README as the product entry point and make each detailed topic canonical on exactly one page under `docs/`. Use one shared repository-relative navigation line across the five pages, retain the existing deeper trusted-source and validation references, and enforce the information architecture in the existing documentation validator.

**Tech Stack:** GitHub-flavored Markdown, POSIX shell validation, embedded Python 3 assertions, existing Design Arc repository validators.

## Global Constraints

- The approved design is `docs/superpowers/specs/2026-08-08-github-documentation-navigation-design.md`.
- `README.md` must contain 80–110 lines and retain the current pain, outcome, product outputs, exact vertical workflow table, one example prompt, one-line installation instruction, five-page menu, trust statement, and licence link.
- The landing-page installation instruction is exactly: `**Ask Codex:** Install the Design Arc plugin from` followed by `https://github.com/friedbeef1/mobbin-apple-guidelines-stitch`.
- The README must not contain CLI command blocks, marketplace mechanics, Python references, migration commands, or troubleshooting sections.
- Every new detailed page starts with the exact shared navigation line defined in Task 1.
- Existing trusted-source external URLs and their exact allowlist remain unchanged.
- Do not change plugin behavior, package metadata, evidence modes, approval modes, gates, project-home behavior, upgrade safeguards, or implementation/release ownership.
- Publication is a non-force fast-forward to GitHub `main` only after task reviews, final review, and the full repository suite pass.
- Do not reinstall or upgrade the user's installed plugin.

---

### Task 1: Create the five canonical documentation pages

**Files:**
- Create: `docs/getting-started.md`
- Create: `docs/using-design-arc.md`
- Create: `docs/evidence-and-methodology.md`
- Create: `docs/upgrades-and-migration.md`
- Create: `docs/trust-limitations-and-sources.md`
- Modify: `scripts/test-design-arc-docs.sh`

**Interfaces:**
- Consumes: the current README sections and approved navigation design.
- Produces: five stable link destinations consumed by Task 2.

- [ ] **Step 1: Add failing page and navigation assertions**

Add exact path variables and require every file:

```sh
getting_started="$repo_root/docs/getting-started.md"
using_design_arc="$repo_root/docs/using-design-arc.md"
evidence_methodology="$repo_root/docs/evidence-and-methodology.md"
upgrades_migration="$repo_root/docs/upgrades-and-migration.md"
trust_sources="$repo_root/docs/trust-limitations-and-sources.md"
```

Require this exact line in every new page:

```markdown
[Home](../README.md) · [Getting started](getting-started.md) · [Using Design Arc](using-design-arc.md) · [Evidence and methodology](evidence-and-methodology.md) · [Upgrades and migration](upgrades-and-migration.md) · [Trust and sources](trust-limitations-and-sources.md)
```

- [ ] **Step 2: Prove the test is red**

Run: `sh scripts/test-design-arc-docs.sh`

Expected: FAIL on the first missing new page.

- [ ] **Step 3: Create Getting started**

Create `docs/getting-started.md` with the shared navigation, the question “How do I install Design Arc and begin my first review?”, and the current README's installation content. Put the simple Ask Codex instruction first. Preserve install-once/profile-wide behavior, first-task setup, the exact advanced marketplace/plugin command order, registry and recommended-list troubleshooting, local-checkout fallback, download-permission note, and no-Python-knowledge statement. End with a link to `using-design-arc.md`.

- [ ] **Step 4: Create Using Design Arc**

Create `docs/using-design-arc.md` with the shared navigation and the question “How do I use Design Arc after installation?”. Migrate natural-language activation, example prompts, first/next/new-product use, project-home reuse and fallback, the three approval modes, Objective Confirmation, both design gates, and the exact trust statement. End with a link to `evidence-and-methodology.md`.

- [ ] **Step 5: Create Evidence and methodology**

Create `docs/evidence-and-methodology.md` with the shared navigation and the question “How are Design Arc recommendations grounded and validated?”. Migrate the grounding table, Benchmarks versus Guidelines, unavailable-access behavior, “Why each step is crucial” table, animation/motion grounding, complete-state coverage, and render validation. Link to `trusted-sources/README.md`, `trusted-sources/motion.md`, and `validation/behavioral-validation.md`. End with a link to `upgrades-and-migration.md`. Keep Mobbin limited to Benchmarks mode, first-party guidance authoritative in Guidelines mode, and Stitch a visualization tool rather than an evidence authority.

- [ ] **Step 6: Create Upgrades and migration**

Create `docs/upgrades-and-migration.md` with the shared navigation and the question “What happens when Design Arc is upgraded or replaces an older plugin?”. Migrate safe upgrades, project preservation, rollback expectations, both legacy preference mappings, dual-file conflicts, the no-silent-merge rule, and exact migration commands. End with a link to `trust-limitations-and-sources.md`.

- [ ] **Step 7: Create Trust, limitations and sources**

Create `docs/trust-limitations-and-sources.md` with the shared navigation and the question “What can Design Arc prove, access, implement, or release?”. Migrate external-source status, discovery limits, evidence/implementation/release boundaries, Mobbin/Stitch authorization limits, prototype versus runtime proof, trademarks, and links to `trusted-sources/README.md` and `codex-operating-layer.md`. End with a link to `../README.md`.

- [ ] **Step 8: Move assertions to canonical pages and verify green**

Move existing `require_text` assertions from `$readme` to the relevant new page variable. Add assertions for every page heading, opening question, shared navigation, and next link. Do not weaken the exact workflow-table validator or trusted-source URL equality check.

Run: `sh scripts/test-design-arc-docs.sh`

Expected: PASS.

- [ ] **Step 9: Commit Task 1**

```sh
git add docs/getting-started.md docs/using-design-arc.md docs/evidence-and-methodology.md docs/upgrades-and-migration.md docs/trust-limitations-and-sources.md scripts/test-design-arc-docs.sh
git commit -m "docs: split Design Arc guidance into focused pages"
```

---

### Task 2: Replace the README with the short landing page

**Files:**
- Modify: `README.md`
- Modify: `scripts/test-design-arc-docs.sh`

**Interfaces:**
- Consumes: the five pages from Task 1.
- Produces: an 80–110-line landing page with root-relative navigation.

- [ ] **Step 1: Add failing landing-page assertions**

Add the line-count contract:

```python
line_count = len(text.splitlines())
if not 80 <= line_count <= 110:
    raise SystemExit(f"FAIL: README must contain 80-110 lines; found {line_count}")
```

Require these root-relative menu links: `docs/getting-started.md`, `docs/using-design-arc.md`, `docs/evidence-and-methodology.md`, `docs/upgrades-and-migration.md`, and `docs/trust-limitations-and-sources.md`. Require the exact Ask Codex instruction. Reject README occurrences of `````sh``, `codex plugin`, `skills registry`, `Python`, `Saved preferences and migration`, and `If Codex says`.

- [ ] **Step 2: Prove the test is red**

Run: `sh scripts/test-design-arc-docs.sh`

Expected: FAIL because the current README exceeds 110 lines and contains advanced installation material.

- [ ] **Step 3: Rewrite README in the approved order**

Use these sections only:

1. `# Design Arc` with existing pain/outcome positioning.
2. `## Documentation` with the five-page menu.
3. `## You need Design Arc if…` with the existing pain bullets.
4. `## What Design Arc produces` with the existing output bullets.
5. `## The workflow` with the exact current 11-step, 10-arrow, three-column table and exactly three `**👤 You**` markers.
6. `## Install` with only the exact Ask Codex instruction and one sentence that Codex handles installation and may request download permission.
7. `## Start a review` with only `Help me make our onboarding less confusing.` and a link to `docs/using-design-arc.md`.
8. `## Trust` with the existing trust statement and links to evidence/methodology and trust/sources.
9. `## License` linking to `LICENSE`.

Do not retain advanced commands, upgrade instructions, methodology tables, migration detail, troubleshooting, trademarks, or external-source explanations in README.

- [ ] **Step 4: Verify focused green**

Run: `sh scripts/test-design-arc-docs.sh`

Expected: PASS, including existing workflow negative mutations.

- [ ] **Step 5: Commit Task 2**

```sh
git add README.md scripts/test-design-arc-docs.sh
git commit -m "docs: turn README into a short Design Arc landing page"
```

---

### Task 3: Enforce navigation integrity and release validation

**Files:**
- Modify: `scripts/test-design-arc-docs.sh`
- Verify: `README.md` and the five new pages

**Interfaces:**
- Consumes: final documentation from Tasks 1–2.
- Produces: fail-closed relative-link and canonical-content coverage.

- [ ] **Step 1: Add a relative Markdown-link resolver**

Scan README and the five pages. Ignore external URLs, `mailto:`, and same-page anchors; strip fragments; resolve each remaining target relative to its source; fail when the target does not exist:

```python
for source in documentation_pages:
    for target in re.findall(r"\[[^\]]+\]\(([^)]+)\)", source.read_text(encoding="utf-8")):
        if target.startswith(("http://", "https://", "mailto:", "#")):
            continue
        resolved = (source.parent / target.split("#", 1)[0]).resolve()
        if not resolved.exists():
            raise SystemExit(f"FAIL: broken relative link in {source}: {target}")
```

- [ ] **Step 2: Add a broken-link mutation**

Copy one page to the existing safely quoted temporary fixture area, replace a valid menu target with `missing-page.md`, and require the link validator to reject it.

Run: `sh scripts/test-design-arc-docs.sh`

Expected: PASS with an explicit broken-link-mutation rejection line.

- [ ] **Step 3: Run complete validation**

```sh
sh scripts/validate.sh
git diff --check
```

Expected: both exit 0, including plugin/skill validation, documentation, 137 workflow mutations, safety scans, and isolated install/migration/upgrade checks.

- [ ] **Step 4: Commit Task 3**

```sh
git add scripts/test-design-arc-docs.sh
git commit -m "test: enforce Design Arc documentation navigation"
```

- [ ] **Step 5: Review, publish, and verify**

Obtain task review after every task and one whole-branch review. Resolve all Important or higher findings. Confirm `origin/main` is the exact merge base and `HEAD` is its descendant, then publish without force:

```sh
git push origin HEAD:main
```

Verify the public SHA, make a fresh public clone, run `sh scripts/test-design-arc-docs.sh`, and use GitHub’s rendered README API to confirm the menu, simple installation instruction, workflow table, and all five rendered page destinations. Do not reinstall or upgrade the user's plugin.
