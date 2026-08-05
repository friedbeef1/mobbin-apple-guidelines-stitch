# Task 1 Report: Canonical FB UX Plugin Package

## Outcome

Created the repository-local `fb-ux` Codex plugin package and marketplace entry. The canonical skill and its agent metadata now live under `plugins/fb-ux/skills/fb-ux/`; the old standalone skill files were removed. The package declares the requested plugin identity, repository, MIT license, author, Productivity category, `./skills/` path, and three concise starter prompts without apps, MCP servers, or hooks.

## TDD evidence

1. Updated `scripts/test-validate.sh` before creating package artifacts.
2. Ran `./scripts/test-validate.sh` while the package was absent. It correctly failed with: `FAIL: canonical plugin and marketplace layout is missing`, listing the absent plugin manifest, marketplace manifest, and embedded skill.
3. Created the package, moved/reconciled the newer canonical skill content, and repointed repository validation to the plugin layout.

## Verification

- External plugin validator — passed for `plugins/fb-ux`.
- Embedded-skill quick validator — passed for `plugins/fb-ux/skills/fb-ux`.
- `./scripts/validate.sh` — passed.
- `./scripts/test-validate.sh` — passed, including all credential-negative cases.
- `git diff --check` — passed.

## Scope and handoff

- Preserved the approved migration plan in `docs/superpowers/plans/2026-08-05-fb-ux-plugin-migration.md`.
- Task 1 package and validator files only; later documentation and installation-verification work remains unimplemented for Tasks 2 and 3.
