#!/usr/bin/env python3
"""Mutation tests for Claude Code setup and state-isolation contracts."""

from __future__ import annotations

import subprocess
import sys
import tempfile
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parent.parent
CHECKER = REPO_ROOT / "scripts/check-claude-state-contracts.py"
CLAUDE_SKILL = REPO_ROOT / "claude-plugins/design-arc/skills/design-arc/SKILL.md"


MUTATIONS = {
    "new setup confirmation": (
        "On new Claude setup, propose every missing preference and obtain explicit confirmation before creating `.claude/design-arc.yaml`.",
        "On new Claude setup, create `.claude/design-arc.yaml` before asking the user.",
    ),
    "confirmed Codex preference import": (
        "Only after explicit import approval, copy the validated portable values into a new Claude preference file; do not move or rename the Codex file.",
        "Import Codex preferences automatically whenever the Claude file is absent.",
    ),
    "byte-preserving Codex import": (
        "Treat the Codex preference file and every Codex active-review, review, graph, and home record as read-only; verify the imported source remains byte-for-byte unchanged.",
        "Normalize the Codex preference file after importing it.",
    ),
    "declined Codex import": (
        "If the user declines import, leave all Codex state untouched and continue with a fresh Claude setup.",
        "If the user declines import, remove the Codex preference before fresh setup.",
    ),
    "malformed Codex import": (
        "If the Codex file is malformed or any portable value is invalid, import nothing, report the invalid fields without exposing unrelated contents, and offer fresh Claude setup.",
        "Salvage valid-looking fields from malformed Codex preferences.",
    ),
    "existing Claude preferences": (
        "When `.claude/design-arc.yaml` already exists, treat it as the Claude saved preference, do not offer Codex import, and never overwrite it from `.codex/design-arc.yaml`.",
        "Prefer newer-looking Codex preferences over an existing Claude file.",
    ),
    "unrelated CLAUDE.md preservation": (
        "Preserve every byte outside that exact marked block, including unrelated instructions, spacing, and final-newline state.",
        "Rewrite CLAUDE.md into a normalized Design Arc template.",
    ),
    "idempotent reminder insertion": (
        "Before writing, detect the exact markers; add the block only when absent, keep exactly one block when present, and never append a duplicate.",
        "Append a fresh Design Arc reminder on every setup run.",
    ),
    "denied reminder permission": (
        "If permission is denied, do not create or modify `CLAUDE.md`; complete confirmed preference setup without the reminder.",
        "Treat preference confirmation as permission to edit CLAUDE.md.",
    ),
    "manual reminder fallback": (
        "If safe automatic insertion is unavailable or the write fails, leave `CLAUDE.md` unchanged, say that the reminder was not installed, and return the exact block plus manual insertion steps.",
        "If insertion fails, claim success and continue without manual steps.",
    ),
    "runtime provenance": (
        "Every new active-review record includes `runtime: codex` or `runtime: claude-code` together with its pinned `workflow_version`.",
        "Infer the active runtime from whichever review file is newest.",
    ),
    "Claude review storage": (
        "Claude Code stores preferences only at `.claude/design-arc.yaml`, active-review identity only at `.claude/design-arc-active-review.json`, and review artifacts only under `.claude/design-arc/reviews/<review_id>/`.",
        "Claude Code stores new review artifacts under .codex for compatibility.",
    ),
    "cross-runtime review isolation": (
        "Never import, merge, migrate, resume, or continue an active review across runtimes; preference import is the only allowed cross-runtime copy.",
        "Merge Codex and Claude active reviews when their objectives match.",
    ),
    "upgrade and downgrade preservation": (
        "An adapter upgrade or downgrade preserves both runtimes' preferences, reminder blocks, review directories, graph files, product files, and active-review records byte-for-byte.",
        "Upgrade shared project state to the newest adapter schema in place.",
    ),
    "active session preservation": (
        "It never resumes, converts, merges, or rewrites an active session; that session retains its recorded runtime and workflow version, while only a new clean session may load the changed adapter version.",
        "Continue active sessions immediately under the changed adapter version.",
    ),
    "downgrade fallback": (
        "An older adapter ignores unsupported state while preserving it; it never deletes or reinterprets newer preferences, reminders, reviews, or graphs.",
        "Delete state that an older adapter cannot understand.",
    ),
}


CONTRADICTIONS = {
    "silent import contradiction": "Import Codex preferences automatically whenever the Claude file is absent.",
    "destructive reminder contradiction": "Rewrite CLAUDE.md into a normalized Design Arc template.",
    "cross-runtime merge contradiction": "Merge Codex and Claude active reviews when their objectives match.",
    "upgrade mutation contradiction": "Upgrade shared project state to the newest adapter schema in place.",
}


ACTIVE_CODEX_DIRECTIVES = {
    "Codex preference destination": "Store project-scoped choices in `.codex/design-arc.yaml`:",
    "Codex command syntax": "`$design-arc setup`",
    "Codex activation": "If Codex has selected this skill",
    "Codex plugin upgrade": "An upgrade changes the shared Codex plugin installation",
    "Codex home state": "Store home metadata under `design_arc_home`",
    "Codex task creation": "Call `create_thread` once.",
    "Codex global graph state": "$CODEX_HOME/design-arc-global.yaml",
    "Codex graph destination": "Store each record only at `.codex/design-arc/reviews/<review_id>/graph.json`",
    "Codex legacy import": "Only consider import when `.codex/design-arc.yaml` is absent.",
    "Codex default visualization": "Generate one complete static journey board in Codex by default",
    "Codex bounded revisions": "bounded image revisions in Codex",
    "Codex correction round": "after one Codex correction round",
    "Codex recommendation continuation": "I can continue in Codex if you prefer.",
    "Codex stay choice": "continuing in Codex remains available. Treat `stay in Codex`",
    "Codex default route": "For the default Codex route",
    "Codex evidence return": "Return decision-ready evidence in Codex",
    "Codex run record": "Report these fields in the Codex conversation",
}


def run_checker(skill: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(CHECKER), str(skill)],
        cwd=REPO_ROOT,
        text=True,
        capture_output=True,
        check=False,
    )


def require_rejected(result: subprocess.CompletedProcess[str], label: str) -> None:
    if result.returncode == 0:
        raise AssertionError(f"unsafe Claude state mutation was accepted: {label}")
    if label not in result.stderr:
        raise AssertionError(
            f"Claude state mutation failed for the wrong reason ({label}): "
            f"{result.stderr.strip()}"
        )


def test_complete_claude_state_contract_is_accepted() -> None:
    """The packaged Claude skill must encode every setup and preservation branch."""
    result = run_checker(CLAUDE_SKILL)
    if result.returncode != 0:
        raise AssertionError(
            f"complete Claude state contract was rejected: {result.stderr.strip()}"
        )


def test_each_missing_or_unsafe_state_branch_is_rejected() -> None:
    """Removing any required branch must make the state contract fail closed."""
    source = CLAUDE_SKILL.read_text(encoding="utf-8")
    with tempfile.TemporaryDirectory(prefix="design-arc-claude-state-") as temporary:
        mutated = Path(temporary) / "SKILL.md"
        for label, (required, unsafe) in MUTATIONS.items():
            if required not in source:
                raise AssertionError(f"mutation fixture is absent from packaged skill: {label}")
            mutated.write_text(source.replace(required, unsafe, 1), encoding="utf-8")
            require_rejected(run_checker(mutated), label)


def test_explicitly_unsafe_contradictions_are_rejected() -> None:
    """Unsafe instructions must fail even when every required sentence remains."""
    source = CLAUDE_SKILL.read_text(encoding="utf-8")
    with tempfile.TemporaryDirectory(prefix="design-arc-claude-contradiction-") as temporary:
        mutated = Path(temporary) / "SKILL.md"
        for label, contradiction in CONTRADICTIONS.items():
            mutated.write_text(f"{source}\n\n{contradiction}\n", encoding="utf-8")
            require_rejected(run_checker(mutated), label)


def test_claude_skill_has_no_active_codex_runtime_directives() -> None:
    """Read-only Codex import must not leave executable Codex behavior in Claude."""
    source = CLAUDE_SKILL.read_text(encoding="utf-8")
    found = [label for label, directive in ACTIVE_CODEX_DIRECTIVES.items() if directive in source]
    if found:
        raise AssertionError(
            "Claude skill retained active Codex runtime directives: " + ", ".join(found)
        )
    with tempfile.TemporaryDirectory(prefix="design-arc-claude-runtime-") as temporary:
        mutated = Path(temporary) / "SKILL.md"
        for label, directive in ACTIVE_CODEX_DIRECTIVES.items():
            mutated.write_text(f"{source}\n\n{directive}\n", encoding="utf-8")
            require_rejected(run_checker(mutated), label)


def main() -> int:
    test_complete_claude_state_contract_is_accepted()
    print("PASS: complete Claude setup and state contract")
    test_each_missing_or_unsafe_state_branch_is_rejected()
    print(f"PASS: {len(MUTATIONS)} missing or unsafe Claude state mutations rejected")
    test_explicitly_unsafe_contradictions_are_rejected()
    print(f"PASS: {len(CONTRADICTIONS)} unsafe Claude state contradictions rejected")
    test_claude_skill_has_no_active_codex_runtime_directives()
    print(
        f"PASS: {len(ACTIVE_CODEX_DIRECTIVES)} active Codex runtime directives rejected"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
