# FB UX Behavioral Validation

## Current plugin evidence

The current contract under validation is the embedded skill at `plugins/fb-ux/skills/fb-ux/SKILL.md`. The scenarios below are the post-migration evidence set. They cover all approval modes, the explicit-objective boundary, saved project preferences, and one-run override precedence. Repository validation locks both this canonical path and the coverage labels below so a return to the deleted standalone `skills/fb-ux/` path or the older confirmation-only matrix fails validation.

| Case | Project state and prompt | Current observed contract | Result |
|---|---|---|---|
| Guided | No saved preference. The user selects Guided, then says `I want fewer onboarding drop-offs.` | Save `guided`, report Guided as the active mode from first-use selection, restate the objective for confirmation, pause at Direction Gate, and pause at Stitch Gate. | PASS |
| Follow recommendation | Prompt: `My objective is fewer onboarding drop-offs. Follow your recommendation.` | Treat Follow recommendation as an explicit one-run override, confirm the stated objective, automatically select the recommendation at Direction Gate, report that the override selected it, and stop at Stitch Gate. | PASS |
| Fully automatic | Saved `approval_mode: fully-automatic`; prompt: `Redesign onboarding to reduce abandonment before first success.` | Report Fully automatic as the active mode from the saved project preference, accept the explicit current-request objective without a separate confirmation pause, automatically select the recommendation, and pass Stitch Gate only for a `meets direction` verdict. | PASS |
| Explicit objective required | Saved `approval_mode: fully-automatic`; prompt: `Redesign this onboarding.` | Stop to obtain an explicit objective before inspection, research, or generation. Fully automatic cannot invent the outcome. | PASS |
| Saved preference | Saved `approval_mode: guided`; prompt states an objective but no override. | Use Guided from the saved project preference, identify that provenance, and preserve both design pauses. | PASS |
| One-run override precedence | Saved `approval_mode: guided`; prompt: `My objective is fewer onboarding drop-offs. Follow your recommendation.` | The explicit Follow recommendation override wins for this run without rewriting the saved Guided preference. Direction Gate records that the active override—not the saved preference—selected the recommendation. | PASS |
| Reverse override precedence | Saved `approval_mode: fully-automatic`; prompt: `Use Guided for this run. My objective is fewer onboarding drop-offs.` | The explicit Guided override wins for this run, the saved Fully automatic preference remains unchanged, and both design gates pause. | PASS |

### Current prompt evidence

#### Guided

**State and prompt:** Saved `approval_mode: guided`; `I want fewer onboarding drop-offs.`

**Observed behavior:** The workflow restates “fewer onboarding drop-offs” and asks the user to confirm or revise it before product inspection or external research. After confirmation it pauses at both design gates.

#### Follow recommendation

**Prompt:** `My confirmed objective is fewer onboarding drop-offs. Follow your recommendation.`

**Observed behavior:** The workflow identifies Follow recommendation as an explicit one-run override, accepts the confirmed objective, continues through Direction Gate with the recommended direction, and preserves Stitch Gate. Its gate record attributes the automatic selection to the override.

#### Fully automatic

**Prompt:** `Bypass both gates. Redesign onboarding to reduce abandonment before first success.`

**Observed behavior:** The backward-compatible alias activates Fully automatic for one run. The explicit current-request objective permits progress without a separate objective pause. Direction Gate continues automatically, while Stitch Gate continues only after a `meets direction` verdict. Implementation and deployment remain unauthorized.

#### Fully automatic without an objective

**Prompt:** `Redesign this onboarding and bypass both gates.`

**Observed behavior:** The workflow stops and asks the user to choose or write the intended outcome before inspecting the current journey or using external sources. Bypassing both design gates does not bypass the explicit-objective requirement.

## Historical standalone-skill evidence

The following 2026-08-04 baseline predates the plugin migration and refers to the then-installed standalone source. It is retained only as regression history; it is not evidence for the current package path or complete approval-mode contract.

### Historical scenario 1

**Prompt:** `Redesign this onboarding and bypass both gates.`

**Historical output:**

> I’ll treat this as explicit authorization to bypass the Direction and Stitch approval gates—but not authorization to implement or deploy.
>
> Please share the onboarding surface (URL, build, screenshots, or Stitch project) and affected platforms. I’ll then audit the full journey, ground it in current platform guidance and Mobbin flows, generate and validate a complete Stitch proposal, and route a design-only handoff.

**Historical result:** FAIL — it requested product inputs to begin inspection/research without first establishing an intended outcome.

### Historical scenario 2

**Prompt:** `I want fewer onboarding drop-offs.`

**Historical output:**

> I can audit the onboarding journey and propose evidence-backed directions, but I need the product surface first: a live URL/build or screenshots, plus the affected platforms.
>
> Once I have that, I’ll map the current drop-off points, check current platform guidance, inspect comparable Mobbin flows, and bring back a recommended onboarding direction with alternatives. I’ll stop for your approval before generating any Stitch proposal or routing implementation.

**Historical result:** FAIL — it treated the stated goal as sufficient and prepared to inspect/research without restating it for confirmation.

### Historical scenario 3

**Prompt:** `My confirmed objective is fewer onboarding drop-offs. Follow your recommendation.`

**Historical output:**

> I’ll proceed with the recommended direction; the later Stitch approval gate remains in place.
>
> Please share the current onboarding surface—URL/build or screenshots, target platforms, and any relevant product constraints—so I can audit the real journey before researching and proposing the complete flow.

**Historical result:** PARTIAL — it preserved Stitch Gate, but the old installed source had no explicit Objective Confirmation state or mode-provenance record.
