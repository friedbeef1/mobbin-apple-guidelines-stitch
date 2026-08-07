# Codex as the Design Arc operating layer

Design Arc is one adaptive workflow. Codex is where the product objective, current-journey evidence, evidence choice, recommendations, gate decisions, validation, and next authorized owner remain connected. The plugin contributes the `$design-arc` skill; it does not add a native provider integration or transfer implementation authority.

## Install once; participate per project

The plugin is installed once for a Codex profile. Setup and return paths remain project-scoped: Design Arc may add one confirmed home per participating saved project, and each project keeps its own evidence and approval preferences. There is no global Design Arc home. A project without confirmed setup gets no home and no sidebar item.

The pinned home is a launchpad, not the place where product work accumulates. Each journey starts in a clean local task in the same saved project, so one product’s context and preferences cannot leak into another. An existing matching home is reused; known duplicates are reported for user cleanup rather than deleted or multiplied.

If task tools are unavailable or fail, preference setup may still succeed, but Design Arc must not claim that the home exists. It returns the exact title and complete starter card with manual create-and-pin steps, and keeps the home pending until title, project identity, and pinning are verified.

## What Codex contributes

- Resolves evidence and approval choices independently before product inspection, external research, or generation.
- Establishes the intended outcome before auditing the real journey, including its entry points, transitions, exits, errors, and recovery paths.
- Keeps current first-party requirements, inspected benchmark precedent, and product judgment distinguishable.
- Presents a marked recommendation with meaningful alternatives and trade-offs before visualization.
- Directs a complete visual proposal, critiques actual renders, and returns decision-ready evidence in the task instead of treating a board link or metadata as proof.
- Records each active setting and its provenance, applies the chosen approval policy, and routes only validated design work to the authorized Product/Captain/Integration owner.

## What remains outside Codex

The user owns the product objective, setup choices, and final design decisions. First-party sources remain authoritative for their platforms. Apple Human Interface Guidelines govern Apple targets; Android or web first-party rules override conflicting Apple-inspired judgment on those targets.

Mobbin is an optional external benchmark provider. Google Stitch is an external visualization service. Both require separate access and authorization, neither is bundled or official, and neither authorizes product-source changes. Stitch output is a proposal, not implementation, accessibility, safe-area, browser/native, or physical-device proof.

## Preference and provenance

Design Arc stores project-scoped choices in `.codex/design-arc.yaml`:

```yaml
evidence_mode: benchmarks
benchmark_provider: mobbin
approval_mode: guided
```

One-run request overrides take precedence without rewriting saved values. Otherwise Codex uses the saved Design Arc preference, a confirmed legacy import when the new file is absent, or first-use selection for anything still missing. Codex reports the active evidence mode and approval mode and the provenance of each independently.

Legacy imports are proposed, never silent. The former FB UX preference maps to Benchmarks and provider `mobbin`; the former Apple Guidelines + Stitch preference maps to Guidelines. The old approval choice is retained. When both files exist, the user chooses one mapping or starts fresh. Design Arc never silently merges, rewrites, or deletes the old files.

## Objective and approval discipline

Objective handling precedes inspection and research. Guided and Follow recommendation restate the user's outcome and request confirmation. Fully automatic can skip that pause only when the current request supplies an explicit objective; a missing or materially ambiguous objective always stops the run.

Approval modes change pauses, not rigor:

| Mode | Direction Gate | Stitch Gate |
| --- | --- | --- |
| Guided | Stop for the user's choice | Stop after render validation |
| Follow recommendation | Continue with the visible marked recommendation | Stop after render validation |
| Fully automatic | Continue with the visible marked recommendation | Continue only on `meets direction`; all other verdicts stop |

“Follow your recommendation” and “Bypass both gates” are one-run aliases. Neither rewrites the saved preference, waives the explicit-objective rule, hides alternatives, lowers evidence quality, or changes ownership.

## Evidence discipline

Benchmarks mode requires separately authorized access, complete and relevant inspected journeys, and a stated reason each selected pattern helps the confirmed objective. Library presence, metadata, popularity, or a single screenshot does not prove best-in-class quality. Missing access stops the workflow until the user selects a one-run Guidelines fallback or confirms a saved switch.

Guidelines mode performs no benchmark lookup and makes no benchmark-evidence claim. Both modes require current first-party guidance for every affected platform and distinguish platform requirements from product judgment.

Codex must not claim a journey was inspected, guidance was current, benchmark evidence supports a decision, a new visual proposal was generated, or a viewport was exact without current-task evidence. Appearance alone does not prove accessibility, safe-area, browser/native, or physical-device behavior.

## Authorized boundary

After a Guided or Follow recommendation Stitch approval, or a Fully automatic `meets direction` verdict, Codex may route the validated design proposal to the authorized owner. No mode or external-service authorization authorizes source implementation, staging, deployment, or release. Destructive changes, provider changes, live actions, and work outside the authorized integration lane require separate scope and permission.
