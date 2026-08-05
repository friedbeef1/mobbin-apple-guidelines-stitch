# FB UX Plugin Migration Plan

## Context

Convert the public `friedbeef1/mobbin-apple-guidelines-stitch` repository from a standalone `fb-ux` skill distribution into a repository marketplace containing an installable `fb-ux` Codex plugin. Preserve the newer local approval-mode workflow, platform/owner table, Codex operating-layer explanation, and all evidence and authorization gates.

## Global Constraints

- Plugin technical name: `fb-ux`; display name: `FB UX`; initial version: `0.1.0`.
- Canonical plugin root: `plugins/fb-ux/`; canonical skill root: `plugins/fb-ux/skills/fb-ux/`.
- Marketplace manifest: `.agents/plugins/marketplace.json`, pointing to `./plugins/fb-ux`, with installation `AVAILABLE`, authentication `ON_INSTALL`, and category `Productivity`.
- The plugin manifest must declare `skills: "./skills/"` and must not declare apps, MCP servers, hooks, or official Mobbin/Stitch integrations.
- Preserve the skill's Guided, Follow recommendation, and Fully automatic modes; objective rules; both design gates; evidence integrity rules; and implementation/deployment authorization boundaries.
- Mobbin and Stitch remain external, separately authorized services.
- Primary installation copy: `Install the FB UX Codex plugin from https://github.com/friedbeef1/mobbin-apple-guidelines-stitch`.
- Existing unrelated work must not be discarded. Reconcile the newer hydrated local README, skill, examples, validator, and Codex operating-layer draft before publication.
- Use tests first for validator behavior changes and keep all security-negative checks.

## Task 1: Create the canonical plugin package

Write or update validator assertions first so they fail because the plugin and marketplace layout do not exist. Then create `plugins/fb-ux/.codex-plugin/plugin.json`, `.agents/plugins/marketplace.json`, move the skill and agent metadata into `plugins/fb-ux/skills/fb-ux/`, and update repository validation paths. Reconcile the newer local skill content from the original checkout. Use plugin metadata with repository, MIT license, author `James Yeang`, Productivity category, and up to three concise journey-design starter prompts. Validate both manifest and embedded skill. Commit the task.

## Task 2: Rewrite distribution documentation

Reconcile the newer local README, examples, and Codex operating-layer draft. Rewrite installation so the copyable Codex request is primary; explain that Codex handles installation and may ask for download permission; move CLI/manual steps under an advanced fallback. Describe the package as a plugin containing the `fb-ux` skill, while clearly denying bundled or official Mobbin, Apple, Google, or Stitch integrations. Preserve the platform/owner table, project approval preferences, workflow purpose, gates, and authorization boundaries. Update internal paths and links for the plugin layout. Commit the task.

## Task 3: Add and run isolated installation verification

Add the minimum repository test or smoke script needed to verify from a fresh checkout that the marketplace identifies `FB UX`, points to the correct plugin, the plugin exposes `./skills/`, and the embedded skill loads as `fb-ux` with `$fb-ux` documentation. Run credential-negative, repository, plugin-manifest, skill, fresh-clone/install, and diff checks. Do not alter the user's real Codex marketplace or install state; use temporary isolated configuration. Commit the task.

## Publication

After task reviews and a final whole-branch review, push the tested commits to the existing GitHub repository's `main` branch and verify the public README and remote commit. No official marketplace submission is included.
