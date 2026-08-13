# Trust, limitations and sources

[Home](../README.md) · [Getting started](getting-started.md) · [Using Design Arc](using-design-arc.md) · [Evidence and methodology](evidence-and-methodology.md) · [Upgrades and migration](upgrades-and-migration.md) · [Trust and sources](trust-limitations-and-sources.md)

What can Design Arc prove, access, implement, or release?

## External evidence and visualization sources

Apple Human Interface Guidelines are first-party authority for Apple targets. For Android or web targets, current first-party platform rules override conflicting Apple-inspired judgment. Requirements are kept distinct from product-specific judgment.

Mobbin can be selected as a benchmark provider in Benchmarks mode. It remains an external source requiring separate access and authorization. Its examples are observed precedent, not a bundled integration or a source to copy. If access is unavailable, Design Arc stops and offers either a one-run Guidelines fallback or a confirmed saved switch; it never silently degrades or calls the result benchmark-backed.

Codex generates static journey boards by default. Google Stitch is an optional external visualization workspace requiring separate access and payload authorization. Either route must still return a reviewable journey map, key renders, identifiers, and validation verdict in the task. Apple, Google, Mobbin, and Stitch access is not bundled by Design Arc, and none of those services authorizes product-source changes.

Stitch prototypes are design evidence, not staging or device implementation proof. A prototype can communicate an intended interaction, but it cannot prove runtime quality.

## Relationship assistance boundary

Graph assistance is a project-local relationship record for correction planning, not a new source of truth. It records supported links among the current review's requirements, evidence, screens, states, and checks so Design Arc can plan more precise corrections.

It cannot prove a requirement, establish runtime quality, replace current evidence, or authorize a product decision. Current first-party requirements, accessibility requirements, and inspected evidence always take precedence over a conflicting, stale, inferred, or unsupported relationship.

A failed graph record reduces assistance rather than blocking the review: Design Arc reports the issue and continues the standard workflow. Rebuild uses current authoritative workflow facts for the current review only. Clear requires explicit confirmation for that review's exact record and never removes project preferences, homes, product files, or another review's record.

## Plugin discovery boundary

Design Arc is not listed in Codex’s built-in recommended-plugin directory. Codex CLI 0.146 introduced workspace plugin publishing, but this account exposes no `codex plugin publish` command and current official documentation provides no documented public third-party directory submission route. The GitHub marketplace commands in [Getting started](getting-started.md) are therefore the canonical public installation path. Do not claim that bare-name discovery, skills.sh, or an official marketplace listing is available. See the [official Codex 0.146 update](https://learn.chatgpt.com/docs/whats-new#organize-sessions-and-extend-codex-cli-01460).

## Evidence, implementation, and release boundaries

Design Arc must not claim current product inspection, first-party guidance, benchmark evidence, new generated output, exact render dimensions, accessibility, safe-area behavior, native/browser behavior, or physical-device compliance without corresponding current-task proof.

A validated visual journey remains a design proposal. No evidence mode, approval mode, external-service access, provider authorization, Direction decision, or visual verdict authorizes source implementation, staging, deployment, live release, destructive or provider changes, or work outside the authorized integration lane. Those actions require their own scope, owner, authorization, and evidence.

For the complete source library, see [Trusted sources](trusted-sources/README.md). For the technical operating boundary, see [Codex operating layer](codex-operating-layer.md).

## Trademarks

Apple, Google, Mobbin, and Stitch are trademarks of their respective owners. Design Arc is not affiliated with or endorsed by those owners, and no official integration is claimed.

Next: [Home](../README.md).
