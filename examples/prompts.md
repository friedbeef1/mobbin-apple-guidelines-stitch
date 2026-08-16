# Design Arc prompt examples

Start in ordinary language in either runtime. You do not need to remember a command, and automatic skill selection is not guaranteed: ask for Design Arc by name when you want certainty.

## Plain-language journey starters

> Help me make our onboarding less confusing.

> Audit how customers complete checkout and propose a better complete journey.

> Redesign account recovery so people can get back in without weakening security.

Other natural starters work too: describe the journey, who is using it, and what should become easier or more successful. If the outcome is unclear, Design Arc offers a few choices and lets you write your own.

## Optional command forms

Use these only when you prefer a shortcut. Each shared action has the same intent in both runtimes.

| Action | Codex | Claude Code |
| --- | --- | --- |
| Start a review | `$design-arc` | `/design-arc:design-arc` |
| Review setup | `$design-arc setup` | `/design-arc:design-arc setup` |
| Upgrade safely | `$design-arc upgrade` | `/design-arc:design-arc upgrade` |
| Guidelines + Benchmarks | `$design-arc evidence benchmarks` | `/design-arc:design-arc evidence benchmarks` |
| Guidelines only | `$design-arc evidence guidelines` | `/design-arc:design-arc evidence guidelines` |
| Approval mode | `$design-arc mode` | `/design-arc:design-arc mode` |
| Graph assistance | `$design-arc graph` | `/design-arc:design-arc graph` |

For the complete paired matrix—including each approval and graph state—see [Advanced controls](../docs/advanced-controls.md).

## Runtime-only return paths

Codex users can approve an optional pinned project home, then return there and enter a plain-language journey starter. `$design-arc home` is deliberately Codex-only because Claude Code does not create or reuse Codex homes.

Claude Code users can separately approve a `CLAUDE.md` reminder block, then open the same product in a clean Claude Code session and use a plain-language starter or `/design-arc:design-arc`. The reminder is Claude Code-only and is not a project home.

## Preference and recovery examples

### First-run setup

> Help me choose the evidence approach and approval behavior independently. Show the proposed saved values before saving them. Then help me choose or write the objective for our onboarding review before inspecting the product.

Optional shortcut: `$design-arc setup` in Codex or `/design-arc:design-arc setup` in Claude Code.

### Save Guidelines + Benchmarks and Guided

> Use our separately authorized Mobbin access with official platform guidance, and save that evidence approach for this project. Pause for both design approvals. For the checkout review, first suggest two or three plausible objectives and let me choose one or enter my own. After I confirm it, inspect the complete current journey, use relevant full-journey benchmarks and current first-party platform guidance, and stop at the Direction and Stitch gates.

Optional shortcuts: `$design-arc evidence benchmarks` and `$design-arc mode guided` in Codex; `/design-arc:design-arc evidence benchmarks` and `/design-arc:design-arc mode guided` in Claude Code.

### Save Guidelines only and Follow recommendation

> Use current first-party guidance without benchmark lookup, and save that evidence approach for this project. Follow the recommended direction, then stop at the Visual Proposal Gate. My objective is to reduce uncertainty during account recovery without weakening security.

Optional shortcuts: `$design-arc evidence guidelines` and `$design-arc mode follow-recommendation` in Codex; `/design-arc:design-arc evidence guidelines` and `/design-arc:design-arc mode follow-recommendation` in Claude Code.

### Save Fully automatic

> Bypass both gates for this explicit objective and save that approval behavior for this project: help new users reach their first useful result with fewer unnecessary decisions. Review the Android and web onboarding journey, apply current Android and web first-party rules over conflicting Apple-inspired judgment, use the saved evidence choice, show the marked direction and alternatives, and continue past the Visual Proposal Gate only when the verdict is `meets direction`. Preserve all source, staging, deployment, release, device-proof, external-service, and lane-ownership boundaries.

Optional shortcut: `$design-arc mode fully-automatic` in Codex or `/design-arc:design-arc mode fully-automatic` in Claude Code.

### Report active settings

> Report the active evidence mode and approval mode, the saved value of each, and whether each active value comes from the current request, the saved Design Arc preference, a confirmed legacy import, or first-use selection.

Optional shortcut: `$design-arc mode` in Codex or `/design-arc:design-arc mode` in Claude Code.

### Override one run without changing the project

> Use Guidelines only and Guided for this run only. My objective is to improve first-session activation without forcing optional profile setup. Confirm the objective, perform no benchmark lookup, stop at both design gates, and do not change the saved project preference.

The shorter phrase `use Guidelines only for this run` changes only the current evidence route. `Follow your recommendation` is a one-run Follow recommendation alias and still stops at the Visual Proposal Gate.

### Missing benchmark access

> Use the saved Guidelines + Benchmarks preference. If authorized benchmark access is unavailable, stop and let me choose between a one-run Guidelines only fallback and a saved switch. Do not silently degrade or call a Guidelines only result benchmark-backed.

After the stop, a one-run response can be:

> Use Guidelines only for this run. Keep the saved Guidelines + Benchmarks preference unchanged, perform no benchmark lookup or benchmark-evidence claim, and continue under the active approval mode.

### Bypass both gates for one explicit objective

> Bypass both gates for this run. My explicit objective is to reduce checkout abandonment caused by unclear delivery choices while preserving accurate delivery promises. Keep the alternatives and automatic selection visible, validate every material state, and continue past Stitch only on `meets direction`. This does not authorize implementation or deployment.

`Bypass both gates` is a one-run Fully automatic alias. Without an explicit current-request objective, Design Arc must stop before inspection or research.

### Import a legacy preference

> The new preference does not exist. Inspect the former project preference, show its proposed Design Arc mapping including the preserved approval mode, and ask once before importing. Do not modify or delete the old file.

Optional shortcut: `$design-arc setup` in Codex or `/design-arc:design-arc setup` in Claude Code. If both legacy files exist, ask the user to choose one mapping or start fresh; do not merge them.

### Switch saved evidence route

> Save Guidelines only for this project and omit `benchmark_provider`. Do not look up or claim benchmark evidence on later Guidelines only runs.

> Confirm that relevant external benchmark access is authorized, then save Guidelines + Benchmarks and the selected provider for this project.

Optional shortcuts: `$design-arc evidence guidelines` or `$design-arc evidence benchmarks` in Codex; `/design-arc:design-arc evidence guidelines` or `/design-arc:design-arc evidence benchmarks` in Claude Code.
