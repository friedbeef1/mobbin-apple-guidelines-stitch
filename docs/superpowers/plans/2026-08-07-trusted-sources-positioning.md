# Trusted Sources Positioning Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Put credible-source grounding at the front of Design Arc's positioning and give readers a repository source library that explains why each grounding layer matters and links to official pages for deeper reading.

**Architecture:** The README owns the concise value story and a four-row grounding table. `docs/trusted-sources/` owns the deeper explanation, separated into platform authority, benchmark precedent, and visualization roles; external materials remain external and are linked rather than copied.

**Tech Stack:** GitHub-flavored Markdown, shell validation, existing repository validators.

## Global Constraints

- Lead with the reader sequence: grounding exists, why it matters, what the layers are, and who the credible sources are.
- Keep the hero generic and outcome-led; provider names explain the evidence model but do not become the product identity.
- Platform guidance is authoritative only for its own platform.
- Benchmark evidence requires actual relevant journey inspection and authorized access; provider presence, popularity, metadata, or a screenshot is not proof of quality.
- Product judgment must remain labeled as judgment.
- Google Stitch is an external visualization surface, not an authority or evidence source.
- Link to official external pages; do not copy, mirror, bundle, or offer external material for download.
- Preserve Design Arc's evidence modes, approval gates, authorization boundaries, installation, upgrade behavior, limitations, and trademarks.
- External links verified on 2026-08-07:
  - `https://developer.apple.com/design/human-interface-guidelines/`
  - `https://developer.android.com/design/ui/mobile`
  - `https://developer.android.com/guide/topics/ui/accessibility`
  - `https://m3.material.io/`
  - `https://www.w3.org/TR/WCAG22/`
  - `https://www.w3.org/WAI/ARIA/apg/`
  - `https://mobbin.com/`
  - `https://stitch.withgoogle.com/`

---

### Task 1: Opening Positioning and Trusted Sources Library

**Files:**
- Modify: `README.md`
- Create: `docs/trusted-sources/README.md`
- Create: `docs/trusted-sources/platform-guidance.md`
- Create: `docs/trusted-sources/product-benchmarks.md`
- Create: `docs/trusted-sources/visualization.md`

**Interfaces:**
- Consumes: Evidence hierarchy and wording approved in `docs/superpowers/specs/2026-08-07-trusted-evidence-positioning-design.md`.
- Produces: A README-local link to `docs/trusted-sources/README.md` and three focused source guides linked from that index.

- [ ] **Step 1: Capture the current opening for comparison**

Run:

```bash
sed -n '1,85p' README.md
```

Expected: the opening says “evidence-backed” but does not explain grounding before `## You need Design Arc if…`.

- [ ] **Step 2: Write the repository source guides**

Create the four Markdown files with this division of responsibility:

```text
docs/trusted-sources/README.md             why grounding matters; four-layer overview; links to the three guides
docs/trusted-sources/platform-guidance.md  Apple, Android, Material, W3C authority and platform precedence
docs/trusted-sources/product-benchmarks.md benchmark precedent, Mobbin role, inspection and access limits
docs/trusted-sources/visualization.md       Stitch visualization role, validation value, and non-authority boundary
```

Every page must include `Last checked: 2026-08-07`, use the official URLs in Global Constraints, explain what each source supports, and state what it cannot prove.

- [ ] **Step 3: Replace the README opening with the approved comprehension sequence**

Use this primary outcome line:

```markdown
**Move from uncertain product feedback to a complete design direction grounded in credible sources.**<br>
```

Follow it before the first section heading with:

```markdown
### Grounded, not guessed

Attractive screens can still fail when they ignore platform behavior, copy an isolated pattern without its journey, or hide product judgment as fact. Grounding gives every recommendation a visible reason: what users currently experience, what the platform requires, what relevant products demonstrate, and where Design Arc is making a judgment.
```

Add the approved four-row table with columns `Grounding layer`, `Why it matters`, and `Credible sources`, covering platform requirements, product precedent, product judgment, and visualization and validation. Add this link immediately below it:

```markdown
[Explore the trusted sources and why Design Arc uses them](docs/trusted-sources/README.md)
```

- [ ] **Step 4: Align the later evidence heading**

Change:

```markdown
## Choose your evidence approach
```

to:

```markdown
## Choose how Design Arc grounds its recommendations
```

Do not change the two evidence-mode contracts beneath it.

- [ ] **Step 5: Review the user-visible diff**

Run:

```bash
git diff -- README.md docs/trusted-sources
```

Expected: the grounding value and source link appear before the first existing section; the deeper pages teach why, what, and who rather than reading as a bare bibliography.

- [ ] **Step 6: Commit Task 1**

```bash
git add README.md docs/trusted-sources
git commit -m "docs: foreground Design Arc trusted sources"
```

### Task 2: Repository Validation and Independent Review

**Files:**
- Modify: `scripts/validate.sh`
- Modify: `scripts/test-validate.sh`
- Test: `scripts/test-test-validate.sh`

**Interfaces:**
- Consumes: The four source-library files and README link created by Task 1.
- Produces: Fail-closed repository validation for missing source-library files and the unchanged complete Design Arc release suite.

- [ ] **Step 1: Add a failing required-file regression**

Extend the validator regression so a temporary checkout with `docs/trusted-sources/README.md` removed must fail with the required-files gate. Exercise the real `scripts/validate.sh`; do not test a mock or merely grep source text.

- [ ] **Step 2: Run the regression and verify RED**

Run:

```bash
sh scripts/test-test-validate.sh
```

Expected: FAIL because the source-library files are not yet part of the required-file contract.

- [ ] **Step 3: Add all four source-library files to required validation**

Update `scripts/validate.sh` and its focused validator expectations so missing any of these paths fails:

```text
docs/trusted-sources/README.md
docs/trusted-sources/platform-guidance.md
docs/trusted-sources/product-benchmarks.md
docs/trusted-sources/visualization.md
```

- [ ] **Step 4: Verify GREEN and run the complete suite**

Run:

```bash
sh scripts/test-test-validate.sh
sh scripts/test-design-arc-docs.sh
sh scripts/validate.sh
git diff --check
```

Expected: all commands PASS, including the 103 deterministic workflow mutations, install/migration/upgrade smokes, safety scans, syntax, and diff checks.

- [ ] **Step 5: Obtain independent review**

Review the entire implementation against the approved spec. The reviewer must check source authority, platform precedence, benchmark and Stitch limitations, official-link destinations, clarity for nontechnical readers, absence of copied external material, and preservation of all existing workflow and release boundaries.

- [ ] **Step 6: Commit Task 2 and stop before publication**

```bash
git add scripts/validate.sh scripts/test-validate.sh scripts/test-test-validate.sh
git commit -m "test: require Design Arc trusted source guides"
```

Keep the branch clean and unpushed. Publishing requires separate current-conversation approval.
