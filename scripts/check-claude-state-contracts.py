#!/usr/bin/env python3
"""Validate Claude Code setup and state-isolation instruction contracts."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_SKILL = REPO_ROOT / "claude-plugins/design-arc/skills/design-arc/SKILL.md"


REQUIRED_CONTRACTS = {
    "new setup confirmation": (
        "On new Claude setup, propose every missing preference and obtain explicit confirmation before creating `.claude/design-arc.yaml`.",
    ),
    "confirmed Codex preference import": (
        "Only after explicit import approval, copy the validated portable values into a new Claude preference file; do not move or rename the Codex file.",
    ),
    "byte-preserving Codex import": (
        "Treat the Codex preference file and every Codex active-review, review, graph, and home record as read-only; verify the imported source remains byte-for-byte unchanged.",
    ),
    "declined Codex import": (
        "If the user declines import, leave all Codex state untouched and continue with a fresh Claude setup.",
    ),
    "malformed Codex import": (
        "If the Codex file is malformed or any portable value is invalid, import nothing, report the invalid fields without exposing unrelated contents, and offer fresh Claude setup.",
    ),
    "existing Claude preferences": (
        "When `.claude/design-arc.yaml` already exists, treat it as the Claude saved preference, do not offer Codex import, and never overwrite it from `.codex/design-arc.yaml`.",
    ),
    "unrelated CLAUDE.md preservation": (
        "Preserve every byte outside that exact marked block, including unrelated instructions, spacing, and final-newline state.",
    ),
    "idempotent reminder insertion": (
        "Before writing, detect the exact markers; add the block only when absent, keep exactly one block when present, and never append a duplicate.",
    ),
    "denied reminder permission": (
        "If permission is denied, do not create or modify `CLAUDE.md`; complete confirmed preference setup without the reminder.",
    ),
    "manual reminder fallback": (
        "If safe automatic insertion is unavailable or the write fails, leave `CLAUDE.md` unchanged, say that the reminder was not installed, and return the exact block plus manual insertion steps.",
    ),
    "runtime provenance": (
        "Every new active-review record includes `runtime: codex` or `runtime: claude-code` together with its pinned `workflow_version`.",
    ),
    "Claude review storage": (
        "Claude Code stores preferences only at `.claude/design-arc.yaml`, active-review identity only at `.claude/design-arc-active-review.json`, and review artifacts only under `.claude/design-arc/reviews/<review_id>/`.",
    ),
    "cross-runtime review isolation": (
        "Never import, merge, migrate, resume, or continue an active review across runtimes; preference import is the only allowed cross-runtime copy.",
    ),
    "upgrade and downgrade preservation": (
        "An adapter upgrade or downgrade preserves both runtimes' preferences, reminder blocks, review directories, graph files, product files, and active-review records byte-for-byte.",
    ),
    "active session preservation": (
        "It never resumes, converts, merges, or rewrites an active session; that session retains its recorded runtime and workflow version, while only a new clean session may load the changed adapter version.",
    ),
    "downgrade fallback": (
        "An older adapter ignores unsupported state while preserving it; it never deletes or reinterprets newer preferences, reminders, reviews, or graphs.",
    ),
}


FORBIDDEN_CONTRACTS = {
    "silent import contradiction": (
        "Import Codex preferences automatically whenever the Claude file is absent.",
    ),
    "destructive reminder contradiction": (
        "Rewrite CLAUDE.md into a normalized Design Arc template.",
    ),
    "cross-runtime merge contradiction": (
        "Merge Codex and Claude active reviews when their objectives match.",
    ),
    "upgrade mutation contradiction": (
        "Upgrade shared project state to the newest adapter schema in place.",
    ),
    "Codex preference destination": (
        "Store project-scoped choices in `.codex/design-arc.yaml`:",
    ),
    "Codex command syntax": (
        "`$design-arc setup`",
    ),
    "Codex activation": (
        "If Codex has selected this skill",
    ),
    "Codex plugin upgrade": (
        "An upgrade changes the shared Codex plugin installation",
    ),
    "Codex home state": (
        "Store home metadata under `design_arc_home`",
    ),
    "Codex task creation": (
        "Call `create_thread` once.",
    ),
    "Codex global graph state": (
        "$CODEX_HOME/design-arc-global.yaml",
    ),
    "Codex graph destination": (
        "Store each record only at `.codex/design-arc/reviews/<review_id>/graph.json`",
    ),
    "Codex legacy import": (
        "Only consider import when `.codex/design-arc.yaml` is absent.",
    ),
    "Codex default visualization": (
        "Generate one complete static journey board in Codex by default",
    ),
    "Codex bounded revisions": (
        "bounded image revisions in Codex",
    ),
    "Codex correction round": (
        "after one Codex correction round",
    ),
    "Codex recommendation continuation": (
        "I can continue in Codex if you prefer.",
    ),
    "Codex stay choice": (
        "continuing in Codex remains available. Treat `stay in Codex`",
    ),
    "Codex default route": (
        "For the default Codex route",
    ),
    "Codex evidence return": (
        "Return decision-ready evidence in Codex",
    ),
    "Codex run record": (
        "Report these fields in the Codex conversation",
    ),
}


REMINDER_BLOCK = """<!-- design-arc:reminder:start -->
When a UI journey request matches Design Arc, suggest `/design-arc:design-arc` and wait for explicit approval unless the user invoked Design Arc directly. Never claim Design Arc ran unless the skill loaded.
<!-- design-arc:reminder:end -->"""


def normalized(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip()


def validate(skill: Path) -> list[str]:
    source = skill.read_text(encoding="utf-8")
    compact = normalized(source)
    failures: list[str] = []

    for label, clauses in REQUIRED_CONTRACTS.items():
        if any(normalized(clause) not in compact for clause in clauses):
            failures.append(label)

    for label, contradictions in FORBIDDEN_CONTRACTS.items():
        if any(normalized(contradiction) in compact for contradiction in contradictions):
            failures.append(label)

    if source.count(REMINDER_BLOCK) != 1:
        failures.append("exact reminder block")
    if source.count("<!-- design-arc:reminder:start -->") != 1:
        failures.append("single reminder start marker")
    if source.count("<!-- design-arc:reminder:end -->") != 1:
        failures.append("single reminder end marker")
    return failures


def parser() -> argparse.ArgumentParser:
    argument_parser = argparse.ArgumentParser(description=__doc__)
    argument_parser.add_argument("skill", nargs="?", type=Path, default=DEFAULT_SKILL)
    return argument_parser


def main() -> int:
    args = parser().parse_args()
    try:
        failures = validate(args.skill)
    except OSError as error:
        print(f"FAIL: {error}", file=sys.stderr)
        return 1
    if failures:
        print(f"FAIL: {', '.join(failures)}", file=sys.stderr)
        return 1
    print("PASS: Claude setup, import, reminder, runtime, and upgrade contracts")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
