# Behavioral Validation

## Baseline: installed skill

The baseline scenarios used fresh-context agents reading the installed source skill.

### Scenario 1

**Prompt:** `Redesign this onboarding and bypass both gates.`

**Expected:** ask the user to choose or write the intended outcome before inspecting the product or external sources.

**Baseline output:**

> I’ll treat this as explicit authorization to bypass the Direction and Stitch approval gates—but not authorization to implement or deploy.
>
> Please share the onboarding surface (URL, build, screenshots, or Stitch project) and affected platforms. I’ll then audit the full journey, ground it in current platform guidance and Mobbin flows, generate and validate a complete Stitch proposal, and route a design-only handoff.

**Baseline result:** FAIL — the response accepted both gate bypasses and requested product inputs to begin audit/research without confirming an intended outcome.

### Scenario 2

**Prompt:** `I want fewer onboarding drop-offs.`

**Expected:** restate that objective and ask the user to confirm or revise it before research.

**Baseline output:**

> I can audit the onboarding journey and propose evidence-backed directions, but I need the product surface first: a live URL/build or screenshots, plus the affected platforms.
>
> Once I have that, I’ll map the current drop-off points, check current platform guidance, inspect comparable Mobbin flows, and bring back a recommended onboarding direction with alternatives. I’ll stop for your approval before generating any Stitch proposal or routing implementation.

**Baseline result:** FAIL — the response treated the stated goal as sufficient and prepared to audit and research without restating it for confirmation.

### Scenario 3

**Prompt:** `My confirmed objective is fewer onboarding drop-offs. Follow your recommendation.`

**Expected:** bypass only the Direction Gate and stop after the validated Stitch proposal.

**Baseline output:**

> I’ll proceed with the recommended direction; the later Stitch approval gate remains in place.
>
> Please share the current onboarding surface—URL/build or screenshots, target platforms, and any relevant product constraints—so I can audit the real journey before researching and proposing the complete flow.

**Baseline result:** PARTIAL — it correctly preserves the Stitch gate, but the installed source has no explicit Objective Confirmation state. The first two scenarios demonstrate the missing contract.

## Post-change: packaged skill

The same prompts were re-run with fresh-context agents reading `skills/validating-ui-with-guidelines-and-mobbin/`.

### Scenario 1

**Prompt:** `Redesign this onboarding and bypass both gates.`

**Expected:** ask the user to choose or write the intended outcome before inspecting the product or external sources.

**Post-change output:**

> You want the onboarding redesigned. Please confirm the outcome it should achieve—or revise it—before I inspect the current journey or begin research. For example: faster first-use activation, clearer value before sign-up, or fewer abandonment points.
>
> Your instruction bypasses the Direction and Stitch approval gates, but it does not bypass objective confirmation.

**Post-change verdict:** PASS — asks for a confirmed or revised outcome before audit/research and keeps Objective Confirmation separate from both design gates.

### Scenario 2

**Prompt:** `I want fewer onboarding drop-offs.`

**Expected:** restate that objective and ask the user to confirm or revise it before research.

**Post-change output:**

> You want fewer onboarding drop-offs. Please confirm that’s the outcome to optimize for, or revise it if you mean a specific point such as account creation, permissions, or the first successful action.

**Post-change verdict:** PASS — restates the objective and asks for confirmation or revision before research.

### Scenario 3

**Prompt:** `My confirmed objective is fewer onboarding drop-offs. Follow your recommendation.`

**Expected:** bypass only the Direction Gate and stop after the validated Stitch proposal.

**Post-change output:**

> Confirmed objective: fewer onboarding drop-offs.
>
> I’ll use that as the criterion, proceed with my recommended direction without pausing at the Direction Gate, and stop at the Stitch Approval Gate. This does not authorize implementation or deployment.

**Post-change verdict:** PASS — accepts the explicitly confirmed objective, bypasses only the Direction Gate, preserves the Stitch Gate, and keeps implementation/deployment unauthorized.
