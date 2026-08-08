#!/usr/bin/env python3
"""Check deterministic contracts encoded by the Design Arc skill.

This validator checks the written instruction contract. It does not execute or
simulate an agent; fresh-context scenarios provide separate behavioral evidence.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_SKILL = REPO_ROOT / "plugins/design-arc/skills/design-arc/SKILL.md"


REQUIRED_CONTRACTS = {
    "setup and objective ordering": (
        "Resolve setup before product inspection, external research, or generation. Then establish the user's objective before any of those activities.",
    ),
    "setup and mode commands": (
        "`$design-arc setup`",
        "`$design-arc home`",
        "`$design-arc evidence benchmarks`",
        "`$design-arc evidence guidelines`",
        "`$design-arc mode`",
        "`$design-arc mode guided`",
        "`$design-arc mode follow-recommendation`",
        "`$design-arc mode fully-automatic`",
    ),
    "preference precedence": (
        "1. Explicit one-run override in the current request; do not save it unless asked.",
        "2. Saved `.codex/design-arc.yaml` value.",
        "3. Confirmed legacy import, only when the new file is absent.",
        "4. First-use selection for every choice still missing.",
    ),
    "independent provenance": (
        "Always report the active evidence mode and approval mode, and the provenance of each independently.",
    ),
    "six mode combinations": (
        "| Benchmarks | Guided | Direction Gate stops; Stitch Gate stops |",
        "| Benchmarks | Follow recommendation | Direction Gate continues with the marked recommendation; Stitch Gate stops |",
        "| Benchmarks | Fully automatic | Direction Gate continues; Stitch Gate continues only on `meets direction` |",
        "| Guidelines | Guided | Direction Gate stops; Stitch Gate stops |",
        "| Guidelines | Follow recommendation | Direction Gate continues with the marked recommendation; Stitch Gate stops |",
        "| Guidelines | Fully automatic | Direction Gate continues; Stitch Gate continues only on `meets direction` |",
    ),
    "benchmark evidence quality": (
        "Inspect complete, relevant real-product journeys and explain why each selected pattern is useful for the established objective.",
        "Library presence, metadata, popularity, or one screenshot never proves best-in-class quality.",
    ),
    "guidelines isolation": (
        "In Guidelines mode, perform no benchmark lookup and make no benchmark-evidence claim.",
    ),
    "missing benchmark access": (
        "If benchmark access is missing, stop; never degrade silently.",
        "Offer either a one-run Guidelines fallback that does not rewrite the saved preference, or a confirmed saved switch to Guidelines.",
    ),
    "legacy preference mapping": (
        "`.codex/fb-ux.yaml` maps to `evidence_mode: benchmarks`, `benchmark_provider: mobbin`, and its preserved approval mode.",
        "`.codex/apple-guidelines-stitch.yaml` maps to `evidence_mode: guidelines`, omits `benchmark_provider`, and preserves its approval mode.",
        "Show the proposed mapping and ask once before importing it.",
        "If both legacy files exist, present both mappings and require the user to choose one or start fresh.",
        "Never silently merge, rewrite, or delete either legacy preference file.",
    ),
    "objective handling": (
        "In Guided or Follow recommendation mode, restate a stated objective and ask the user to confirm or revise it.",
        "Fully automatic may skip the objective pause only when the current request states an explicit objective.",
        "If the objective is missing or materially ambiguous, stop and ask; never invent it.",
    ),
    "direction gate": (
        "At the Direction Gate, present one unmistakably marked recommendation plus meaningful alternatives and their trade-offs.",
    ),
    "stitch gate": (
        "Fully automatic continues only when the Stitch verdict is `meets direction`; `meets with corrections` and `does not meet` both stop.",
    ),
    "platform precedence": (
        "For Android or web targets, current first-party platform rules override conflicting Apple-inspired judgment.",
    ),
    "evidence integrity": (
        "Do not claim product inspection, first-party guidance, benchmark evidence, or new Stitch output without current evidence for that exact claim.",
    ),
    "authorization boundary": (
        "Design approval never authorizes source implementation, staging, live deployment, release, destructive changes, provider changes, or work outside the authorized integration lane.",
    ),
    "project home resolution": (
        "Call `list_projects` before any home lookup or creation and resolve the current saved project's `projectId` and saved-project name; use the workspace-folder name only when the saved-project name is unavailable.",
        "The canonical title is `Design Arc — <Project Name>`.",
    ),
    "project home confirmation": (
        "Home creation must be part of the setup proposal and must be explicitly confirmed before `create_thread` is called.",
        "That confirmed project-home setup is standing authorization for this home to launch later journey starters as clean tasks in the same saved project.",
    ),
    "project home isolation": (
        "Never create a `projectless` Design Arc home or reuse a home whose project identity differs, even when its title matches.",
        "A project without confirmed Design Arc setup gets no home and no sidebar item.",
    ),
    "project home deduplication": (
        "Call `list_threads` with `limit: 50`; inspect both `pinnedThreads` and `threads`, and match a home by both the exact canonical title and the resolved `projectId`.",
        "If multiple same-project matches exist, select the most recent canonical match for adoption, report every other matching thread for user cleanup, and never delete, archive, merge, silently rename, or reuse those duplicates.",
    ),
    "project home task creation": (
        '`target: { type: "project", projectId: <resolved projectId>, environment: { type: "local" } }`',
        "Never pass a returned `clientThreadId` to thread tools that require a `threadId`.",
    ),
    "project home launchpad content": (
        "The home card displays the project identity, Design Arc installed status, active and saved evidence and approval preferences with provenance, plain-language journey starters, and preference controls.",
        "The home is only a launchpad; it never performs the journey audit, research, direction work, or visualization in the home task.",
    ),
    "clean journey task launch": (
        "When the user submits a journey starter inside a confirmed home, call `create_thread` for a clean task with the same resolved `projectId`, `environment: { type: \"local\" }`, and a prompt containing the user's starter plus the active Design Arc settings and project identity.",
        "Do not launch a worktree, continue the journey inside the home, specify a model, or invent another project.",
    ),
    "natural language activation": (
        "Outside a Design Arc home, an ordinary product-journey request activates Design Arc in the current task; briefly disclose that Design Arc is being used and continue without requiring `$design-arc`.",
    ),
    "task tool fallback": (
        "If task discovery, creation, title, or pin tools are unavailable or fail, complete confirmed preference setup, do not claim a home or launch succeeded, and return the exact canonical home title plus the full starter card and manual create-and-pin steps.",
    ),
    "safe plugin upgrade": (
        "`$design-arc upgrade`",
        "A request such as “upgrade Design Arc” activates this same safe upgrade flow without requiring the command.",
        "Before changing the Codex plugin profile, report the installed and available Design Arc versions, the marketplace source, and the exact planned upgrade route; require confirmation unless the current request already explicitly authorizes that exact upgrade.",
        "Before any remove/add fallback, capture and verify an immutable restoration artifact: an exact commit or immutable ref, or a verified local package backup; a marketplace source plus version label alone is insufficient.",
        "A plugin upgrade is laptop/profile-scoped and must not run project setup, create or replace a project home, change title or pin state, rewrite `.codex/design-arc.yaml`, touch product files, or continue an active review.",
        "After the upgrade, verify exactly one enabled `design-arc@design-arc-marketplace`, report its version, and report `project homes recreated: 0` and `project preferences changed: 0` only when current evidence supports both claims.",
        "An already-open task may retain older task context; keep its project home unchanged and tell the user to start the next review from that existing home so a clean task loads the upgraded plugin.",
    ),
}


MOTION_CONTRACT_CASES = {
    "case 01 evidence precedence": (
        "Use this motion-evidence precedence: existing product motion; native platform behavior and standard components; current first-party platform guidance; inspected relevant shipped-product motion; labeled Design Arc judgment.",
    ),
    "case 02 benchmark and static limits": (
        "In Benchmarks mode, authorized shipped-product motion may be inspected as precedent.",
        "Static screens or sequences support only start/end state, changing element, journey location, and transition intent; they cannot support exact duration, easing, springs, velocity, interruption, or choreography.",
    ),
    "case 03 playable evidence record": (
        "For playable motion evidence, record source; product/journey; frame rate when known; observed duration/path/order; interruption/reversal; measurement method; confidence; and missing states. Frame-derived values are estimates.",
    ),
    "case 04 temporal claim labels": (
        "Every temporal claim uses exactly one label: `directly observed`, `measured estimate`, `pattern-level inference`, `Design Arc judgment`, or `unverified`.",
    ),
    "case 05 unavailable playable evidence": (
        "When necessary playable evidence is unavailable, report the limitation and offer an accessible live product, user recording, authorized Page Flows recording, native default, or labeled proposal requiring implementation validation. Never invent it.",
    ),
    "case 06 Guidelines isolation": (
        "In Guidelines mode, perform no benchmark lookup, make no real-product motion claim, and report that no benchmark motion was inspected.",
    ),
    "case 07 complete material motion contract": (
        "Every material motion contract includes: Motion ID; journey location; purpose; trigger; start/end state; spatial behavior; choreography; timing; easing/spring; interruption; reduced motion; evidence; provenance; implementation target; implementation source; proof status. Unsupported values are `unverified`.",
        "`implementation target` records the runtime and UI technology, such as Web, React, SwiftUI, UIKit, or Compose; record component and state-change specificity separately when useful.",
        "`timing` uses milliseconds or seconds for duration and delay, or records that a physical spring with explicit parameters governs timing.",
        "`easing/spring` records cubic-bezier coordinates, a named platform curve, or physical spring parameters such as mass, stiffness, damping, and initial velocity.",
        "`interruption` records whether motion can be interrupted or reversed, how cancellation resolves, and what happens on re-entry.",
        "`provenance` uses exactly one of `directly observed`, `measured estimate`, `pattern-level inference`, `Design Arc judgment`, or `unverified` for each claim, cites the supporting source, and records the measurement or estimate basis when applicable.",
        "`implementation source` names the existing product token, native or standard component, separately approved library, or custom implementation and records the authorizing owner; a proposal alone does not authorize it.",
        "`proof status` distinguishes `specified`, `prototyped`, `staging verified`, `device verified`, and `production verified` as applicable; use only the highest status established by current evidence.",
    ),
    "case 08 Motion+ boundary": (
        "Motion+ is never required by or evidence for Design Arc, and it is never a Design Arc dependency.",
        "An authorized implementation owner may separately approve Motion+ as an optional implementation dependency and implementation source; that approval does not install it or make it Design Arc evidence or authority.",
        "After separate authorization from the implementation owner, Motion+ assistance may cover documentation and example search; reusable source retrieval; spring and easing assistance; saved-transition inspection; performance auditing; and design-system adaptation.",
    ),
    "case 09 direction summary and least motion": (
        "At the Direction Gate, include a motion summary that identifies the material motion scope, retained native or existing behavior, proposed custom behavior, and unresolved evidence.",
        "Apply the least-motion principle: use no more motion than the stated interaction purpose requires, and remove decorative motion without a justified purpose.",
        "For each direction, explain the motion's concrete interaction purpose and why it uses no more motion than that purpose requires.",
        "For each direction, cite relevant inspected real-product evidence and current platform guidance, or state that either is unavailable.",
        "For each direction, apply the required provenance label to every temporal claim and distinguish directly observed behavior from measured estimates.",
        "For each direction, describe reduced-motion implications, motion-specific risks, and implementation complexity in the target stack.",
        "For each direction, identify what remains unproven and the staging, device, or production evidence needed to prove it.",
        "Headings or field names without these direction-specific explanations do not satisfy the Direction Gate.",
    ),
    "case 10 prototype, proof, and authority boundaries": (
        "Stitch and other design prototypes can illustrate states and transition intent but cannot prove timing, easing, springs, interruption, reduced-motion behavior, performance, or runtime implementation quality.",
        "Only measured staging or target-device behavior can establish implementation proof.",
        "Design Arc may specify and critique motion, but it does not authorize application-code implementation, dependency installation, staging, deployment, or release.",
        "Before assigning a Stitch verdict, explicitly evaluate motion purpose and least-motion restraint, provenance labels and citations, reduced-motion behavior, alignment with every material motion contract, prototype limitations, and remaining runtime proof.",
        "A `meets direction` verdict is valid only when the prototype aligns with those motion requirements within its capabilities and every limitation and remaining runtime proof item is documented; any unexplained gap yields `meets with corrections` or `does not meet`.",
        "Fully automatic may continue on `meets direction` only after this motion evaluation is recorded; it cannot waive a missing or contradictory motion check.",
    ),
    "case 11 motion run record": (
        "Relevant run records include motion scope, evidence, provenance, contracts, reduced motion, implementation source, proof, and remaining uncertainty.",
    ),
    "case 12 automatic evidence integrity": (
        "Fully automatic mode never bypasses motion evidence integrity.",
    ),
}


PROJECT_HOME_HEADING = "### Project home"
PROJECT_HOME_MUTATION_HEADING = "#### Reuse, create, recover, and verify"

REQUIRED_PROJECT_HOME_CONTRACTS = {
    "home metadata isolation": (
        "Store home metadata under `design_arc_home` in the current project's `.codex/design-arc.yaml`; it is project-scoped state, not a global preference.",
        "Every home-state write must preserve `evidence_mode`, `benchmark_provider` when present, and `approval_mode` unchanged.",
    ),
    "pending duplicate guard": (
        "A `pending` or `ready` `design_arc_home` record blocks every new automatic home `create_thread` call.",
        "Never silently clear or replace a pending or ready record.",
    ),
    "queued recovery": (
        "Store `pending_since` as an ISO-8601 UTC timestamp before task creation so later recovery can bound candidate age.",
        "Store a deterministic recovery marker in metadata and in the home task's initial prompt.",
        "When only `clientThreadId` is returned, keep `state: pending`, store `client_thread_id`, and do not pass it to a thread-ID tool.",
        "If exactly one same-project task contains the recorded recovery marker, store its `threadId` and resume the pending transition; otherwise keep the guard and report the unresolved pending state.",
    ),
    "explicit abandonment": (
        "Only explicit user confirmation may abandon a pending or stale ready record and authorize a retry.",
        "After confirmed abandonment, re-run title, project, and recovery-marker discovery before any replacement creation.",
    ),
    "home state transitions": (
        "The only automatic home-state transitions are `absent → pending`, `pending → pending + client_thread_id|thread_id`, and `pending + thread_id → ready + thread_id`.",
        "Manual fallback remains `pending` until the exact title and project identity are verified.",
    ),
    "existing home adoption": (
        "An existing exact title-and-project match is an adoption candidate, not a ready home.",
        "After confirmation, write `state: pending` with the candidate's `thread_id` while preserving the evidence and approval values, then enter the common readiness sequence.",
        "New, recovered, and adopted tasks all use the same title-once, pin-once, re-list verification sequence before any `ready` write.",
    ),
    "stored thread recovery evidence": (
        "For a pending record with `thread_id`, first resolve that exact stored ID with `list_threads` and `read_thread` and require the exact saved `project_id`; then choose recovery proof from the record's creation path.",
        "For an adopted pending task, the exact canonical title is the recovery proof; do not require the recovery marker because the task may predate Design Arc.",
        "For a newly created pending task whose ready result supplied and stored `thread_id`, the exact recorded recovery marker in its initial prompt is the recovery proof, so the canonical title need not exist yet.",
        "If the exact stored ID does not resolve, the project identity mismatches, or neither allowed recovery proof matches, keep `state: pending`, report the stale or mismatched identity, and require explicit abandonment; never create a replacement automatically.",
        "Use `pending_since` plus recovery-marker candidate scanning only when a pending record has no `thread_id`.",
    ),
    "single ready mutation sequence": (
        "Call `set_thread_title` once, then call `set_thread_pinned` once, then call `list_threads` again and verify the canonical title, resolved project identity, and pinned state.",
        "Only after that verification, write `state: ready` with the verified `thread_id`.",
        "Do not mutate title or pin after verification.",
    ),
}

PROJECT_HOME_MUTATION_SEQUENCE = (
    "Write `state: pending` before calling `create_thread`.",
    "Call `create_thread` once.",
    "Call `set_thread_title` once",
    "call `set_thread_pinned` once",
    "call `list_threads` again and verify",
    "Only after that verification, write `state: ready`",
)

PROJECT_HOME_ADOPTION_SEQUENCE = (
    "An existing exact title-and-project match is an adoption candidate, not a ready home.",
    "After confirmation, write `state: pending` with the candidate's `thread_id`",
    "For a new, adopted, or exactly recovered task",
    "Call `set_thread_title` once",
    "call `set_thread_pinned` once",
    "call `list_threads` again and verify",
    "Only after that verification, write `state: ready`",
)

PROJECT_HOME_STORED_THREAD_RECOVERY_SEQUENCE = (
    "For a pending record with `thread_id`, first resolve that exact stored ID",
    "For an adopted pending task, the exact canonical title is the recovery proof",
    "For a newly created pending task whose ready result supplied and stored `thread_id`",
    "If the exact stored ID does not resolve, the project identity mismatches, or neither allowed recovery proof matches",
    "For a new, adopted, or exactly recovered task",
    "Call `set_thread_title` once",
    "call `set_thread_pinned` once",
    "call `list_threads` again and verify",
)

FORBIDDEN_PROJECT_HOME_PATTERNS = {
    "pending guard bypass": re.compile(
        r"(?:may|must|should)\s+(?:ignore|bypass).{0,100}(?:pending|ready).{0,100}(?:create|retry)",
        re.IGNORECASE | re.DOTALL,
    ),
    "silent home-state clearing": re.compile(
        r"(?:(?<!never )silently|without (?:explicit )?confirmation).{0,100}(?:clear|remove|delete).{0,100}(?:pending|ready|home record)",
        re.IGNORECASE | re.DOTALL,
    ),
    "ready before verification": re.compile(
        r"(?:mark|write|set).{0,60}(?:state:\s*)?ready.{0,120}before.{0,120}(?:verify|verification)",
        re.IGNORECASE | re.DOTALL,
    ),
    "mutation after verification": re.compile(
        r"after verification.{0,120}(?:call|run).{0,80}(?:set_thread_title|set_thread_pinned)",
        re.IGNORECASE | re.DOTALL,
    ),
    "direct ready adoption": re.compile(
        r"(?:adopt|reuse).{0,120}(?:by|directly|immediately).{0,80}(?:writ(?:e|ing)|mark|set).{0,60}(?:state:\s*)?`?ready`?",
        re.IGNORECASE | re.DOTALL,
    ),
    "adoption readiness bypass": re.compile(
        r"adopt(?:ed|ion)?.{0,120}(?:skip|bypass).{0,120}(?:pending|pin|list_threads|verification)",
        re.IGNORECASE | re.DOTALL,
    ),
    "absent direct to ready": re.compile(
        r"absent\s*(?:→|->|to)\s*ready",
        re.IGNORECASE,
    ),
    "adopted thread marker requirement": re.compile(
        r"adopted pending task.{0,180}(?<!do not )require (?:the )?(?:recorded )?recovery marker",
        re.IGNORECASE | re.DOTALL,
    ),
    "created thread title requirement": re.compile(
        r"newly created pending task.{0,220}(?:must|should|may only).{0,100}(?:canonical title|title match)",
        re.IGNORECASE | re.DOTALL,
    ),
    "created thread marker bypass": re.compile(
        r"newly created pending task.{0,220}(?:need not|does not need to|without).{0,100}(?:recovery marker|marker)",
        re.IGNORECASE | re.DOTALL,
    ),
    "stored thread automatic replacement": re.compile(
        r"(?:(?:missing|mismatched|unresolved).{0,160}(?:stored )?`?thread_id`?|(?:stored )?`?thread_id`?.{0,80}(?:is )?(?:missing|mismatched|unresolved)).{0,160}(?:may|must|should).{0,80}(?:create|replace)",
        re.IGNORECASE | re.DOTALL,
    ),
}


RENDER_REPAIR_HEADING = "### Repair Stitch drift before the Stitch Gate"

RENDER_REPAIR_CONTRACTS = {
    "proposal-wide three-round bound": (
        "Use one initial Stitch proposal followed by at most three batched correction rounds for the entire proposal.",
        "The initial proposal is not a correction round, so the maximum is four rendered proposals.",
    ),
    "conformance matrix": (
        "Before assigning a Stitch verdict, create a conformance matrix for every material screen and state.",
        "Each row records the screen or state identifier; approved requirement and provenance; observed render evidence; classification; exact correction or next action; and inspected render identifier.",
    ),
    "classification boundary": (
        "Classify every mismatch as `match`, `repairable drift`, `direction decision required`, or `runtime proof`.",
        "Correct `repairable drift` automatically without asking the user because it does not change the approved direction.",
        "Stop before correction when a direction decision or new external authorization is required.",
        "Carry `runtime proof` forward as unverified implementation evidence; do not retry Stitch or claim the prototype proves it.",
    ),
    "inspection integrity": (
        "A correction note, provider status, or command success is not proof of correction; only inspection of the newly generated render can change a mismatch to `match`.",
        "After every correction round, inspect the complete resulting proposal again, including previously matching requirements that may have regressed.",
    ),
    "bounded convergence": (
        "Stop early only when two consecutive corrected proposals show no improvement, two consecutive corrected proposals oscillate by fixing one requirement while breaking another, access becomes unavailable, the next correction changes direction, or new authorization is required.",
        "After the third unsuccessful correction round, stop and assign `meets with corrections` or `does not meet` from the remaining mismatch scope.",
    ),
    "verdict integrity": (
        "Assign `meets direction` only after the most recent complete proposal is inspected and every Stitch-expressible requirement matches.",
        "Guided and Follow recommendation perform the repair loop before stopping at the Stitch Gate.",
        "Fully automatic performs the same repair loop and continues past the Stitch Gate only on `meets direction`.",
    ),
    "repair record": (
        "Record the initial proposal identifiers; each conformance matrix; correction round number; batched correction request and provenance; fixed, remaining, and newly introduced mismatches; stop reason; final Stitch verdict; and remaining runtime proof.",
    ),
}


def markdown_section(text: str, heading: str, next_prefix: str) -> str | None:
    start = text.find(heading)
    if start < 0:
        return None
    end = text.find(f"\n{next_prefix}", start + len(heading))
    return text[start:] if end < 0 else text[start:end]


def is_ordered(text: str, fragments: tuple[str, ...]) -> bool:
    cursor = 0
    for fragment in fragments:
        position = text.find(fragment, cursor)
        if position < 0:
            return False
        cursor = position + len(fragment)
    return True


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Check deterministic Design Arc workflow contracts."
    )
    parser.add_argument("--skill", type=Path, default=DEFAULT_SKILL)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        text = args.skill.read_text(encoding="utf-8")
    except OSError as error:
        print(f"FAIL: cannot read Design Arc instruction contract: {error}", file=sys.stderr)
        return 1

    failures = []
    for label, fragments in REQUIRED_CONTRACTS.items():
        if any(fragment not in text for fragment in fragments):
            failures.append(f"missing or reversed {label} contract")

    for label, fragments in MOTION_CONTRACT_CASES.items():
        if any(fragment not in text for fragment in fragments):
            failures.append(f"missing or reversed motion {label} contract")

    render_repair = markdown_section(text, RENDER_REPAIR_HEADING, "## ")
    if render_repair is None:
        failures.append("missing render-repair section")
    else:
        for label, fragments in RENDER_REPAIR_CONTRACTS.items():
            if any(fragment not in render_repair for fragment in fragments):
                failures.append(f"missing or reversed render-repair {label} contract")

    project_home = markdown_section(text, PROJECT_HOME_HEADING, "### ")
    if project_home is None:
        failures.append("missing Project home section")
    else:
        for label, fragments in REQUIRED_PROJECT_HOME_CONTRACTS.items():
            if any(fragment not in project_home for fragment in fragments):
                failures.append(f"missing or reversed {label} contract")

        mutation_section = markdown_section(
            project_home, PROJECT_HOME_MUTATION_HEADING, "#### "
        )
        if mutation_section is None or not is_ordered(
            mutation_section, PROJECT_HOME_MUTATION_SEQUENCE
        ):
            failures.append("missing or reversed project-home mutation sequence")
        elif not is_ordered(mutation_section, PROJECT_HOME_ADOPTION_SEQUENCE):
            failures.append("missing or reversed project-home adoption sequence")
        elif not is_ordered(
            mutation_section, PROJECT_HOME_STORED_THREAD_RECOVERY_SEQUENCE
        ):
            failures.append("missing or reversed stored-thread recovery sequence")
        elif any(
            mutation_section.count(f"`{tool_name}`") != 1
            for tool_name in ("set_thread_title", "set_thread_pinned")
        ):
            failures.append("project-home title or pin mutation is not singular")

        for label, pattern in FORBIDDEN_PROJECT_HOME_PATTERNS.items():
            if pattern.search(project_home):
                failures.append(f"contradictory {label} contract")

    if failures:
        for failure in failures:
            print(f"FAIL: Design Arc: {failure}", file=sys.stderr)
        return 1

    print("PASS: deterministic Design Arc instruction contracts")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
