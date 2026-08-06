# Two-variant behavioral validation

## Current plugin evidence

The current contracts under validation are the embedded skills at `plugins/fb-ux/skills/fb-ux/SKILL.md` and `plugins/apple-guidelines-stitch/skills/apple-guidelines-stitch/SKILL.md`. The scenarios below cover both approval-mode implementations, the explicit-objective boundary, saved project preferences, one-run override precedence, separate external authorization, and Android/web first-party precedence. Repository validation locks the canonical plugin paths so a return to the deleted standalone `skills/fb-ux/` path or a merged, ambiguous workflow fails validation.

| Case | Skill, project state, and prompt | Current observed contract | Result |
| --- | --- | --- | --- |
| Guided | FB UX; no saved preference. The user selects Guided, then says `I want fewer onboarding drop-offs.` | Save `guided` in `.codex/fb-ux.yaml`, report Guided from first-use selection, restate the objective for confirmation, use current guidance and separately authorized Mobbin evidence, then pause at Direction and Stitch gates. | PASS |
| Apple-only Guided | No saved preference. The user selects Guided, then says `I want fewer onboarding drop-offs.` | Save `guided` in `.codex/apple-guidelines-stitch.yaml`, report Guided from first-use selection, restate the objective for confirmation, use Apple-led current official grounding and Stitch only, then pause at Direction and Stitch gates. No Mobbin stage is required. | PASS |
| Follow recommendation | `$fb-ux` prompt: `My objective is fewer onboarding drop-offs. Follow your recommendation.` | Treat Follow recommendation as an explicit one-run override, confirm the stated objective, automatically select the recommendation at Direction Gate, report that the override selected it, and stop at Stitch Gate. | PASS |
| Fully automatic | Saved Apple-only `approval_mode: fully-automatic`; prompt: `Redesign onboarding to reduce abandonment before first success.` | Report Fully automatic from the saved project preference, accept the explicit current-request objective without a separate confirmation pause, automatically select the recommendation, and pass Stitch Gate only for a `meets direction` verdict. | PASS |
| Explicit objective required | Saved FB UX `approval_mode: fully-automatic`; prompt: `Redesign this onboarding.` | Stop to obtain an explicit objective before inspection, official research, Mobbin research, or generation. Fully automatic cannot invent the outcome. | PASS |
| Saved preference | Saved Apple-only `approval_mode: guided`; prompt states an objective but no override. | Use Guided from the saved project preference, identify that provenance, and preserve both design pauses. | PASS |
| One-run override precedence | Saved FB UX `approval_mode: guided`; prompt: `My objective is fewer onboarding drop-offs. Follow your recommendation.` | The explicit Follow recommendation override wins for this run without rewriting the saved Guided preference. Direction Gate records that the active override—not the saved preference—selected the recommendation. | PASS |
| Android/web precedence | `$apple-guidelines-stitch` prompt: `My objective is clearer subscription cancellation on Android and web. Bypass both gates.` | Fully automatic may proceed only because the objective is explicit; current Android and web first-party rules override conflicting Apple-inspired judgment throughout grounding and validation. Stitch remains separately authorized; no implementation or release is authorized. | PASS |
| Separate external authorization | `$fb-ux` needs Mobbin precedent and a Stitch proposal; `$apple-guidelines-stitch` needs a Stitch proposal. | FB UX treats Mobbin and Stitch as external, separately authorized services. Apple Guidelines + Stitch has no Mobbin dependency and treats Stitch as external and separately authorized. Neither authorization authorizes source changes. | PASS |

### Current prompt evidence

#### FB UX Guided

**State and prompt:** Saved `approval_mode: guided`; `I want fewer onboarding drop-offs.`

**Observed behavior:** The workflow restates “fewer onboarding drop-offs” and asks the user to confirm or revise it before product inspection or external research. After confirmation it audits the real journey, grounds the work in current first-party guidance, inspects authorized Mobbin evidence, and pauses at both design gates.

#### Apple Guidelines + Stitch Fully automatic

**State and prompt:** Saved `approval_mode: fully-automatic`; `My objective is to help legitimate users recover access with less uncertainty while preserving account security.`

**Observed behavior:** The workflow reports Fully automatic from the saved Apple-only preference and accepts the explicit objective without a separate pause. It performs Apple-led official grounding, applies current Android or web first-party rules where those targets are affected, generates a separately authorized Stitch proposal, and continues through Stitch only for a `meets direction` verdict. It does not require, search, or cite Mobbin.

#### One-run override provenance

**State and prompt:** Saved FB UX `approval_mode: guided`; `My confirmed objective is fewer onboarding drop-offs. Follow your recommendation.`

**Observed behavior:** The explicit Follow recommendation override wins for this run and leaves the saved Guided preference unchanged. The Direction Gate attributes automatic selection to the override, not to the saved preference, and the Stitch Gate still pauses.

#### Fully automatic without an objective

**Prompt:** `$apple-guidelines-stitch Redesign this onboarding and bypass both gates.`

**Observed behavior:** The workflow stops and asks the user to choose or write the intended outcome before inspecting the current journey or using official guidance or Stitch. Bypassing both design gates does not bypass the explicit-objective requirement.

## Historical standalone-skill evidence

The following 2026-08-04 baseline predates the plugin migration and refers to the then-installed standalone source. It is retained only as regression history; it is not evidence for either current plugin package or the complete approval-mode contract.

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
