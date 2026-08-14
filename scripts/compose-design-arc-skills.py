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


def composition(platform: str) -> bytes:
    details = PLATFORMS[platform]
    overlay = details["overlay"].read_text(encoding="utf-8").rstrip("\n")
    methodology = METHODOLOGY.read_text(encoding="utf-8").lstrip("\n")
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
