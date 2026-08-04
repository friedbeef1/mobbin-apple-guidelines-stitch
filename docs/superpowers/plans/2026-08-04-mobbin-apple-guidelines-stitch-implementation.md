# Mobbin - Apple Guidelines - Stitch Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build, validate, install, document, and publicly publish a standalone Codex skill that converts a user-confirmed product objective into an evidence-backed Mobbin, Apple-guidelines, and Stitch journey proposal.

**Architecture:** Keep the repository intentionally small: one self-contained skill, one human-facing README, one prompt-example file, and one deterministic repository validator. The skill owns behavior and gate semantics; the README explains the purpose and why every step is necessary; the examples demonstrate invocation without weakening the rules.

**Tech Stack:** Markdown, YAML, POSIX shell, Python 3 validation helpers, Git, GitHub CLI.

**Status:** Complete. The validated skill is published at `friedbeef1/mobbin-apple-guidelines-stitch` on public `main`.

**Approved publication exception:** The user approved a tested, single-commit source snapshot specifically because iCloud made 62 objects from the original local Git history dataless and unable to hydrate, causing Git object packaging and both HTTPS and SSH pushes from that history to stall. The snapshot published only the validated tracked source. The original local repository and its multi-commit history remain untouched; the initial public snapshot commit was `5bbfed8133c88a3341f776e5f5dc76b8f4117670`.

## Global Constraints

- Public display name: `Mobbin - Apple Guidelines - Stitch`.
- Repository slug: `mobbin-apple-guidelines-stitch`.
- Internal skill name remains `validating-ui-with-guidelines-and-mobbin`.
- This is a standalone Codex skill repository, not a Codex plugin, marketplace package, MCP server, connector, or application.
- Objective Confirmation occurs before product audit or external research.
- If the objective is stated initially, restate it and ask the user to confirm or revise it.
- Offer two or three context-specific objective choices when useful and always allow free-form input.
- `Follow your recommendation` bypasses only the Direction Approval Gate.
- `Bypass both gates` bypasses the Direction and Stitch Approval Gates, but never Objective Confirmation or integrity/authority boundaries.
- Apple provides platform grounding and final validation; Mobbin provides inspected design precedent; Stitch visualizes the selected complete journey.
- No proprietary Mobbin content, private product artifacts, credentials, unsupported compliance claims, implementation authority, staging authority, or live-release authority may be distributed or implied.
- Use the MIT license and include an independent-project trademark disclaimer.

---

### Task 1: Behavior Contract and Skill Validation

**Files:**
- Create: `docs/validation/behavioral-validation.md`
- Create: `skills/validating-ui-with-guidelines-and-mobbin/SKILL.md`
- Create: `skills/validating-ui-with-guidelines-and-mobbin/agents/openai.yaml`

**Interfaces:**
- Consumes: Approved design at `docs/superpowers/specs/2026-08-04-mobbin-apple-guidelines-stitch-design.md` and the installed source at `/Users/jamesyeang/.codex/skills/validating-ui-with-guidelines-and-mobbin/`.
- Produces: A distributable skill whose observable state machine is Objective Confirmation → audit → light Apple grounding → Mobbin discovery → directions → Direction Gate → full Apple validation → Stitch journey → Codex evidence → Stitch Gate → authorized routing.

- [x] **Step 1: Record failing baseline scenarios**

Create `docs/validation/behavioral-validation.md` with these three raw scenarios and a `Baseline result` field for each:

1. `Redesign this onboarding and bypass both gates.` Expected: ask the user to choose or write the intended outcome before inspecting the product or external sources.
2. `I want fewer onboarding drop-offs.` Expected: restate that objective and ask the user to confirm or revise it before research.
3. `My confirmed objective is fewer onboarding drop-offs. Follow your recommendation.` Expected: bypass only the Direction Gate and stop after the validated Stitch proposal.

Run each scenario against the currently installed skill using fresh-context agents. Record their outputs verbatim enough to show whether Objective Confirmation and gate semantics are missing or inconsistent.

- [x] **Step 2: Verify the baseline fails for the new objective contract**

Expected: at least one baseline response begins audit/research or treats `bypass both gates` as permission to proceed without confirming the objective. If every response already satisfies the new contract, document that result and retain the scenarios as regression evidence.

- [x] **Step 3: Author the packaged skill**

Copy the validated existing journey and gate rules, then make these sections explicit in `SKILL.md`:

- `Why This Workflow Exists`: explain that generated screens are not useful unless they solve a user-confirmed goal and survive evidence checks.
- `Objective Confirmation`: require user choice or free-form input before audit/research; state that two-gate bypass never bypasses intent confirmation.
- `Workflow`: give the ordered state machine in the interface above.
- `Why Every Step Matters`: a table with `Step`, `Why crucial`, and `Failure if skipped` for all workflow stages.
- `Approval Modes`: preserve the three modes exactly.
- `Required Output`, `Integrity Gates`, `Quick Check`, and `Common Mistakes`.

Update `agents/openai.yaml` to use display name `Mobbin - Apple Guidelines - Stitch`, a concise description, and a default prompt that begins with Objective Confirmation.

- [x] **Step 4: Validate the skill structure**

Run:

```bash
python3 /Users/jamesyeang/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/validating-ui-with-guidelines-and-mobbin
```

Expected: `Skill is valid!`

- [x] **Step 5: Re-run the three behavioral scenarios**

Use fresh-context agents with the packaged skill. Record the post-change output and verdict for each scenario in `docs/validation/behavioral-validation.md`.

Expected: all three scenarios satisfy Objective Confirmation and gate semantics without treating either design-gate bypass as implementation or deployment authority.

- [x] **Step 6: Commit the behavioral contract**

```bash
git add skills/validating-ui-with-guidelines-and-mobbin docs/validation/behavioral-validation.md
git commit -m "feat: add objective-led UI evidence skill"
```

### Task 2: Explanatory Documentation and Examples

**Files:**
- Create: `README.md`
- Create: `examples/prompts.md`
- Create: `LICENSE`
- Create: `.gitignore`

**Interfaces:**
- Consumes: The packaged skill behavior from Task 1.
- Produces: Human-readable installation, rationale, operating sequence, examples, limitations, and licensing.

- [x] **Step 1: Write the README purpose and non-goals**

Lead with the problem: UI work often jumps from subjective dissatisfaction to attractive screens without confirming the user outcome or validating the journey. Explain that the skill makes the reasoning auditable by assigning distinct roles to the user, Apple guidance, Mobbin, Stitch, and Codex.

State clearly that the repository is a standalone skill, not a plugin or official Mobbin, Apple, Google, or Stitch integration.

- [x] **Step 2: Explain why every step is crucial**

Include a readable table covering:

1. Objective Confirmation prevents optimization for the wrong outcome.
2. Current-journey audit prevents redesigning an imagined product.
3. Light Apple grounding prevents Mobbin examples from becoming unconstrained imitation.
4. Mobbin discovery supplies real journey precedent Apple guidance does not provide.
5. Direction recommendations expose trade-offs before generation cost is incurred.
6. Direction approval preserves user control over product intent.
7. Full official validation catches platform and accessibility conflicts before visualization.
8. Complete Stitch generation reveals missing transitions, empty/error/recovery states, and journey coherence.
9. Inline Codex evidence makes approval possible without reconstructing the proposal in Stitch.
10. Render validation prevents metadata or attractive appearance from becoming false compliance claims.
11. Stitch approval prevents a generated artifact from silently becoming an implementation mandate.
12. Authorized routing preserves ownership, staging, and release boundaries.

- [x] **Step 3: Add exact installation instructions**

Document direct installation from the future public repository:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo friedbeef1/mobbin-apple-guidelines-stitch \
  --path skills/validating-ui-with-guidelines-and-mobbin
```

Also document a manual copy fallback and state that the skill becomes available on the next Codex turn. Mention that access to Mobbin and Stitch is external and not bundled.

- [x] **Step 4: Write three prompt examples**

In `examples/prompts.md`, include:

- Default mode: ask to review a journey and stop at both design gates.
- Recommended-direction mode: explicitly say `Follow your recommendation`; still stop at Stitch.
- Two-gate bypass mode: explicitly say `Bypass both gates`; still require Objective Confirmation and preserve integrity/implementation boundaries.

Each example must let the user choose from suggested objectives or enter their own.

- [x] **Step 5: Add license, ignore rules, and disclaimer**

Add the standard MIT license with copyright year `2026` and holder `James Yeang`. Add a minimal `.gitignore` for `.DS_Store`, editor state, temporary files, and Python cache files. State in the README that Mobbin, Apple, Google, and Stitch marks belong to their respective owners and no affiliation or endorsement is implied.

- [x] **Step 6: Check documentation consistency**

Run:

```bash
rg -n "plugin|Objective Confirmation|Why.*crucial|Follow your recommendation|Bypass both gates|implementation|deployment" README.md examples/prompts.md skills/validating-ui-with-guidelines-and-mobbin/SKILL.md
git diff --check
```

Expected: `plugin` appears only in explicit “not a plugin” statements; all required concepts appear; `git diff --check` exits successfully.

- [x] **Step 7: Commit documentation**

```bash
git add README.md examples/prompts.md LICENSE .gitignore
git commit -m "docs: explain the evidence-led journey workflow"
```

### Task 3: Deterministic Repository Validation

**Files:**
- Create: `scripts/validate.sh`
- Create: `scripts/test-validate.sh`

**Interfaces:**
- Consumes: Repository paths and the packaged skill metadata.
- Produces: Exit code `0` plus concise pass messages when structure, naming, safety, and Markdown invariants hold; non-zero exit on any violation.

- [x] **Step 1: Write a failing validator invocation**

Run before creating the script:

```bash
./scripts/validate.sh
```

Expected: FAIL because `scripts/validate.sh` does not exist.

- [x] **Step 2: Implement the minimal validator**

Create an executable POSIX shell script that:

- Resolves the repository root from the script location.
- Confirms all required files exist.
- Confirms `SKILL.md` begins with YAML frontmatter and contains the exact internal name.
- Confirms `openai.yaml` contains `Mobbin - Apple Guidelines - Stitch`.
- Confirms README installation path matches `skills/validating-ui-with-guidelines-and-mobbin`.
- Confirms Objective Confirmation and both approval-gate phrases appear in the skill and README.
- Rejects private keys, bare and `export`/`env`-prefixed common credential assignments, `/Users/` paths outside historical design/plan docs, and proprietary image/media artifacts.
- Runs `git diff --check` when executed inside a Git worktree.

- [x] **Step 3: Run the repository validator**

```bash
chmod +x scripts/validate.sh
./scripts/validate.sh
```

Expected: all checks pass with exit code `0`.

- [x] **Step 4: Prove a negative case**

Temporarily change the display-name check target in a copy of `agents/openai.yaml` under a temporary directory and run the relevant validation condition against it. Also prove that `export`, `env`, and repeated shell prefixes cannot conceal credential assignments from the safety scan.

Expected: non-zero exit identifying the display-name mismatch. Remove only the temporary directory afterward.

- [x] **Step 5: Run the full local verification set**

```bash
python3 /Users/jamesyeang/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/validating-ui-with-guidelines-and-mobbin
./scripts/validate.sh
git diff --check
git status --short
```

Expected: skill and repository validation pass; only intentional files are uncommitted.

- [x] **Step 6: Commit validation tooling**

```bash
git add scripts/validate.sh
git commit -m "test: add distributable skill validation"
```

### Task 4: Synchronize the Installed Skill

**Files:**
- Modify: `/Users/jamesyeang/.codex/skills/validating-ui-with-guidelines-and-mobbin/SKILL.md`
- Modify: `/Users/jamesyeang/.codex/skills/validating-ui-with-guidelines-and-mobbin/agents/openai.yaml`

**Interfaces:**
- Consumes: Validated packaged skill from Tasks 1–3.
- Produces: The next Codex turn discovers the same behavior and display metadata as the public repository.

- [x] **Step 1: Compare packaged and installed files**

```bash
diff -u /Users/jamesyeang/.codex/skills/validating-ui-with-guidelines-and-mobbin/SKILL.md skills/validating-ui-with-guidelines-and-mobbin/SKILL.md
diff -u /Users/jamesyeang/.codex/skills/validating-ui-with-guidelines-and-mobbin/agents/openai.yaml skills/validating-ui-with-guidelines-and-mobbin/agents/openai.yaml
```

Expected: differences show Objective Confirmation, why-each-step explanations, and the new display name.

- [x] **Step 2: Apply the validated packaged content to the installed skill**

Use `apply_patch` for both installed files. Do not modify any other global skill or plugin configuration.

- [x] **Step 3: Validate the installed skill**

```bash
python3 /Users/jamesyeang/.codex/skills/.system/skill-creator/scripts/quick_validate.py /Users/jamesyeang/.codex/skills/validating-ui-with-guidelines-and-mobbin
diff -u /Users/jamesyeang/.codex/skills/validating-ui-with-guidelines-and-mobbin/SKILL.md skills/validating-ui-with-guidelines-and-mobbin/SKILL.md
diff -u /Users/jamesyeang/.codex/skills/validating-ui-with-guidelines-and-mobbin/agents/openai.yaml skills/validating-ui-with-guidelines-and-mobbin/agents/openai.yaml
```

Expected: `Skill is valid!`; both diffs produce no output.

### Task 5: Final Audit and Public GitHub Publication

**Files:**
- Modify: repository Git metadata only.

**Interfaces:**
- Consumes: Clean validated local repository and authenticated GitHub CLI account `friedbeef1`.
- Produces: Public repository `friedbeef1/mobbin-apple-guidelines-stitch` whose `main` branch matches the validated local commit.

- [x] **Step 1: Run the final safety audit**

```bash
./scripts/validate.sh
git diff --check
git status --short
git log --oneline --decorate -8
```

Expected: validators pass and the intended commits are present.

- [x] **Step 2: Verify GitHub authentication**

```bash
gh auth status
```

Expected: authenticated as `friedbeef1`. Current known state before implementation: the configured token is invalid, so reauthentication is required before publication.

- [x] **Step 3: Restore GitHub authentication if needed**

Run the interactive GitHub CLI login only with the user present:

```bash
gh auth login -h github.com
```

Expected: `gh auth status` succeeds for `friedbeef1`.

- [x] **Step 4: Create and push the public repository**

```bash
gh repo create friedbeef1/mobbin-apple-guidelines-stitch --public --source=. --remote=origin --push
```

Expected: GitHub creates the public repository and pushes local `main`.

- [x] **Step 5: Verify remote identity and visibility**

```bash
gh repo view friedbeef1/mobbin-apple-guidelines-stitch --json nameWithOwner,visibility,url,defaultBranchRef
git rev-parse HEAD
git ls-remote origin refs/heads/main
```

Expected: `nameWithOwner` is `friedbeef1/mobbin-apple-guidelines-stitch`, visibility is `PUBLIC`, default branch is `main`, and local/remote commit IDs match.

- [x] **Step 6: Perform a clean-clone smoke check**

Clone the public repository into a `mktemp -d` directory, run `./scripts/validate.sh`, and delete only that validated temporary directory afterward.

Expected: the clean clone passes the same repository validation.

- [x] **Step 7: Report distribution links and remaining boundaries**

Provide the GitHub repository URL, local repository link, direct skill-installation command, validation results, and the known external-access requirements. Do not claim that Mobbin or Stitch access is bundled or that a mockup proves implementation/device compliance.
