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
        "If multiple same-project matches exist, use and pin the most recent canonical match, report every other matching thread for user cleanup, and never delete, archive, merge, silently rename, or reuse those duplicates.",
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
