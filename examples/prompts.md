# Design Arc prompt examples

The examples below use the Codex command surface unless a Claude Code equivalent is shown. In Claude Code, start a review with `/design-arc:design-arc`; use `.claude/design-arc.yaml`, and return in a clean project session rather than through a Codex home.

Use `$design-arc`, ask for Design Arc by name, or return through the project’s pinned home. Codex may select Design Arc for an unprefixed request, but automatic selection is not guaranteed and an ordinary Codex response is not presented as Design Arc work.

## Plain-language journey starters

> `$design-arc` Help me make our onboarding less confusing.

> `$design-arc` Audit how customers complete checkout and propose a better complete journey.

> `$design-arc` Redesign account recovery so people can get back in without weakening security.

Other natural starters work too after Design Arc is active: describe the journey, who is using it, and what should become easier or more successful. If the outcome is unclear, Design Arc offers a few choices and lets you write your own.

## Returning through a project home

Install Design Arc once, then approve an optional pinned home during setup in each participating saved project. The next day, open `Design Arc — <Project Name>` and enter any plain-language journey starter. The home remains a launchpad; the actual review opens in a clean local task in the same saved project.

There is no global home, and projects without confirmed setup receive no sidebar item. If Design Arc finds the same project home again, it reuses it rather than creating a duplicate. If task tools are unavailable, it reports that no home is ready and returns the exact title, starter card, and manual create-and-pin steps.

## Preference and recovery commands

Commands remain available when you want to set or inspect project preferences or manage a home explicitly:

```text
$design-arc setup
$design-arc home
$design-arc upgrade
$design-arc evidence benchmarks
$design-arc evidence guidelines
$design-arc mode
$design-arc mode guided
$design-arc mode follow-recommendation
$design-arc mode fully-automatic
```

Design Arc resolves the evidence approach and approval behavior independently. A one-run override changes only the current task unless you explicitly ask Design Arc to save it.

## Safe upgrade

> Upgrade Design Arc safely. Preserve every project's preferences, pinned home, files, and active reviews.

> Check whether Design Arc has an update, but do not install anything yet.

## First-run setup

> `$design-arc setup`. Help me choose the evidence approach and approval behavior independently. Show the proposed `.codex/design-arc.yaml` values before saving them. Then help me choose or write the objective for our onboarding review before inspecting the product.

## Save Guidelines + Benchmarks and Guided

> `$design-arc evidence benchmarks`, using our separately authorized Mobbin access. `$design-arc mode guided`. Save both for this project. For the checkout review, first suggest two or three plausible objectives and let me choose one or enter my own. After I confirm it, inspect the complete current journey, use relevant full-journey benchmarks and current first-party platform guidance, and stop at the Direction and Stitch gates.

## Save Guidelines only and Follow recommendation

> `$design-arc evidence guidelines`. `$design-arc mode follow-recommendation`. Save both for this project. My objective is to reduce uncertainty during account recovery without weakening security. Confirm that objective, audit the real journey, use current first-party guidance without benchmark lookup, show your recommendation and alternatives, follow the marked recommendation, and stop at the Visual Proposal Gate.

## Save Fully automatic

> `$design-arc mode fully-automatic`. Save it for this project. My explicit objective is to help new users reach their first useful result with fewer unnecessary decisions. Review the Android and web onboarding journey, apply current Android and web first-party rules over conflicting Apple-inspired judgment, use the saved evidence choice, show the marked direction and alternatives, and continue past the Visual Proposal Gate only when the verdict is `meets direction`. Preserve all source, staging, deployment, release, device-proof, external-service, and lane-ownership boundaries.

## Report active settings

> `$design-arc mode`. Report the active evidence mode and approval mode, the saved value of each, and whether each active value comes from the current request, the saved Design Arc preference, a confirmed legacy import, or first-use selection.

## Override one run without changing the project

> Use `$design-arc` with Guidelines only and Guided for this run only. My objective is to improve first-session activation without forcing optional profile setup. Confirm the objective, perform no benchmark lookup, stop at both design gates, and do not change the saved project preference.

The shorter phrase `use Guidelines only for this run` changes only the current evidence route. `Follow your recommendation` is a one-run Follow recommendation alias and still stops at the Visual Proposal Gate.

## Missing benchmark access

> Use `$design-arc` with the saved Guidelines + Benchmarks preference. If authorized benchmark access is unavailable, stop and let me choose between a one-run Guidelines only fallback and a saved switch. Do not silently degrade or call a Guidelines only result benchmark-backed.

After the stop, a one-run response can be:

> Use Guidelines only for this run. Keep the saved Guidelines + Benchmarks preference unchanged, perform no benchmark lookup or benchmark-evidence claim, and continue under the active approval mode.

## Bypass both gates for one explicit objective

> Use `$design-arc`. Bypass both gates for this run. My explicit objective is to reduce checkout abandonment caused by unclear delivery choices while preserving accurate delivery promises. Keep the alternatives and automatic selection visible, validate every material state, and continue past Stitch only on `meets direction`. This does not authorize implementation or deployment.

`Bypass both gates` is a one-run Fully automatic alias. Without an explicit current-request objective, Design Arc must stop before inspection or research.

## Import a legacy preference

> `$design-arc setup`. The new preference does not exist. Inspect the former project preference, show its proposed Design Arc mapping including the preserved approval mode, and ask once before importing. Do not modify or delete the old file.

If both legacy files exist:

> Present both possible mappings and let me choose one or start fresh. Do not merge them.

## Switch saved evidence route

> `$design-arc evidence guidelines`. Save Guidelines only for this project and omit `benchmark_provider`. Do not look up or claim benchmark evidence on later Guidelines only runs.

> `$design-arc evidence benchmarks`. Confirm that relevant external benchmark access is authorized, then save Guidelines + Benchmarks and the selected provider for this project.
