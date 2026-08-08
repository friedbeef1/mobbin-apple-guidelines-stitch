#!/usr/bin/env python3
"""Mutation tests for the Design Arc instruction-contract checker.

These tests prove that the deterministic checker rejects missing or reversed
workflow clauses. They do not simulate an agent; scenario evidence covers that
separate question.
"""

from __future__ import annotations

import subprocess
import sys
import tempfile
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parent.parent
CHECKER = REPO_ROOT / "scripts/check-workflow-contracts.py"
SKILL = REPO_ROOT / "plugins/design-arc/skills/design-arc/SKILL.md"


MUTATIONS = {
    "setup before inspection": (
        "Resolve setup before product inspection, external research, or generation. Then establish the user's objective before any of those activities.",
        "Inspect the product before resolving setup, then infer the objective.",
    ),
    "setup command": ("`$design-arc setup`", "`$design-arc configure`"),
    "home command": ("`$design-arc home`", "`$design-arc dashboard`"),
    "upgrade command": ("`$design-arc upgrade`", "`$design-arc reinstall-every-project`"),
    "benchmark command": (
        "`$design-arc evidence benchmarks`",
        "`$design-arc evidence examples`",
    ),
    "guidelines command": (
        "`$design-arc evidence guidelines`",
        "`$design-arc evidence standards`",
    ),
    "mode report command": ("`$design-arc mode`", "`$design-arc status`"),
    "guided command": (
        "`$design-arc mode guided`",
        "`$design-arc mode manual`",
    ),
    "follow command": (
        "`$design-arc mode follow-recommendation`",
        "`$design-arc mode recommended`",
    ),
    "automatic command": (
        "`$design-arc mode fully-automatic`",
        "`$design-arc mode automatic`",
    ),
    "override precedence": (
        "1. Explicit one-run override in the current request; do not save it unless asked.",
        "1. Saved preference; ignore a current-request override.",
    ),
    "saved preference precedence": (
        "2. Saved `.codex/design-arc.yaml` value.",
        "2. A global default outside the project.",
    ),
    "confirmed import precedence": (
        "3. Confirmed legacy import, only when the new file is absent.",
        "3. Silent legacy import, even when the new file exists.",
    ),
    "first-use precedence": (
        "4. First-use selection for every choice still missing.",
        "4. Infer every choice still missing.",
    ),
    "mode provenance": (
        "Always report the active evidence mode and approval mode, and the provenance of each independently.",
        "Report the active modes without their provenance.",
    ),
    "benchmarks guided combination": (
        "| Benchmarks | Guided | Direction Gate stops; Stitch Gate stops |",
        "| Benchmarks | Guided | Both gates continue |",
    ),
    "benchmarks follow combination": (
        "| Benchmarks | Follow recommendation | Direction Gate continues with the marked recommendation; Stitch Gate stops |",
        "| Benchmarks | Follow recommendation | Both gates continue |",
    ),
    "benchmarks automatic combination": (
        "| Benchmarks | Fully automatic | Direction Gate continues; Stitch Gate continues only on `meets direction` |",
        "| Benchmarks | Fully automatic | Stitch Gate continues on any verdict |",
    ),
    "guidelines guided combination": (
        "| Guidelines | Guided | Direction Gate stops; Stitch Gate stops |",
        "| Guidelines | Guided | Both gates continue |",
    ),
    "guidelines follow combination": (
        "| Guidelines | Follow recommendation | Direction Gate continues with the marked recommendation; Stitch Gate stops |",
        "| Guidelines | Follow recommendation | Both gates continue |",
    ),
    "guidelines automatic combination": (
        "| Guidelines | Fully automatic | Direction Gate continues; Stitch Gate continues only on `meets direction` |",
        "| Guidelines | Fully automatic | Stitch Gate continues on any verdict |",
    ),
    "benchmark journey quality": (
        "Inspect complete, relevant real-product journeys and explain why each selected pattern is useful for the established objective.",
        "Treat a library listing as sufficient benchmark proof.",
    ),
    "benchmark quality exclusions": (
        "Library presence, metadata, popularity, or one screenshot never proves best-in-class quality.",
        "Popularity or one screenshot proves best-in-class quality.",
    ),
    "guidelines no benchmark lookup": (
        "In Guidelines mode, perform no benchmark lookup and make no benchmark-evidence claim.",
        "In Guidelines mode, quietly use benchmark evidence when convenient.",
    ),
    "missing access stop": (
        "If benchmark access is missing, stop; never degrade silently.",
        "If benchmark access is missing, silently continue with guidelines.",
    ),
    "one-run fallback": (
        "Offer either a one-run Guidelines fallback that does not rewrite the saved preference, or a confirmed saved switch to Guidelines.",
        "Switch the saved preference to Guidelines without asking.",
    ),
    "fb ux import": (
        "`.codex/fb-ux.yaml` maps to `evidence_mode: benchmarks`, `benchmark_provider: mobbin`, and its preserved approval mode.",
        "`.codex/fb-ux.yaml` maps to Guidelines and drops its approval mode.",
    ),
    "apple skill import": (
        "`.codex/apple-guidelines-stitch.yaml` maps to `evidence_mode: guidelines`, omits `benchmark_provider`, and preserves its approval mode.",
        "`.codex/apple-guidelines-stitch.yaml` maps to Benchmarks and adds a provider.",
    ),
    "confirm import": (
        "Show the proposed mapping and ask once before importing it.",
        "Import the mapping without showing or confirming it.",
    ),
    "dual legacy conflict": (
        "If both legacy files exist, present both mappings and require the user to choose one or start fresh.",
        "If both legacy files exist, merge them automatically.",
    ),
    "legacy preservation": (
        "Never silently merge, rewrite, or delete either legacy preference file.",
        "Merge and delete legacy preference files after import.",
    ),
    "guided objective confirmation": (
        "In Guided or Follow recommendation mode, restate a stated objective and ask the user to confirm or revise it.",
        "In Guided or Follow recommendation mode, infer and accept the objective.",
    ),
    "automatic explicit objective": (
        "Fully automatic may skip the objective pause only when the current request states an explicit objective.",
        "Fully automatic may invent a missing objective.",
    ),
    "missing objective stop": (
        "If the objective is missing or materially ambiguous, stop and ask; never invent it.",
        "If the objective is missing or materially ambiguous, infer it and continue.",
    ),
    "direction recommendation": (
        "At the Direction Gate, present one unmistakably marked recommendation plus meaningful alternatives and their trade-offs.",
        "At the Direction Gate, present only one direction without trade-offs.",
    ),
    "automatic stitch verdict": (
        "Fully automatic continues only when the Stitch verdict is `meets direction`; `meets with corrections` and `does not meet` both stop.",
        "Fully automatic continues when the Stitch verdict is `meets with corrections`.",
    ),
    "platform precedence": (
        "For Android or web targets, current first-party platform rules override conflicting Apple-inspired judgment.",
        "For Android or web targets, Apple-inspired judgment overrides first-party rules.",
    ),
    "source evidence integrity": (
        "Do not claim product inspection, first-party guidance, benchmark evidence, or new Stitch output without current evidence for that exact claim.",
        "Claim inspection and evidence based on prior metadata.",
    ),
    "motion case 01 evidence precedence": (
        "Use this motion-evidence precedence: existing product motion; native platform behavior and standard components; current first-party platform guidance; inspected relevant shipped-product motion; labeled Design Arc judgment.",
        "Use labeled Design Arc judgment before checking product, platform, or shipped-product motion.",
    ),
    "motion case 02 benchmark and static limits": (
        "Static screens or sequences support only start/end state, changing element, journey location, and transition intent; they cannot support exact duration, easing, springs, velocity, interruption, or choreography.",
        "Static screens support exact duration, easing, springs, velocity, interruption, and choreography.",
    ),
    "motion case 02 benchmark authorization": (
        "In Benchmarks mode, authorized shipped-product motion may be inspected as precedent.",
        "In Benchmarks mode, inspect shipped-product motion without authorization.",
    ),
    "motion case 03 playable evidence record": (
        "For playable motion evidence, record source; product/journey; frame rate when known; observed duration/path/order; interruption/reversal; measurement method; confidence; and missing states. Frame-derived values are estimates.",
        "For playable motion evidence, record only the source and copy frame-derived values as exact.",
    ),
    "motion case 04 temporal claim labels": (
        "Every temporal claim uses exactly one label: `directly observed`, `measured estimate`, `pattern-level inference`, `Design Arc judgment`, or `unverified`.",
        "Temporal claims need no evidence label.",
    ),
    "motion case 05 unavailable playable evidence": (
        "When necessary playable evidence is unavailable, report the limitation and offer an accessible live product, user recording, authorized Page Flows recording, native default, or labeled proposal requiring implementation validation. Never invent it.",
        "When playable evidence is unavailable, invent a plausible animation from a static screen.",
    ),
    "motion case 06 Guidelines isolation": (
        "In Guidelines mode, perform no benchmark lookup, make no real-product motion claim, and report that no benchmark motion was inspected.",
        "In Guidelines mode, imply real-product motion was inspected without a benchmark lookup.",
    ),
    "motion case 07 complete contract fields": (
        "Every material motion contract includes: Motion ID; journey location; purpose; trigger; start/end state; spatial behavior; choreography; timing; easing/spring; interruption; reduced motion; evidence; provenance; implementation target; implementation source; proof status. Unsupported values are `unverified`.",
        "Every material motion contract includes only Motion ID, purpose, and timing; omit unsupported fields.",
    ),
    "motion case 07 target semantics": (
        "`implementation target` records the runtime and UI technology, such as Web, React, SwiftUI, UIKit, or Compose; record component and state-change specificity separately when useful.",
        "`implementation target` records only a vague screen or component name and omits the runtime and UI technology.",
    ),
    "motion case 07 timing semantics": (
        "`timing` uses milliseconds or seconds for duration and delay, or records that a physical spring with explicit parameters governs timing.",
        "`timing` uses subjective values such as fast or smooth without units or spring parameters.",
    ),
    "motion case 07 easing semantics": (
        "`easing/spring` records cubic-bezier coordinates, a named platform curve, or physical spring parameters such as mass, stiffness, damping, and initial velocity.",
        "`easing/spring` records only a vague adjective and no reproducible curve or spring parameters.",
    ),
    "motion case 07 interruption semantics": (
        "`interruption` records whether motion can be interrupted or reversed, how cancellation resolves, and what happens on re-entry.",
        "`interruption` records only yes or no and omits reversal, cancellation, and re-entry behavior.",
    ),
    "motion case 07 provenance semantics": (
        "`provenance` uses exactly one of `directly observed`, `measured estimate`, `pattern-level inference`, `Design Arc judgment`, or `unverified` for each claim, cites the supporting source, and records the measurement or estimate basis when applicable.",
        "`provenance` accepts unlabeled claims without citations or an estimate basis.",
    ),
    "motion case 07 source authorization semantics": (
        "`implementation source` names the existing product token, native or standard component, separately approved library, or custom implementation and records the authorizing owner; a proposal alone does not authorize it.",
        "`implementation source` lists an unapproved library and treats the proposal as installation authorization.",
    ),
    "motion case 07 proof-status semantics": (
        "`proof status` distinguishes `specified`, `prototyped`, `staging verified`, `device verified`, and `production verified` as applicable; use only the highest status established by current evidence.",
        "`proof status` uses complete for every design and promotes it without runtime evidence.",
    ),
    "motion case 08 Design Arc dependency boundary": (
        "Motion+ is never required by or evidence for Design Arc, and it is never a Design Arc dependency.",
        "Motion+ is required evidence for Design Arc and a Design Arc dependency.",
    ),
    "motion case 08 implementation owner boundary": (
        "An authorized implementation owner may separately approve Motion+ as an optional implementation dependency and implementation source; that approval does not install it or make it Design Arc evidence or authority.",
        "Design Arc automatically installs Motion+ as a required implementation dependency and treats it as motion evidence.",
    ),
    "motion case 08 authorized assistance scope": (
        "After separate authorization from the implementation owner, Motion+ assistance may cover documentation and example search; reusable source retrieval; spring and easing assistance; saved-transition inspection; performance auditing; and design-system adaptation.",
        "Motion+ may autonomously install itself and redesign the product without implementation-owner authorization.",
    ),
    "motion case 09 direction summary": (
        "At the Direction Gate, include a motion summary that identifies the material motion scope, retained native or existing behavior, proposed custom behavior, and unresolved evidence.",
        "At the Direction Gate, omit the motion scope and unresolved evidence.",
    ),
    "motion case 09 least-motion principle": (
        "Apply the least-motion principle: use no more motion than the stated interaction purpose requires, and remove decorative motion without a justified purpose.",
        "Add decorative motion even when it serves no interaction purpose.",
    ),
    "motion case 09 direction purpose semantics": (
        "For each direction, explain the motion's concrete interaction purpose and why it uses no more motion than that purpose requires.",
        "For each direction, list a motion-purpose heading without explaining the interaction purpose or restraint.",
    ),
    "motion case 09 direction evidence semantics": (
        "For each direction, cite relevant inspected real-product evidence and current platform guidance, or state that either is unavailable.",
        "For each direction, claim evidence and guidance support without citations or availability status.",
    ),
    "motion case 09 direction provenance semantics": (
        "For each direction, apply the required provenance label to every temporal claim and distinguish directly observed behavior from measured estimates.",
        "For each direction, combine observations and estimates under an unlabeled evidence heading.",
    ),
    "motion case 09 direction accessibility and delivery semantics": (
        "For each direction, describe reduced-motion implications, motion-specific risks, and implementation complexity in the target stack.",
        "For each direction, omit reduced-motion implications, motion-specific risks, and target-stack complexity.",
    ),
    "motion case 09 direction proof semantics": (
        "For each direction, identify what remains unproven and the staging, device, or production evidence needed to prove it.",
        "For each direction, claim completion without identifying remaining proof.",
    ),
    "motion case 09 headings are insufficient": (
        "Headings or field names without these direction-specific explanations do not satisfy the Direction Gate.",
        "Direction Gate is satisfied by empty headings or field names alone.",
    ),
    "motion case 10 prototype proof boundary": (
        "Stitch and other design prototypes can illustrate states and transition intent but cannot prove timing, easing, springs, interruption, reduced-motion behavior, performance, or runtime implementation quality.",
        "Treat a Stitch prototype as proof of timing, reduced-motion behavior, performance, and runtime implementation quality.",
    ),
    "motion case 10 staging and device proof": (
        "Only measured staging or target-device behavior can establish implementation proof.",
        "A static design specification establishes implementation proof without staging or device measurement.",
    ),
    "motion case 10 implementation authority": (
        "Design Arc may specify and critique motion, but it does not authorize application-code implementation, dependency installation, staging, deployment, or release.",
        "A Design Arc motion contract authorizes implementation, dependency installation, staging, deployment, and release.",
    ),
    "motion case 10 verdict evaluation": (
        "Before assigning a Stitch verdict, explicitly evaluate motion purpose and least-motion restraint, provenance labels and citations, reduced-motion behavior, alignment with every material motion contract, prototype limitations, and remaining runtime proof.",
        "Assign the Stitch verdict from visual polish without evaluating motion provenance, reduced motion, contract alignment, or remaining proof.",
    ),
    "motion case 10 meets-direction semantics": (
        "A `meets direction` verdict is valid only when the prototype aligns with those motion requirements within its capabilities and every limitation and remaining runtime proof item is documented; any unexplained gap yields `meets with corrections` or `does not meet`.",
        "Use `meets direction` despite unexplained motion gaps and undocumented runtime proof.",
    ),
    "motion case 10 automatic evaluation gate": (
        "Fully automatic may continue on `meets direction` only after this motion evaluation is recorded; it cannot waive a missing or contradictory motion check.",
        "Fully automatic may continue without recording the motion evaluation and may waive contradictory checks.",
    ),
    "motion case 11 run record": (
        "Relevant run records include motion scope, evidence, provenance, contracts, reduced motion, implementation source, proof, and remaining uncertainty.",
        "Relevant run records omit provenance, implementation source, proof, and uncertainty.",
    ),
    "motion case 12 automatic integrity": (
        "Fully automatic mode never bypasses motion evidence integrity.",
        "Fully automatic mode may bypass motion evidence integrity.",
    ),
    "implementation boundary": (
        "Design approval never authorizes source implementation, staging, live deployment, release, destructive changes, provider changes, or work outside the authorized integration lane.",
        "Design approval authorizes implementation and live deployment.",
    ),
    "saved project resolution": (
        "Call `list_projects` before any home lookup or creation and resolve the current saved project's `projectId` and saved-project name; use the workspace-folder name only when the saved-project name is unavailable.",
        "Infer a project from the task title without calling `list_projects`.",
    ),
    "canonical project title": (
        "The canonical title is `Design Arc — <Project Name>`.",
        "The canonical title is `Design Arc Home`.",
    ),
    "home setup confirmation": (
        "Home creation must be part of the setup proposal and must be explicitly confirmed before `create_thread` is called.",
        "Create the home before asking the user to confirm setup.",
    ),
    "standing launch authorization": (
        "That confirmed project-home setup is standing authorization for this home to launch later journey starters as clean tasks in the same saved project.",
        "Every starter requires an unrelated second authorization to create a clean task.",
    ),
    "no projectless home": (
        "Never create a `projectless` Design Arc home or reuse a home whose project identity differs, even when its title matches.",
        "Create one global `projectless` Design Arc home and reuse it across projects.",
    ),
    "unconfirmed project isolation": (
        "A project without confirmed Design Arc setup gets no home and no sidebar item.",
        "Add a sidebar home for every saved project.",
    ),
    "title and project deduplication": (
        "Call `list_threads` with `limit: 50`; inspect both `pinnedThreads` and `threads`, and match a home by both the exact canonical title and the resolved `projectId`.",
        "Reuse the first title match without checking its project identity.",
    ),
    "duplicate preservation": (
        "If multiple same-project matches exist, select the most recent canonical match for adoption, report every other matching thread for user cleanup, and never delete, archive, merge, silently rename, or reuse those duplicates.",
        "Use and pin the first duplicate directly as ready, then archive the others.",
    ),
    "local project target": (
        '`target: { type: "project", projectId: <resolved projectId>, environment: { type: "local" } }`',
        '`target: { type: "projectless" }`',
    ),
    "pending thread id safety": (
        "Never pass a returned `clientThreadId` to thread tools that require a `threadId`.",
        "Pass `clientThreadId` to every thread tool while setup is pending.",
    ),
    "home card content": (
        "The home card displays the project identity, Design Arc installed status, active and saved evidence and approval preferences with provenance, plain-language journey starters, and preference controls.",
        "The home card displays only a command reference.",
    ),
    "launchpad only": (
        "The home is only a launchpad; it never performs the journey audit, research, direction work, or visualization in the home task.",
        "Perform the complete Design Arc journey inside the pinned home.",
    ),
    "clean same-project launch": (
        "When the user submits a journey starter inside a confirmed home, call `create_thread` for a clean task with the same resolved `projectId`, `environment: { type: \"local\" }`, and a prompt containing the user's starter plus the active Design Arc settings and project identity.",
        "Continue in the home without creating a clean same-project task.",
    ),
    "no worktree launch": (
        "Do not launch a worktree, continue the journey inside the home, specify a model, or invent another project.",
        "Launch every journey in a new worktree with a guessed project.",
    ),
    "natural language activation": (
        "Outside a Design Arc home, an ordinary product-journey request activates Design Arc in the current task; briefly disclose that Design Arc is being used and continue without requiring `$design-arc`.",
        "Require `$design-arc` before responding to any journey request.",
    ),
    "unavailable tool fallback": (
        "If task discovery, creation, title, or pin tools are unavailable or fail, complete confirmed preference setup, do not claim a home or launch succeeded, and return the exact canonical home title plus the full starter card and manual create-and-pin steps.",
        "If task tools fail, claim the home is ready and omit re-entry instructions.",
    ),
    "natural language upgrade": (
        "A request such as “upgrade Design Arc” activates this same safe upgrade flow without requiring the command.",
        "Require the user to remember `$design-arc upgrade` before helping.",
    ),
    "upgrade confirmation": (
        "Before changing the Codex plugin profile, report the installed and available Design Arc versions, the marketplace source, and the exact planned upgrade route; require confirmation unless the current request already explicitly authorizes that exact upgrade.",
        "Upgrade the plugin profile immediately without reporting scope or checking authorization.",
    ),
    "immutable upgrade rollback": (
        "Before any remove/add fallback, capture and verify an immutable restoration artifact: an exact commit or immutable ref, or a verified local package backup; a marketplace source plus version label alone is insufficient.",
        "Record only the moving marketplace branch and version label before removing the working plugin.",
    ),
    "upgrade project isolation": (
        "A plugin upgrade is laptop/profile-scoped and must not run project setup, create or replace a project home, change title or pin state, rewrite `.codex/design-arc.yaml`, touch product files, or continue an active review.",
        "Re-run setup and recreate every project home after upgrading the plugin.",
    ),
    "upgrade result integrity": (
        "After the upgrade, verify exactly one enabled `design-arc@design-arc-marketplace`, report its version, and report `project homes recreated: 0` and `project preferences changed: 0` only when current evidence supports both claims.",
        "Assume the upgrade succeeded and report that every project was preserved without verification.",
    ),
    "open task upgrade boundary": (
        "An already-open task may retain older task context; keep its project home unchanged and tell the user to start the next review from that existing home so a clean task loads the upgraded plugin.",
        "Replace the project home and continue the active review with mixed old and new context.",
    ),
    "home metadata isolation": (
        "Store home metadata under `design_arc_home` in the current project's `.codex/design-arc.yaml`; it is project-scoped state, not a global preference.",
        "Store home metadata in a global Codex preference.",
    ),
    "preference preservation": (
        "Every home-state write must preserve `evidence_mode`, `benchmark_provider` when present, and `approval_mode` unchanged.",
        "Rewrite evidence and approval values whenever home state changes.",
    ),
    "pending duplicate guard": (
        "A `pending` or `ready` `design_arc_home` record blocks every new automatic home `create_thread` call.",
        "A pending record permits another automatic home create_thread call.",
    ),
    "pending record preservation": (
        "Never silently clear or replace a pending or ready record.",
        "Silently replace a pending record when recovery takes too long.",
    ),
    "queued recovery marker": (
        "Store a deterministic recovery marker in metadata and in the home task's initial prompt.",
        "Do not persist any way to recognize a queued home later.",
    ),
    "queued recovery timestamp": (
        "Store `pending_since` as an ISO-8601 UTC timestamp before task creation so later recovery can bound candidate age.",
        "Guess when the pending task was created from current recency order.",
    ),
    "queued id persistence": (
        "When only `clientThreadId` is returned, keep `state: pending`, store `client_thread_id`, and do not pass it to a thread-ID tool.",
        "When only clientThreadId is returned, discard it and retry automatically.",
    ),
    "exact queued recovery": (
        "If exactly one same-project task contains the recorded recovery marker, store its `threadId` and resume the pending transition; otherwise keep the guard and report the unresolved pending state.",
        "Use the first recent task from any project as the queued home.",
    ),
    "confirmed abandonment": (
        "Only explicit user confirmation may abandon a pending or stale ready record and authorize a retry.",
        "Automatically abandon pending state and retry after a timeout.",
    ),
    "rediscover after abandonment": (
        "After confirmed abandonment, re-run title, project, and recovery-marker discovery before any replacement creation.",
        "Create a replacement immediately after clearing the record.",
    ),
    "explicit home transitions": (
        "The only automatic home-state transitions are `absent → pending`, `pending → pending + client_thread_id|thread_id`, and `pending + thread_id → ready + thread_id`.",
        "Home state may jump directly from absent to ready.",
    ),
    "manual fallback pending": (
        "Manual fallback remains `pending` until the exact title and project identity are verified.",
        "Manual fallback is ready as soon as instructions are printed.",
    ),
    "existing match is adoption candidate": (
        "An existing exact title-and-project match is an adoption candidate, not a ready home.",
        "An existing exact title-and-project match is already a ready home.",
    ),
    "adoption enters pending": (
        "After confirmation, write `state: pending` with the candidate's `thread_id` while preserving the evidence and approval values, then enter the common readiness sequence.",
        "Adopt the candidate directly as ready without writing pending metadata.",
    ),
    "common readiness for adopted tasks": (
        "New, recovered, and adopted tasks all use the same title-once, pin-once, re-list verification sequence before any `ready` write.",
        "Adopted tasks use a shorter path that omits pin and verification.",
    ),
    "stored thread exact project recovery": (
        "For a pending record with `thread_id`, first resolve that exact stored ID with `list_threads` and `read_thread` and require the exact saved `project_id`; then choose recovery proof from the record's creation path.",
        "Recover a pending thread from the first recent task without checking the stored ID or project identity.",
    ),
    "adopted stored thread needs no marker": (
        "For an adopted pending task, the exact canonical title is the recovery proof; do not require the recovery marker because the task may predate Design Arc.",
        "For an adopted pending task, require both the exact canonical title and the recovery marker.",
    ),
    "created stored thread marker recovery": (
        "For a newly created pending task whose ready result supplied and stored `thread_id`, the exact recorded recovery marker in its initial prompt is the recovery proof, so the canonical title need not exist yet.",
        "For a newly created pending task with a stored thread_id, require the canonical title before recovery.",
    ),
    "stale stored proof remains pending": (
        "If the exact stored ID does not resolve, the project identity mismatches, or neither allowed recovery proof matches, keep `state: pending`, report the stale or mismatched identity, and require explicit abandonment; never create a replacement automatically.",
        "If the stored ID, project identity, or recovery proof mismatches, clear pending and create a replacement automatically.",
    ),
    "queued marker recovery scope": (
        "Use `pending_since` plus recovery-marker candidate scanning only when a pending record has no `thread_id`.",
        "Use recovery-marker scanning instead of stored thread_id identity for every pending record.",
    ),
    "single ready sequence": (
        "Call `set_thread_title` once, then call `set_thread_pinned` once, then call `list_threads` again and verify the canonical title, resolved project identity, and pinned state.",
        "Repeatedly mutate title and pin before and after verification.",
    ),
    "ready only after verification": (
        "Only after that verification, write `state: ready` with the verified `thread_id`.",
        "Write state: ready before title and pin verification.",
    ),
    "no mutation after verification": (
        "Do not mutate title or pin after verification.",
        "After verification, call set_thread_title again.",
    ),
}


CONTRADICTION_MUTATIONS = {
    "conflicting pending bypass": (
        "Never silently clear or replace a pending or ready record.",
        " Agents may ignore a pending record and create another home automatically.",
    ),
    "conflicting silent clear": (
        "Never silently clear or replace a pending or ready record.",
        " Without explicit confirmation, remove the pending home record.",
    ),
    "conflicting ready-before-verify": (
        "Only after that verification, write `state: ready` with the verified `thread_id`.",
        " Mark state: ready before verification.",
    ),
    "conflicting post-verify mutation": (
        "Do not mutate title or pin after verification.",
        " After verification, call `set_thread_pinned` again.",
    ),
    "duplicate title mutation before verification": (
        "Call `set_thread_title` once, then call `set_thread_pinned` once, then call `list_threads` again and verify the canonical title, resolved project identity, and pinned state.",
        " Before verification, call `set_thread_title` again.",
    ),
    "duplicate pin mutation before verification": (
        "Call `set_thread_title` once, then call `set_thread_pinned` once, then call `list_threads` again and verify the canonical title, resolved project identity, and pinned state.",
        " Before verification, call `set_thread_pinned` again.",
    ),
    "conflicting direct ready adoption": (
        "An existing exact title-and-project match is an adoption candidate, not a ready home.",
        " Reuse the candidate by writing state: ready immediately.",
    ),
    "conflicting adopted pending bypass": (
        "An existing exact title-and-project match is an adoption candidate, not a ready home.",
        " Adopted tasks skip pending metadata.",
    ),
    "conflicting adopted pin bypass": (
        "An existing exact title-and-project match is an adoption candidate, not a ready home.",
        " Adopted tasks bypass pin verification.",
    ),
    "conflicting adopted re-list bypass": (
        "An existing exact title-and-project match is an adoption candidate, not a ready home.",
        " Adoption may skip list_threads verification.",
    ),
    "conflicting absent-ready transition": (
        "The only automatic home-state transitions are `absent → pending`, `pending → pending + client_thread_id|thread_id`, and `pending + thread_id → ready + thread_id`.",
        " The adoption path may transition absent → ready.",
    ),
    "conflicting adopted marker requirement": (
        "For an adopted pending task, the exact canonical title is the recovery proof; do not require the recovery marker because the task may predate Design Arc.",
        " An adopted pending task must require the recovery marker.",
    ),
    "conflicting created title requirement": (
        "For a newly created pending task whose ready result supplied and stored `thread_id`, the exact recorded recovery marker in its initial prompt is the recovery proof, so the canonical title need not exist yet.",
        " A newly created pending task must have the canonical title before recovery.",
    ),
    "conflicting created marker bypass": (
        "For a newly created pending task whose ready result supplied and stored `thread_id`, the exact recorded recovery marker in its initial prompt is the recovery proof, so the canonical title need not exist yet.",
        " A newly created pending task may recover without the recovery marker.",
    ),
    "conflicting stale thread replacement": (
        "If the exact stored ID does not resolve, the project identity mismatches, or neither allowed recovery proof matches, keep `state: pending`, report the stale or mismatched identity, and require explicit abandonment; never create a replacement automatically.",
        " If a stored `thread_id` is missing, the agent may create a replacement automatically.",
    ),
}


ORDERED_MUTATION_MARKERS = (
    "Write `state: pending` before calling `create_thread`.",
    "Call `create_thread` once.",
)

ADOPTION_ORDERED_MUTATION_MARKERS = (
    "After confirmation, write `state: pending` with the candidate's `thread_id` while preserving the evidence and approval values, then enter the common readiness sequence.",
    "For a new, adopted, or exactly recovered task that still needs readiness, perform one mutation sequence after confirmation.",
)

STORED_RECOVERY_ORDERED_MUTATION_MARKERS = (
    "For a newly created pending task whose ready result supplied and stored `thread_id`, the exact recorded recovery marker in its initial prompt is the recovery proof, so the canonical title need not exist yet.",
    "For a new, adopted, or exactly recovered task that still needs readiness, perform one mutation sequence after confirmation.",
)


def run_checker(skill: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(CHECKER), "--skill", str(skill)],
        capture_output=True,
        text=True,
        check=False,
    )


def mutate_once(original: str, old: str, new: str, label: str) -> str:
    count = original.count(old)
    if count != 1:
        raise AssertionError(
            f"mutation fixture for {label!r} must match once, found {count}"
        )
    return original.replace(old, new, 1)


def swap_once(original: str, first: str, second: str) -> str:
    if original.count(first) != 1 or original.count(second) != 1:
        raise AssertionError("ordered mutation markers must each match once")
    placeholder = "__DESIGN_ARC_ORDER_MUTATION__"
    return original.replace(first, placeholder).replace(second, first).replace(
        placeholder, second
    )


def main() -> int:
    original = SKILL.read_text(encoding="utf-8")
    baseline = run_checker(SKILL)
    if baseline.returncode != 0:
        sys.stderr.write(baseline.stdout + baseline.stderr)
        raise AssertionError("current Design Arc instruction contracts must pass")
    print("PASS: current deterministic Design Arc instruction contracts")

    with tempfile.TemporaryDirectory(prefix="design-arc-contract-mutations.") as name:
        mutated_skill = Path(name) / "SKILL.md"
        for label, (old, new) in MUTATIONS.items():
            mutated_skill.write_text(
                mutate_once(original, old, new, label), encoding="utf-8"
            )
            result = run_checker(mutated_skill)
            if result.returncode == 0:
                raise AssertionError(
                    f"checker accepted reversed or missing contract: {label}"
                )
            print(f"PASS: rejected mutation: {label}")

        home_fragment = (
            "A `pending` or `ready` `design_arc_home` record blocks every new "
            "automatic home `create_thread` call."
        )
        mutated_skill.write_text(
            original.replace(home_fragment, "", 1) + "\n" + home_fragment + "\n",
            encoding="utf-8",
        )
        if run_checker(mutated_skill).returncode == 0:
            raise AssertionError("checker accepted Project home contract outside section")
        print("PASS: rejected mutation: home contract moved outside section")

        mutated_skill.write_text(
            swap_once(original, *ORDERED_MUTATION_MARKERS), encoding="utf-8"
        )
        if run_checker(mutated_skill).returncode == 0:
            raise AssertionError("checker accepted reversed pending/create order")
        print("PASS: rejected mutation: reversed pending/create order")

        mutated_skill.write_text(
            swap_once(original, *ADOPTION_ORDERED_MUTATION_MARKERS), encoding="utf-8"
        )
        if run_checker(mutated_skill).returncode == 0:
            raise AssertionError("checker accepted adoption readiness before pending")
        print("PASS: rejected mutation: adoption readiness before pending")

        mutated_skill.write_text(
            swap_once(original, *STORED_RECOVERY_ORDERED_MUTATION_MARKERS),
            encoding="utf-8",
        )
        if run_checker(mutated_skill).returncode == 0:
            raise AssertionError("checker accepted readiness before stored-ID recovery")
        print("PASS: rejected mutation: readiness before stored-ID recovery")

        for label, (anchor, contradiction) in CONTRADICTION_MUTATIONS.items():
            mutated_skill.write_text(
                mutate_once(original, anchor, anchor + contradiction, label),
                encoding="utf-8",
            )
            if run_checker(mutated_skill).returncode == 0:
                raise AssertionError(
                    f"checker accepted contradictory contract: {label}"
                )
            print(f"PASS: rejected mutation: {label}")

    mutation_count = len(MUTATIONS) + len(CONTRADICTION_MUTATIONS) + 4
    print(f"PASS: rejected {mutation_count} deterministic contract mutations")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
