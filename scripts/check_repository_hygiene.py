#!/usr/bin/env python3
"""Reject tracked internal records and Design Arc-owned project state."""

from __future__ import annotations

import argparse
from pathlib import Path, PurePosixPath
import subprocess
import sys
from typing import Iterable


FORBIDDEN_DIRECTORY_PREFIXES = (
    ".superpowers",
    "docs/superpowers",
    "docs/handoffs",
    "docs/retrospectives",
    "docs/validation",
    "docs/release-drafts",
)

FORBIDDEN_EXACT_PATHS = {
    "docs/openai-plugin-directory-submission.md",
}

DESIGN_ARC_STATE_PREFIXES = (
    ".codex/design-arc",
    ".claude/design-arc",
    ".gemini/design-arc",
)


def normalize_path(raw_path: str) -> str:
    path = PurePosixPath(raw_path.replace("\\", "/"))
    normalized = path.as_posix()
    while normalized.startswith("./"):
        normalized = normalized[2:]
    return normalized


def forbidden_reason(raw_path: str) -> str | None:
    path = normalize_path(raw_path)
    if path in FORBIDDEN_EXACT_PATHS:
        return "internal release submission draft"

    for prefix in FORBIDDEN_DIRECTORY_PREFIXES:
        if path == prefix or path.startswith(f"{prefix}/"):
            return f"internal repository record under {prefix}/"

    for prefix in DESIGN_ARC_STATE_PREFIXES:
        if path.startswith(prefix):
            return f"Design Arc-owned project state matching {prefix}*"

    return None


def tracked_paths(repo_root: Path) -> tuple[str, ...]:
    result = subprocess.run(
        ["git", "-C", str(repo_root), "ls-files", "-z"],
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    return tuple(path.decode("utf-8") for path in result.stdout.split(b"\0") if path)


def find_forbidden(paths: Iterable[str]) -> list[tuple[str, str]]:
    findings: list[tuple[str, str]] = []
    for path in paths:
        reason = forbidden_reason(path)
        if reason is not None:
            findings.append((normalize_path(path), reason))
    return sorted(findings)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--repo-root",
        type=Path,
        default=Path(__file__).resolve().parent.parent,
        help="Git repository to inspect (defaults to this script's repository)",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    repo_root = args.repo_root.resolve()
    try:
        findings = find_forbidden(tracked_paths(repo_root))
    except (OSError, subprocess.CalledProcessError) as error:
        print(f"FAIL: unable to inspect tracked repository paths: {error}", file=sys.stderr)
        return 1

    if findings:
        print("FAIL: forbidden internal or Design Arc state paths are tracked:", file=sys.stderr)
        for path, reason in findings:
            print(f"  {path}: {reason}", file=sys.stderr)
        return 1

    print("PASS: tracked repository paths contain no internal records or Design Arc project state")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
