---
name: design-arc
description: Use when a mobile or web product journey feels confusing, incomplete, inconsistent, or subject to taste-based redesign debate, or when a team needs evidence-backed directions and complete material states before implementation.
user-invocable: true
---

## Google Antigravity entry point

Use `/design-arc` to begin a Design Arc journey review. This root extension
contains one self-contained skill and does not declare agents, hooks, MCP
servers, or external-service connectivity. External tools and services remain
separately authorized.

The same `/design-arc` workflow is supported in Google Antigravity standalone,
IDE, and CLI surfaces when that surface has loaded this extension. Do not claim
that another surface was exercised unless it was actually used. Keep normal
onboarding command-light: storage, graph controls, and technical commands are
secondary to the journey review.

## Google Antigravity project setup and re-entry

On new Google Antigravity setup, propose every missing preference and obtain explicit confirmation before creating `.gemini/design-arc.yaml`.

When `.gemini/design-arc.yaml` already exists, treat it as the Antigravity saved preference, do not offer a cross-runtime import, and never overwrite it from `.codex/design-arc.yaml` or `.claude/design-arc.yaml`.

Only when the Antigravity preference is absent, inspect
`.codex/design-arc.yaml` and `.claude/design-arc.yaml` read-only when they
exist. For each source independently, the portable fields are `evidence_mode`,
`benchmark_provider` when valid for Guidelines + Benchmarks, `approval_mode`,
and `graph_assistance`; validate the complete portable mapping before proposing
an import. Source-specific homes, reminders, active reviews, review artifacts,
graphs, task identities, and session context are not portable. Show the
proposed values and identify ignored source-specific fields without exposing
unrelated contents.

If both source preference files exist, show the separately validated portable proposals and require the user to choose exactly one source before asking for import approval; never merge them.
Only after explicit import approval, copy the validated portable values from the chosen source into a new Antigravity preference file; do not move or rename the source file.
Treat every Codex and Claude preference file, active-review record, review artifact, graph, home record, reminder, task identity, and session context as read-only; verify the chosen source remains byte-for-byte unchanged.
If the user declines import or declines to choose a source, leave all Codex and Claude state untouched and continue with a fresh Antigravity setup.
If either inspected source file is malformed or any portable value is invalid, import nothing from that source, report the invalid fields without exposing unrelated contents, and offer fresh Antigravity setup or the other separately valid source.

Never tell a Google Antigravity user to pass work to Codex or Claude Code unless the user explicitly requests a cross-platform handoff. A cross-platform handoff is an explicit user choice, not an import side effect: do not transfer, merge, alter, or resume source reviews, tasks, sessions, or runtime state.

### Safe Google Antigravity plugin upgrade

An upgrade or downgrade changes the Google Antigravity extension, not a
participating product and not the Codex or Claude Code adapters. Before changing
an installed extension, report the installed and requested versions, source,
and exact route; require confirmation unless the current request already
authorizes that exact change. Re-read installed state afterward instead of
trusting command success, and use only a supported Google Antigravity route.

Do not run project setup, edit `.gemini/design-arc.yaml`, touch product files,
or continue an active review during an adapter change. Compare the participating
Antigravity preferences, active-review records, review directories, and graphs
byte-for-byte before and after. If any changed, stop and report the exact
affected project; never rewrite project state automatically. An already-open
Google Antigravity session retains its pinned runtime and workflow version. Do
not force-close, convert, merge, or resume it as part of an upgrade or
downgrade; start a new clean session to load the changed adapter version.
