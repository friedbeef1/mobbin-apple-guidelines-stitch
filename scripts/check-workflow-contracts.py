#!/usr/bin/env python3
"""Check deterministic contracts encoded by the Design Arc skill.

This validator checks the written instruction contract. It does not execute or
simulate an agent; fresh-context scenarios provide separate behavioral evidence.
"""

from __future__ import annotations

import argparse
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
}


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

    if failures:
        for failure in failures:
            print(f"FAIL: Design Arc: {failure}", file=sys.stderr)
        return 1

    print("PASS: deterministic Design Arc instruction contracts")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
