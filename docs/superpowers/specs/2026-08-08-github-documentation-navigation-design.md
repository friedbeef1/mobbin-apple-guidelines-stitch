# Design Arc GitHub Documentation Navigation

Date: 2026-08-08  
Status: proposed for user review

## Objective

Make the GitHub landing page quick to understand and install from, while keeping operational and trust detail easy to find. A first-time visitor should understand the pain Design Arc solves, see how little manual work it requires, and know how to install it without reading a 316-line README.

## Recommended information architecture

The README becomes an 80–110-line landing page. It keeps only:

1. The pain and desired outcome.
2. What Design Arc produces.
3. The approved vertical workflow table with platform ownership and human involvement.
4. One simple installation instruction.
5. One example starting prompt.
6. A documentation menu.
7. A short trust statement and licence link.

The installation instruction is exactly:

> **Ask Codex:** Install the Design Arc plugin from  
> https://github.com/friedbeef1/mobbin-apple-guidelines-stitch

The landing page does not show CLI commands, marketplace mechanics, Python references, migration commands, or troubleshooting detail.

## Documentation menu

Place this menu near the top of the README and repeat the same navigation links near the top of every new documentation page.

| Page | File | Purpose |
| --- | --- | --- |
| Getting started | `docs/getting-started.md` | Installation, first use, local-checkout fallback, and troubleshooting. |
| Using Design Arc | `docs/using-design-arc.md` | Project homes, returning later, approval modes, and natural-language use. |
| Evidence and methodology | `docs/evidence-and-methodology.md` | Benchmarks versus Guidelines, grounding, animation decisions, complete states, and validation. |
| Upgrades and migration | `docs/upgrades-and-migration.md` | Safe plugin upgrades, project preservation, legacy preferences, and rollback expectations. |
| Trust, limitations and sources | `docs/trust-limitations-and-sources.md` | External-service boundaries, implementation authority, limitations, trademarks, and links into the trusted-source library. |

The shared navigation is a compact relative-link line:

`[Home](../README.md) · [Getting started](getting-started.md) · [Using Design Arc](using-design-arc.md) · [Evidence and methodology](evidence-and-methodology.md) · [Upgrades and migration](upgrades-and-migration.md) · [Trust and sources](trust-limitations-and-sources.md)`

On the root README, use the equivalent links without `../`.

## Content ownership

Each topic has one canonical home. The README summarizes and links instead of duplicating full instructions.

- Move the existing installation commands and troubleshooting to **Getting started**. Keep the one-line Ask Codex instruction on both pages, with advanced commands only on the detailed page.
- Move project-home, returning-user, and approval-mode detail to **Using Design Arc**.
- Move the grounding table, evidence-mode explanation, methodology table, motion grounding, and render-validation explanation to **Evidence and methodology**.
- Move safe-upgrade behavior and saved-preference migration to **Upgrades and migration**.
- Move external-source status, discovery limitations, implementation/release boundaries, trademarks, and the trusted-source-library entry point to **Trust, limitations and sources**.
- Preserve `docs/trusted-sources/` as the deeper source library; the new trust page links to it instead of replacing it.
- Preserve `docs/codex-operating-layer.md` and `docs/validation/behavioral-validation.md` as technical reference and validation evidence. Link them from the relevant detailed pages rather than from the landing-page hero.

## Navigation behavior

- All links are repository-relative so they work on GitHub and in a fresh clone.
- Every detailed page begins with the shared menu and a one-sentence statement of what the page answers.
- Every detailed page ends with a clear next destination rather than a duplicate full menu.
- The README menu appears immediately after the product summary, before the longer workflow and installation content.
- Existing trusted-source external links and their allowlist remain unchanged.

## Trust and product boundaries

The restructuring changes presentation only. It does not change plugin behavior, evidence modes, approval modes, Objective Confirmation, Direction Gate, Stitch Gate, upgrade safeguards, project homes, external-service authorization, or implementation/release ownership.

Mobbin remains an optional benchmark provider used only in Benchmarks mode. Official platform guidance remains the source in Guidelines mode. Google Stitch remains an external visualization tool, not an evidence authority or bundled integration.

## Validation and acceptance

Documentation tests will enforce:

- the README is no more than 110 lines;
- the landing page contains the pain, outcome, workflow, one-line installation instruction, example prompt, trust statement, and five-page menu;
- the landing page contains no CLI command block or troubleshooting section;
- every menu target exists and includes the shared navigation;
- required moved content exists on its canonical page;
- repository-relative links resolve;
- the approved trusted-source external URL set is unchanged;
- the existing workflow table, evidence/approval behavior, safety boundaries, plugin/skill validation, installation, migration, and upgrade tests continue to pass.

After implementation, verify the rendered GitHub README and each menu destination from a fresh public clone before declaring the reorganization complete.
