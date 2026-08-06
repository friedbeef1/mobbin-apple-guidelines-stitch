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
    "implementation boundary": (
        "Design approval never authorizes source implementation, staging, live deployment, release, destructive changes, provider changes, or work outside the authorized integration lane.",
        "Design approval authorizes implementation and live deployment.",
    ),
}


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

    print(f"PASS: rejected {len(MUTATIONS)} deterministic contract mutations")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
