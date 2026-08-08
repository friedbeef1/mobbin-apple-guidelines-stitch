#!/usr/bin/env python3
"""Exercise the graph-record validator through its public CLI."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parent.parent
FIXTURES = REPO_ROOT / "scripts" / "fixtures" / "graph-records"
VALIDATOR = (
    REPO_ROOT
    / "plugins"
    / "design-arc"
    / "skills"
    / "design-arc"
    / "scripts"
    / "validate-graph-record.py"
)
REPOSITORY_ENTRYPOINT = REPO_ROOT / "scripts" / "validate-graph-record.py"
EXPECTED_PROJECT_ID = "project-alpha"
EXPECTED_REVIEW_ID = "review-001"


def fail(message: str, output: str = "") -> None:
    print(f"FAIL: {message}", file=sys.stderr)
    if output:
        print(output, file=sys.stderr, end="" if output.endswith("\n") else "\n")
    raise SystemExit(1)


def run_fixture(name: str, project_id: str = EXPECTED_PROJECT_ID, review_id: str = EXPECTED_REVIEW_ID) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["python3", str(VALIDATOR), str(FIXTURES / name), project_id, review_id],
        text=True,
        capture_output=True,
        check=False,
    )


def expect_valid(name: str) -> None:
    result = run_fixture(name)
    if result.returncode != 0:
        fail(f"valid fixture {name} was rejected", result.stderr)
    print(f"PASS: accepted valid fixture {name}")


def expect_invalid(name: str, reason: str) -> None:
    result = run_fixture(name)
    if result.returncode == 0:
        fail(f"invalid fixture {name} was accepted")
    if reason not in result.stderr:
        fail(f"invalid fixture {name} failed for the wrong reason", result.stderr)
    print(f"PASS: rejected {name} ({reason})")


def main() -> int:
    if not VALIDATOR.is_file():
        fail("packaged graph-record validator is absent; expected RED state")
    if not REPOSITORY_ENTRYPOINT.is_file():
        fail("repository graph-record entrypoint is absent")

    packaged_valid = run_fixture("valid.json")
    repository_valid = subprocess.run(
        [
            "python3",
            str(REPOSITORY_ENTRYPOINT),
            str(FIXTURES / "valid.json"),
            EXPECTED_PROJECT_ID,
            EXPECTED_REVIEW_ID,
        ],
        text=True,
        capture_output=True,
        check=False,
    )
    if repository_valid.returncode != packaged_valid.returncode:
        fail("repository graph entrypoint diverges from packaged validator")
    if repository_valid.stdout != packaged_valid.stdout or repository_valid.stderr != packaged_valid.stderr:
        fail("repository graph entrypoint output diverges from packaged validator")
    print("PASS: repository graph entrypoint delegates to packaged validator")

    expect_valid("valid.json")
    expect_invalid("corrupt.json", "invalid JSON")
    expect_invalid("incomplete-required-fields.json", "missing required field: observed_at")
    expect_invalid("unsupported-schema.json", "unsupported schema")
    expect_invalid("unsupported-node-type.json", "unsupported node type")
    expect_invalid("unsupported-edge-type.json", "unsupported edge type")
    expect_invalid("unsupported-provenance.json", "unsupported provenance kind")
    expect_invalid("duplicate-ids.json", "duplicate node id")
    expect_invalid("missing-endpoint.json", "missing endpoint")
    expect_invalid("unproven-relationship.json", "unproven relationship")
    expect_invalid("contradictory-active-relationships.json", "contradictory active relationships")
    expect_invalid(
        "reverse-direction-contradictory-active-relationships.json",
        "contradictory active relationships",
    )

    wrong_project = run_fixture("valid.json", project_id="other-project")
    if wrong_project.returncode == 0 or "project_id does not match expected project id" not in wrong_project.stderr:
        fail("wrong project identity was accepted or failed ambiguously", wrong_project.stderr)
    print("PASS: rejected wrong project identity")

    wrong_review = run_fixture("valid.json", review_id="other-review")
    if wrong_review.returncode == 0 or "review_id does not match expected review id" not in wrong_review.stderr:
        fail("wrong review identity was accepted or failed ambiguously", wrong_review.stderr)
    print("PASS: rejected wrong review identity")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
