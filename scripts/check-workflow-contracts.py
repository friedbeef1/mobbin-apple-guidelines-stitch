#!/usr/bin/env python3
"""Check deterministic contracts encoded by the two skill instruction files.

This validates instruction contracts only. It does not execute or simulate an agent.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_FB_UX = REPO_ROOT / "plugins/fb-ux/skills/fb-ux/SKILL.md"
DEFAULT_APPLE = (
    REPO_ROOT
    / "plugins/apple-guidelines-stitch/skills/apple-guidelines-stitch/SKILL.md"
)

SHARED_CONTRACTS = {
    "all valid approval modes": (
        "The only valid values are `guided`, `follow-recommendation`, and `fully-automatic`.",
    ),
    "Guided mode behavior": (
        "| **Guided** — recommended for a new project | Stop to confirm | Stop | Stop |",
        "In Guided mode, present directions, record the active mode and its provenance, and stop.",
    ),
    "Follow recommendation behavior": (
        "| **Follow recommendation** | Stop to confirm | Continue with the recommended direction | Stop |",
        "In Follow recommendation or Fully automatic mode, present the recommendation and alternatives, record that the active mode selected the recommendation",
    ),
    "Fully automatic behavior": (
        "| **Fully automatic** | Continue with an explicit current-request objective; otherwise clarify | Continue with the recommended direction | Continue only after a `meets direction` verdict |",
        "Fully automatic continues only when the verdict is `meets direction`; for either other verdict, stop with corrections or blockers.",
    ),
    "objective confirmation": (
        "In Guided or Follow recommendation mode, restate a stated objective concisely and ask the user to confirm or revise it.",
    ),
    "missing objective handling": (
        "If the objective is missing or materially ambiguous, stop and ask; never invent it.",
    ),
    "one-run mode precedence": (
        "1. An explicit one-run override in the current request.",
        "2. The saved value in",
        "A request such as `use Guided for this run` is a one-run override and does not rewrite the saved preference.",
    ),
    "active-mode provenance": (
        "Also state whether that active mode came from the saved project preference, an explicit one-run override, or first-use/default selection.",
        "never attribute the selection to the saved preference when an explicit one-run override is active.",
    ),
}

APPLE_ONLY_CONTRACTS = {
    "Android and web first-party precedence": (
        "For Android or web targets, current first-party platform rules override conflicting Apple-inspired judgment.",
    ),
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Check deterministic workflow contracts in both skill instructions."
    )
    parser.add_argument("--fb-ux", type=Path, default=DEFAULT_FB_UX)
    parser.add_argument(
        "--apple-guidelines-stitch", type=Path, default=DEFAULT_APPLE
    )
    return parser.parse_args()


def require_contracts(
    skill_name: str, text: str, contracts: dict[str, tuple[str, ...]]
) -> list[str]:
    failures = []
    for label, required_fragments in contracts.items():
        missing = [fragment for fragment in required_fragments if fragment not in text]
        if missing:
            failures.append(f"{skill_name}: missing or reversed {label} contract")
    return failures


def main() -> int:
    args = parse_args()
    skill_paths = {
        "FB UX": args.fb_ux,
        "Apple Guidelines + Stitch": args.apple_guidelines_stitch,
    }
    failures = []
    skill_text = {}
    for name, path in skill_paths.items():
        try:
            skill_text[name] = path.read_text(encoding="utf-8")
        except OSError as error:
            failures.append(f"{name}: cannot read instruction contract: {error}")

    for name, text in skill_text.items():
        failures.extend(require_contracts(name, text, SHARED_CONTRACTS))
    if "Apple Guidelines + Stitch" in skill_text:
        failures.extend(
            require_contracts(
                "Apple Guidelines + Stitch",
                skill_text["Apple Guidelines + Stitch"],
                APPLE_ONLY_CONTRACTS,
            )
        )

    if failures:
        for failure in failures:
            print(f"FAIL: {failure}", file=sys.stderr)
        return 1

    print(
        "PASS: deterministic instruction-contract checks for FB UX and "
        "Apple Guidelines + Stitch"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
