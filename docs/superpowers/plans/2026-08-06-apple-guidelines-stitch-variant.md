# Apple Guidelines + Stitch Variant Implementation Plan

## Goal

Publish two independently installable Codex plugins from the existing `fb-ux-marketplace` repository:

- `fb-ux`: the existing Apple + Mobbin + Stitch workflow, behaviorally unchanged.
- `apple-guidelines-stitch`: an Apple-led official-guidance + Stitch workflow with no Mobbin dependency or research stage inside its package.

## Global constraints

- Keep the marketplace name `fb-ux-marketplace` and append the new plugin entry.
- Preserve `plugins/fb-ux/` byte-for-byte.
- Use `Apple Guidelines + Stitch` as the new display name and `$apple-guidelines-stitch` as its skill invocation.
- Store its project preference in `.codex/apple-guidelines-stitch.yaml`.
- Preserve Guided, Follow recommendation, and Fully automatic modes, objective confirmation, Direction and Stitch gates, active-mode provenance, evidence integrity, and source/deploy/provider authorization boundaries.
- Apple Human Interface Guidelines are the primary design framework. For Android or web targets, current first-party platform rules override conflicting Apple-inspired judgment.
- Stitch remains external and separately authorized. Do not add MCP servers, apps, hooks, or claims of official integration.
- Do not submit to an official marketplace.

## Task 1: Package and validate the second plugin

Start with failing validation expectations for a second marketplace entry and canonical plugin/skill files. Add `plugins/apple-guidelines-stitch/` with a valid manifest, agent metadata, and the embedded skill. The skill workflow is:

`project preference -> establish objective -> audit -> Apple-led official grounding -> directions -> Direction Gate policy -> full cross-platform validation -> Stitch journey -> Codex evidence -> Stitch Gate policy -> authorized routing`

Validate both plugin manifests and skills independently. Add a scoped assertion that the new plugin package contains no Mobbin references without applying that constraint to the existing `fb-ux` package.

## Task 2: Document both versions clearly

Update README, operating-layer documentation, prompt examples, and behavioral-validation evidence to explain:

- why two variants exist;
- when to choose each;
- copyable Codex install requests and advanced CLI installation for each;
- unique explicit invocations when both are installed;
- the platform/owner table and why every step matters;
- external authorization and implementation/release boundaries;
- cross-platform precedence for Android and web.

Keep the original `fb-ux` workflow documentation intact while adding the new variant.

## Task 3: Prove distribution behavior

Extend the real isolated-Codex installation smoke test so a fresh marketplace exposes both plugins, each can be installed, both display names are correct, and both embedded skills load under unique IDs. Preserve cleanup safety with whitespace `TMPDIR`. Run credential-negative, workflow-language, safety, plugin/skill validators, repository validation, and `git diff --check`.

## Completion and publication

Obtain an independent whole-branch review. After all tests pass, fast-forward local `main`, push public `main` without force, clone the public repository fresh, rerun the complete validation suite, verify the rendered README source and both plugin manifests, and report the public commit SHA.
