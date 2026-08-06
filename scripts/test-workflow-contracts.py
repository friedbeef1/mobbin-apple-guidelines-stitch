#!/usr/bin/env python3
"""Mutation tests for the deterministic skill instruction-contract checker."""

from __future__ import annotations

import subprocess
import sys
import tempfile
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parent.parent
CHECKER = REPO_ROOT / "scripts/check-workflow-contracts.py"
SKILLS = {
    "fb-ux": REPO_ROOT / "plugins/fb-ux/skills/fb-ux/SKILL.md",
    "apple-guidelines-stitch": REPO_ROOT
    / "plugins/apple-guidelines-stitch/skills/apple-guidelines-stitch/SKILL.md",
}

SHARED_MUTATIONS = {
    "guided mode": (
        "| **Guided** — recommended for a new project |",
        "| **Manual** — recommended for a new project |",
    ),
    "follow-recommendation mode": (
        "| **Follow recommendation** |",
        "| **Optional recommendation** |",
    ),
    "fully-automatic mode": (
        "| **Fully automatic** |",
        "| **Mostly automatic** |",
    ),
    "objective confirmation": (
        "In Guided or Follow recommendation mode, restate a stated objective concisely and ask the user to confirm or revise it.",
        "In Guided or Follow recommendation mode, accept a stated objective without confirmation.",
    ),
    "missing objective stop": (
        "If the objective is missing or materially ambiguous, stop and ask; never invent it.",
        "If the objective is missing or materially ambiguous, infer it and continue.",
    ),
    "one-run override precedence": (
        "1. An explicit one-run override in the current request.\n2. The saved value in",
        "1. The saved value in the project.\n2. An explicit one-run override in",
    ),
    "saved versus override provenance": (
        "never attribute the selection to the saved preference when an explicit one-run override is active.",
        "attribute the selection to the saved preference when an explicit one-run override is active.",
    ),
    "Guided Direction stop": (
        "In Guided mode, present directions, record the active mode and its provenance, and stop.",
        "In Guided mode, present directions and continue automatically.",
    ),
    "automatic Direction continuation": (
        "In Follow recommendation or Fully automatic mode, present the recommendation and alternatives, record that the active mode selected the recommendation",
        "In Follow recommendation or Fully automatic mode, stop before selecting the recommendation",
    ),
    "Fully automatic Stitch verdict": (
        "Fully automatic continues only when the verdict is `meets direction`; for either other verdict, stop with corrections or blockers.",
        "Fully automatic continues when the verdict is `meets with corrections`; only `does not meet` stops.",
    ),
}

APPLE_MUTATIONS = {
    "Android first-party precedence": (
        "For Android or web targets, current first-party platform rules override conflicting Apple-inspired judgment.",
        "For Android targets, Apple-inspired judgment overrides conflicting first-party platform rules.",
    ),
    "web first-party precedence": (
        "For Android or web targets, current first-party platform rules override conflicting Apple-inspired judgment.",
        "For web targets, Apple-inspired judgment overrides conflicting first-party platform rules.",
    ),
}


def run_checker(fb_skill: Path, apple_skill: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [
            sys.executable,
            str(CHECKER),
            "--fb-ux",
            str(fb_skill),
            "--apple-guidelines-stitch",
            str(apple_skill),
        ],
        capture_output=True,
        text=True,
        check=False,
    )


def mutated_text(original: str, old: str, new: str, label: str) -> str:
    count = original.count(old)
    if count == 0:
        raise AssertionError(f"mutation fixture for {label!r} no longer matches the source contract")
    return original.replace(old, new)


def main() -> int:
    original = {name: path.read_text(encoding="utf-8") for name, path in SKILLS.items()}

    baseline = run_checker(SKILLS["fb-ux"], SKILLS["apple-guidelines-stitch"])
    if baseline.returncode != 0:
        sys.stderr.write(baseline.stdout + baseline.stderr)
        raise AssertionError("current instruction contracts must pass the deterministic checker")
    print("PASS: current deterministic instruction contracts")

    with tempfile.TemporaryDirectory(prefix="workflow-contract-mutations.") as temp_dir_name:
        temp_dir = Path(temp_dir_name)
        for skill_name, skill_text in original.items():
            for label, (old, new) in SHARED_MUTATIONS.items():
                mutated_paths = {
                    name: temp_dir / f"{name}.md" for name in SKILLS
                }
                for name, path in mutated_paths.items():
                    text = original[name]
                    if name == skill_name:
                        text = mutated_text(text, old, new, f"{skill_name}: {label}")
                    path.write_text(text, encoding="utf-8")

                result = run_checker(
                    mutated_paths["fb-ux"],
                    mutated_paths["apple-guidelines-stitch"],
                )
                if result.returncode == 0:
                    raise AssertionError(
                        f"checker accepted reversed or missing contract: {skill_name}: {label}"
                    )
                print(f"PASS: rejected mutation for {skill_name}: {label}")

        for label, (old, new) in APPLE_MUTATIONS.items():
            fb_path = temp_dir / "fb-ux.md"
            apple_path = temp_dir / "apple-guidelines-stitch.md"
            fb_path.write_text(original["fb-ux"], encoding="utf-8")
            apple_path.write_text(
                mutated_text(
                    original["apple-guidelines-stitch"], old, new, label
                ),
                encoding="utf-8",
            )
            result = run_checker(fb_path, apple_path)
            if result.returncode == 0:
                raise AssertionError(
                    f"checker accepted reversed Apple-only contract: {label}"
                )
            print(f"PASS: rejected Apple-only mutation: {label}")

    print("PASS: deterministic instruction-contract mutation cases")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
