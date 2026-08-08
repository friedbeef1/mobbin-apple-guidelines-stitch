# Using Design Arc

[Home](../README.md) · [Getting started](getting-started.md) · [Using Design Arc](using-design-arc.md) · [Evidence and methodology](evidence-and-methodology.md) · [Upgrades and migration](upgrades-and-migration.md) · [Trust and sources](trust-limitations-and-sources.md)

How do I use Design Arc after installation?

## Start a review in ordinary language

You do not need to remember a command for ordinary journey work. Describe the journey in ordinary language, such as:

- “Help me make our onboarding less confusing.”
- “Audit how customers complete checkout and propose a better complete journey.”
- “Redesign account recovery so people can get back in without weakening security.”

For setup, recovery, or one-run preferences, use:

```text
$design-arc setup
$design-arc home
$design-arc evidence benchmarks
$design-arc evidence guidelines
$design-arc mode
$design-arc mode guided
$design-arc mode follow-recommendation
$design-arc mode fully-automatic
```

Natural-language requests such as “use Guidelines for this run” or “follow your recommendation this time” are one-run overrides; they do not rewrite the saved project preference.

## Coming back tomorrow

Setup can add one approved, pinned home named `Design Arc — <Project Name>` to each project where you choose to use Design Arc.

| When | What you do |
| --- | --- |
| First day | Open the project, run `$design-arc setup`, choose the two project preferences, and approve or decline its proposed home. |
| Next day | Open that project’s pinned `Design Arc — <Project Name>` task and describe the journey in ordinary language. |
| New product | Open the new saved project and run setup there once. Its preferences and optional home stay separate from every other product. |

Each home is a launchpad, not a workspace for the design review. Every journey starter opens a clean local task in that same saved project, while the pinned home stays available for the next request.

There is no global Design Arc home. A project with no confirmed Design Arc setup receives no home and no sidebar item. Design Arc reuses an existing home for the same title and project instead of creating a duplicate. If it finds extra same-project homes, it reports them for you to clean up; it never deletes them.

If Codex cannot create or pin the task, Design Arc saves confirmed preferences, says clearly that no home is ready, and gives you the exact title, starter card, and manual create-and-pin steps. Run `$design-arc home` later to report, create, recover, or repin the current project’s home.

## Approval and trust controls

> Design Arc does not silently redesign, implement, or deploy your product. You choose the objective, evidence approach, and approval behavior.

Objective Confirmation establishes the product outcome before the audit or evidence gathering begins. The Direction Gate confirms the recommended design direction; the Stitch Gate confirms the validated visual proposal.

| Approval mode | Objective | Stitch Gate |
| --- | --- | --- |
| **Guided** — recommended for a new project | Confirm; stop at Direction Gate | Stop for approval |
| **Follow recommendation** | Confirm; continue at Direction Gate with the visibly marked recommendation | Stop for approval |
| **Fully automatic** | The current request must state an explicit objective; continue at Direction Gate with the visibly marked recommendation | Continue only after a `meets direction` verdict |

“Follow your recommendation” is a one-run Follow recommendation alias. “Bypass both gates” is a one-run Fully automatic alias, but it never permits Design Arc to invent a missing objective. Automatic modes change decision pauses, not the audit, evidence, complete-state, validation, or ownership requirements.

Next: [Evidence and methodology](evidence-and-methodology.md).
