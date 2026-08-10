# Design Arc coordination retrospective

Date: 2026-08-10
Window reviewed: previous 48 hours
Audience: internal product and delivery learning

## Executive assessment

Design Arc moved from a frequently revised workflow concept to a public `0.3.0` Codex plugin with explicit evidence roles, approval boundaries, safe upgrade behavior, bounded Stitch repair, local graph assistance, and a much clearer documentation structure. The strongest improvement was not adding more process. It was separating decisions that had repeatedly been blurred: objective versus solution, evidence versus judgment, visualization versus compliance, GitHub publication versus local installation, and focused implementation proof versus repetitive review ceremony.

The release was successful and independently reviewed, but it took too many correction loops to reach the final operating model. Most avoidable mistakes came from expanding scope beyond the actual object being shipped—a skill-only plugin—or from assuming that more ceremony automatically meant more confidence.

## Four-source verification

| Source | Finding |
| --- | --- |
| Project Git | 41 commits were present across branches in the 48-hour window. Public `main` reached Design Arc `0.3.0` at `22233eea4d18a253bd499efc21a58ab61026eb88`. Work covered evidence positioning, motion, documentation navigation, Stitch repair, graph assistance, validation, and release. |
| Codex-wide configuration | One unrelated `writing-for-agents` skill family changed. No existing global skill captured the Codex-plugin publication versus installed-upgrade boundary. Vendor imports and caches were excluded as noise. |
| Obsidian | No modified files were found in the window. |
| Current task | Publication was explicitly approved; GitHub `main`, a fresh public clone, the full validator, version `0.3.0`, remote SHA, and rendered README were verified. The installed plugin was deliberately left unchanged. At the time of this retrospective, a later consent-gated activation change existed only as uncommitted work and was therefore not treated as proven. It was subsequently validated as part of the separate `0.3.1` readiness work. |

## What shipped and why it matters

### 1. The product became understandable

The public identity changed from provider-heavy naming to **Design Arc**, led by the pain it solves: vague feedback, taste-based disagreement, screen-only redesigns, and missing journey states. Apple, Android, Material, W3C, Mobbin, and Stitch moved into their correct roles as evidence or visualization sources rather than the hero message.

Impact: readers can understand the outcome before learning the machinery.

### 2. Human involvement became visible

The workflow documentation was reorganized into a vertical table that names the platform/source handling each step and marks exactly the points requiring the user. This corrected earlier documentation that made the workflow appear more laborious than it is.

Impact: users can see that they primarily describe the outcome and approve design decisions; Codex coordinates the rest.

### 3. Evidence roles stopped bleeding into one another

The grounding model now distinguishes:

- first-party platform guidance as the governing source for platform requirements;
- inspected benchmark journeys as precedent, not proof of quality;
- the confirmed objective and labeled Design Arc synthesis as product judgment;
- Stitch as a visualization surface, not a compliance authority.

Impact: attractive renders and popular examples can no longer be presented as if they establish correctness.

### 4. Stitch drift gained a bounded correction contract

Design Arc now uses one initial complete proposal and at most three proposal-wide correction rounds. Each round batches repairable mismatches and reinspects every important state, including previously matching states that may have regressed. Direction changes and runtime-only proof do not get disguised as automatic retries.

Impact: ordinary rendering drift is corrected before asking for approval, while the process cannot loop indefinitely or silently change the approved direction.

### 5. Graph assistance stayed lightweight

Version `0.3.0` added a local, reconstructable relationship record connecting objectives, requirements, evidence, screens, states, and regression checks. It added no database, service, MCP server, or approval gate. Invalid or unavailable graph data falls back to the standard loop, and the graph never overrides first-party guidance or inspection.

Impact: corrections can be more precise without turning the plugin into a platform or surrendering user control.

### 6. Upgrade safety became part of the product contract

Upgrade and downgrade tests preserve preferences, pinned homes, product files, graph records, and active reviews. Active reviews stay pinned to their starting workflow version. Publication and laptop installation are reported separately.

Impact: plugin improvement no longer implies disruption to participating projects.

## What went wrong

### We initially modeled the wrong thing

Early work mixed “plugin” and “standalone skill,” then used product-development language for a package whose runtime is primarily instructions, validation, and documentation.

Correction: identify the shipped object first. A Codex plugin may contain a skill without becoming an app, service, or deployed product.

### Review ceremony outgrew the risk

The plan repeatedly assigned implementer, reviewer, repairer, and re-reviewer roles per task even after focused slices were green. This created coordination overhead without proportional new evidence.

Correction: preserve green commits; finish remaining related slices in one bounded implementation pass with focused proof; allow one consolidated behavioral repair; then perform one whole-candidate review and one release checkpoint. Reopen earlier work only when integration evidence identifies a real defect.

### Validation missed a relationship invariant

The graph validator originally rejected direct contradictions but missed reverse-direction contradictions such as one relationship conflicting with another expressed in the opposite endpoint order.

Correction: normalize endpoint pairs for symmetric contradiction checks and retain a deterministic regression fixture.

### The final release preflight caught inherited whitespace

The candidate had passed substantial validation, yet `git diff --check` against refreshed public `origin/main` still found trailing whitespace in a documentation spec.

Correction: run the exact public-base diff check immediately before publication, not only earlier in candidate development.

### Documentation repeatedly exposed internal complexity

The README became long; install guidance looked technical; evidence grounding was buried; human involvement was hard to distinguish; and ownership labels initially put Codex before the external source.

Correction: use the README as a short router, lead installation with “Ask Codex,” explain the pain and outcome first, mark only actual human steps, and name the source before Codex when both participate.

### Fresh-agent release reasoning still broadened authority

In a clean baseline test, an agent correctly distinguished GitHub publication from local installation but still proposed unrequested tags, GitHub Releases, backups, and a local upgrade.

Correction: add a reusable skill that maps the user's exact authorization to the surfaces allowed to change and forbids invented release channels or local mutation.

## Ways of working to retain

| Practice | Why it is retained | Durable home |
| --- | --- | --- |
| Confirm the user's objective before evidence research | Prevents optimizing the wrong journey | Design Arc skill contract |
| Separate Direction Gate, Stitch Gate, implementation authority, and release authority | Prevents one approval from silently authorizing later mutations | Design Arc skill contract and docs |
| Preserve green slices and concentrate review at integration boundaries | Reduced ceremony while the complete candidate still passed independent review and 175 deterministic contracts | Existing delivery judgment; no new skill needed because baseline agents already apply it |
| Treat publication and installed upgrade as separate operations | Prevents public release work from disrupting local projects | New `publishing-codex-plugins-safely` skill |
| Verify from the user's real consumption surface | A local pass cannot prove public clone contents or rendered GitHub documentation | New publication skill and repository validation |
| Keep evidence claims narrower than the tools used | Prevents Mobbin/Stitch/graph data from becoming false authority | Design Arc methodology and mutation tests |

## Practices deliberately not converted into skills

- **Consent-gated natural-language Design Arc activation:** was not converted into a global way-of-working skill. It was later validated as a Design Arc-specific `0.3.1` behavior contract, where it belongs.
- **A separate bounded-candidate skill:** the no-guidance baseline already produced the desired lean approach, so another skill would duplicate existing capability.
- **Project-specific Design Arc graph rules:** already enforced inside the plugin and its deterministic tests; duplicating them globally would invite drift.
- **Every wording preference from the README iterations:** useful locally, but too specific to justify global context cost.
- **More agent/reviewer roles:** the retro evidence points toward fewer, better-placed review boundaries, not a new coordination hierarchy.

## New reusable skill

`publishing-codex-plugins-safely` is the only new skill justified by the evidence. It triggers for Codex-plugin publishing, installation, and upgrades; requires exact authorization boundaries; follows the repository's existing release mechanism; verifies a fresh public clone and rendered documentation; and stops publication from silently changing installed plugins or project state.

## Next measurement

The new skill should be judged on the next plugin release by four observable outcomes:

1. No unrequested tag, GitHub Release, marketplace submission, deployment, or local upgrade.
2. No publication claim before remote SHA, fresh public clone, official validation, and rendered documentation are verified.
3. Published and installed versions are reported separately.
4. Existing project preferences, homes, files, and active reviews remain untouched unless a separately authorized upgrade proves preservation.
