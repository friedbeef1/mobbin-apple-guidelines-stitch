#!/usr/bin/env python3
"""Delegate repository graph validation to the packaged Design Arc CLI."""

import os
import sys
from pathlib import Path


CANONICAL_VALIDATOR = (
    Path(__file__).resolve().parent.parent
    / "plugins"
    / "design-arc"
    / "skills"
    / "design-arc"
    / "scripts"
    / "validate-graph-record.py"
)


def main() -> None:
    os.execv(
        sys.executable,
        [sys.executable, str(CANONICAL_VALIDATOR), *sys.argv[1:]],
    )


if __name__ == "__main__":
    main()
