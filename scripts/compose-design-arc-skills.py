#!/usr/bin/env python3
"""Compose deterministic, self-contained Design Arc skill artifacts."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parent.parent
SHARED_ROOT = REPO_ROOT / "shared/design-arc"
METHODOLOGY = SHARED_ROOT / "methodology.md"
VERSION_FILE = SHARED_ROOT / "VERSION"

PLATFORMS = {
    "codex": {
        "overlay": SHARED_ROOT / "overlays/codex.md",
        "output": REPO_ROOT / "plugins/design-arc/skills/design-arc/SKILL.md",
        "package_root": REPO_ROOT / "plugins/design-arc",
        "manifest": REPO_ROOT / "plugins/design-arc/.codex-plugin/plugin.json",
    },
    "claude": {
        "overlay": SHARED_ROOT / "overlays/claude.md",
        "output": REPO_ROOT / "claude-plugins/design-arc/skills/design-arc/SKILL.md",
        "package_root": REPO_ROOT / "claude-plugins/design-arc",
        "manifest": REPO_ROOT / "claude-plugins/design-arc/.claude-plugin/plugin.json",
    },
}


def relative(path: Path) -> str:
    return path.relative_to(REPO_ROOT).as_posix()


def without_section(markdown: str, start: str, end: str) -> str:
    """Remove one complete heading-delimited section from a packaged adapter."""
    pattern = re.compile(
        rf"(?ms)^{re.escape(start)}\n.*?(?=^{re.escape(end)}\n)"
    )
    rendered, count = pattern.subn("", markdown, count=1)
    if count != 1:
        raise ValueError(f"missing shared methodology section: {start}")
    return rendered


def methodology_for(platform: str) -> str:
    methodology = METHODOLOGY.read_text(encoding="utf-8").lstrip("\n")
    if platform == "codex":
        return methodology

    # Claude reuses the canonical journey methodology, but the Codex-only
    # upgrade, project-home, and legacy-import sections are not executable in
    # Claude Code. Claude-specific equivalents live in the Claude overlay.
    for start, end in (
        ("### Safe plugin upgrade", "### Project home"),
        ("### Project home", "### Resolution precedence"),
        ("### Legacy preference import", "### The six valid combinations"),
    ):
        methodology = without_section(methodology, start, end)

    replacements = {
        "Store project-scoped choices in `.codex/design-arc.yaml`:":
            "Store project-scoped choices in `.claude/design-arc.yaml`:",
        "- `$design-arc home` — report, create, recover, or repin this project's Design Arc home under the confirmation and deduplication rules below.\n": "",
        "- `$design-arc upgrade` — safely upgrade the laptop/profile plugin while preserving every project's preferences, home, files, and active work.":
            "- `$design-arc upgrade` — safely upgrade the Claude Code plugin while preserving preferences, reminders, reviews, graphs, product files, and active sessions.",
        "Treat Design Arc as directly invoked when the current request includes `$design-arc`, explicitly asks to use Design Arc by name, or is a journey starter submitted inside a confirmed Design Arc home.":
            "Treat Design Arc as directly invoked when the current request includes `/design-arc:design-arc` or explicitly asks to use Design Arc by name.",
        "If Codex has selected this skill for a suitable request that did not directly invoke Design Arc":
            "If Claude Code has selected this skill for a suitable request that did not directly invoke Design Arc",
        "create preferences, create a project home, or write review records":
            "create preferences or write review records",
        "Saved `.codex/design-arc.yaml` value.":
            "Saved `.claude/design-arc.yaml` value.",
        "Confirmed legacy import, only when the new file is absent.":
            "Confirmed Codex preference import, only when the Claude file is absent.",
        "confirmed legacy import, or first-use selection":
            "confirmed Codex preference import, or first-use selection",
        "in that project's `.codex/design-arc.yaml`; keep laptop-global graph safety state isolated under the active Codex profile":
            "in that project's `.claude/design-arc.yaml`; keep laptop-global graph safety state isolated under the active Claude Code profile",
        "shared by this Codex installation":
            "shared by this Claude Code installation",
        "$CODEX_HOME/design-arc-global.yaml":
            "$CLAUDE_CONFIG_DIR/design-arc-global.yaml",
        "do not rewrite `.codex/design-arc.yaml`, laptop-global safety state, or `design_arc_home` metadata merely because a review resolved them":
            "do not rewrite `.claude/design-arc.yaml` or laptop-global safety state merely because a review resolved them",
        "Store each record only at `.codex/design-arc/reviews/<review_id>/graph.json`":
            "Store each record only at `.claude/design-arc/reviews/<review_id>/graph.json`",
        "preserves the review ID, workflow version, project preference, home metadata, and product files":
            "preserves the review ID, workflow version, project preference, and product files",
        "it never clears preferences, homes, product files, other reviews, or other projects":
            "it never clears preferences, product files, other reviews, or other projects",
        "must preserve project preferences, homes, active review identity/version records, graph files, and product files":
            "must preserve project preferences, reminder blocks, active review identity/version records, graph files, and product files",
        "Generate one complete static journey board in Codex by default":
            "Generate one complete static journey board in Claude Code by default",
        "bounded image revisions in Codex":
            "bounded image revisions in Claude Code",
        "after one Codex correction round":
            "after one Claude Code correction round",
        "I can continue in Codex if you prefer.":
            "I can continue in Claude Code if you prefer.",
        "continuing in Codex remains available. Treat `stay in Codex`":
            "continuing in Claude Code remains available. Treat `stay in Claude Code`",
        "For the default Codex route":
            "For the default Claude Code route",
        "Return decision-ready evidence in Codex":
            "Return decision-ready evidence in Claude Code",
        "Report these fields in the Codex conversation":
            "Report these fields in the Claude Code conversation",
    }
    for original, replacement in replacements.items():
        if original not in methodology:
            raise ValueError(f"missing Claude methodology adaptation source: {original}")
        methodology = methodology.replace(original, replacement, 1)
    methodology = methodology.replace(
        "$CODEX_HOME/design-arc-global.yaml",
        "$CLAUDE_CONFIG_DIR/design-arc-global.yaml",
    )
    return methodology.replace("$design-arc", "/design-arc:design-arc")


def composition(platform: str) -> bytes:
    details = PLATFORMS[platform]
    overlay = details["overlay"].read_text(encoding="utf-8").rstrip("\n")
    methodology = methodology_for(platform)
    return f"{overlay}\n\n{methodology}".encode("utf-8")


def external_references(skill: str, package_root: Path) -> list[str]:
    references: set[str] = set()
    for candidate in re.findall(r"(?<!\S)(?:/|~|\.\./)[^\s`)>]+", skill):
        references.add(candidate)
    skill_root = package_root / "skills/design-arc"
    for candidate in re.findall(r"\]\(([^)]+)\)", skill):
        target = candidate.split("#", 1)[0].strip()
        if not target or re.match(r"[A-Za-z][A-Za-z0-9+.-]*:", target):
            continue
        if not (skill_root / target).resolve().is_relative_to(package_root.resolve()):
            references.add(target)
    for candidate in re.findall(r"(?<![A-Za-z0-9_.-])(?:scripts|references)/[^\s`)>]+", skill):
        resolved = (skill_root / candidate).resolve()
        if not resolved.is_relative_to(package_root.resolve()) or not resolved.is_file():
            references.add(candidate)
    return sorted(references)


def release_version() -> str:
    version = VERSION_FILE.read_text(encoding="utf-8").strip()
    if not re.fullmatch(r"\d+\.\d+\.\d+", version):
        raise ValueError("shared/design-arc/VERSION must contain one semantic version")
    return version


def check(platform: str) -> dict[str, object]:
    details = PLATFORMS[platform]
    output = details["output"]
    if not output.is_file():
        raise ValueError(f"missing generated {platform} skill: {relative(output)}")
    expected = composition(platform)
    if output.read_bytes() != expected:
        raise ValueError(f"stale generated {platform} skill: {relative(output)}")

    version = release_version()
    manifest = details["manifest"]
    if manifest.is_file():
        manifest_version = json.loads(manifest.read_text(encoding="utf-8")).get("version")
        if manifest_version != version:
            raise ValueError(
                f"{relative(manifest)} version {manifest_version!r} does not match {version!r}"
            )

    references = external_references(output.read_text(encoding="utf-8"), details["package_root"])
    if references:
        raise ValueError(
            f"{platform} generated skill references outside its package root: {', '.join(references)}"
        )
    return {"platform": platform, "version": version, "external_references": references}


def parser() -> argparse.ArgumentParser:
    argument_parser = argparse.ArgumentParser(description=__doc__)
    argument_parser.add_argument("--platform", choices=sorted(PLATFORMS), required=True)
    output_actions = argument_parser.add_mutually_exclusive_group()
    output_actions.add_argument("--output", type=Path)
    output_actions.add_argument("--write", action="store_true")
    output_actions.add_argument("--check", action="store_true")
    output_actions.add_argument("--describe", action="store_true")
    return argument_parser


def main() -> int:
    args = parser().parse_args()
    details = PLATFORMS[args.platform]
    if args.describe:
        print(
            json.dumps(
                {
                    "platform": args.platform,
                    "methodology": relative(METHODOLOGY),
                    "overlay": relative(details["overlay"]),
                    "output": relative(details["output"]),
                    "package_root": relative(details["package_root"]),
                },
                sort_keys=True,
            )
        )
        return 0
    try:
        if args.check:
            print(json.dumps(check(args.platform), sort_keys=True))
            return 0
        output = details["output"] if args.write else args.output
        if output is None:
            parser().error("choose --output, --write, --check, or --describe")
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_bytes(composition(args.platform))
        return 0
    except (OSError, ValueError, json.JSONDecodeError) as error:
        print(f"FAIL: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
