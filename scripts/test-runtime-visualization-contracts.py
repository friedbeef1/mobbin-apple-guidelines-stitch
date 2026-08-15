#!/usr/bin/env python3
"""Behavioral contracts for runtime-specific Design Arc visualization advice."""

from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parent.parent
CODEX_SKILL = REPO_ROOT / "plugins/design-arc/skills/design-arc/SKILL.md"
CLAUDE_SKILL = REPO_ROOT / "claude-plugins/design-arc/skills/design-arc/SKILL.md"


def require(source: str, fragment: str, label: str) -> None:
    if fragment not in source:
        raise AssertionError(f"missing {label}: {fragment}")


def reject(source: str, fragment: str, label: str) -> None:
    if fragment in source:
        raise AssertionError(f"forbidden {label}: {fragment}")


def test_codex_visualization_contract() -> None:
    source = CODEX_SKILL.read_text(encoding="utf-8")
    require(source, "Create static screen images and complete journey boards directly in Codex by default.", "Codex default")
    require(source, "canvas-based editing, multiple visual alternatives, and sustained visual refinement", "Stitch benefits")
    require(source, "Recommend Stitch when those benefits materially help the review", "optional recommendation")
    require(source, "Stitch remains optional and separately authorized.", "optional authorization")
    reject(source, "Stitch is mandatory", "mandatory Stitch")


def test_claude_visualization_contract() -> None:
    source = CLAUDE_SKILL.read_text(encoding="utf-8")
    require(source, "Never claim native image-generation capability in Claude Code.", "native-image disclaimer")
    require(source, "HTML/CSS, SVG, specifications, and lightweight static journey boards", "Claude outputs")
    require(source, "prepare a lightweight static journey board with HTML/CSS, SVG, or specifications", "Claude default route")
    require(source, "polished screen mockups, visual exploration, editable layouts, or continued visual refinement", "early Stitch triggers")
    require(source, "Do not withhold the Stitch recommendation when polished or editable mockups are requested.", "no withheld Stitch recommendation")
    require(
        source,
        "Claude can prepare a lightweight static journey board here. For polished, editable screen mockups, I recommend a Stitch-ready visual proposal. Which would you prefer?",
        "required Claude decision prompt",
    )
    require(source, "Never tell a Claude Code user to pass work to Codex unless the user explicitly requests a cross-platform handoff.", "no default Codex handoff")
    reject(source, "Generate one complete static journey board in Claude Code by default", "false native default")
    reject(source, "Claude Code can generate images natively", "native image-generation claim")
    reject(source, "Generate static screen images directly in Claude Code", "native screen-generation claim")
    reject(source, "pass work to Codex by default", "default Codex handoff")


def test_shared_stitch_validation_contract() -> None:
    for path in (CODEX_SKILL, CLAUDE_SKILL):
        source = path.read_text(encoding="utf-8")
        require(source, "Before using Stitch, prepare the complete evidence-grounded journey, requirements, and important-state inventory.", "Stitch preparation")
        require(source, "Stitch is a visualization tool, not an evidence authority.", "Stitch evidence boundary")
        require(source, "up to three correction rounds", "three-round active-host validation")


def main() -> int:
    test_codex_visualization_contract()
    print("PASS: Codex visualization contract")
    test_claude_visualization_contract()
    print("PASS: Claude visualization contract")
    test_shared_stitch_validation_contract()
    print("PASS: shared Stitch preparation and validation contract")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
