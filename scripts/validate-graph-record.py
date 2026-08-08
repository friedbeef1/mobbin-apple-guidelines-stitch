#!/usr/bin/env python3
"""Validate a usable, project-local Design Arc graph record."""

from __future__ import annotations

import json
import sys
from datetime import datetime
from pathlib import Path
from typing import Any


SCHEMA_ID = "design-arc.graph/v1"
NODE_TYPES = {
    "confirmed_objective",
    "evidence_source",
    "platform_requirement",
    "design_decision",
    "journey",
    "screen",
    "state",
    "transition",
    "stitch_render",
    "observed_mismatch",
    "correction",
    "approval",
    "exception",
}
EDGE_TYPES = {
    "supports",
    "requires",
    "applies_to",
    "conflicts_with",
    "depends_on",
    "rendered_as",
    "corrected_by",
    "supersedes",
    "approved_by",
}
PROVENANCE_KINDS = {
    "inspected_evidence",
    "official_guidance",
    "user_confirmed_objective",
    "design_arc_judgment",
}
ROOT_FIELDS = {"schema", "project_id", "review_id", "nodes", "edges"}
NODE_FIELDS = {"id", "type", "label"}
EDGE_FIELDS = {
    "id",
    "type",
    "from",
    "to",
    "active",
    "provenance_kind",
    "source_ref",
    "observed_at",
    "support_status",
}


class ValidationError(Exception):
    """A graph record is invalid and must not be repaired by this validator."""


def fail(message: str) -> None:
    raise ValidationError(message)


def require_object(value: Any, location: str) -> dict[str, Any]:
    if not isinstance(value, dict):
        fail(f"{location} must be an object")
    return value


def require_nonempty_string(value: Any, field: str) -> str:
    if not isinstance(value, str) or not value:
        fail(f"{field} must be a non-empty string")
    return value


def require_fields(value: dict[str, Any], fields: set[str], location: str) -> None:
    for field in sorted(fields):
        if field not in value:
            fail(f"missing required field: {field}")
    unexpected = sorted(set(value) - fields)
    if unexpected:
        fail(f"unexpected field in {location}: {unexpected[0]}")


def require_timestamp(value: Any, field: str) -> None:
    timestamp = require_nonempty_string(value, field)
    if not timestamp.endswith("Z"):
        fail(f"{field} must be an ISO 8601 UTC timestamp")
    try:
        datetime.fromisoformat(timestamp.replace("Z", "+00:00"))
    except ValueError:
        fail(f"{field} must be an ISO 8601 UTC timestamp")


def validate_record(record: Any, expected_project_id: str, expected_review_id: str) -> None:
    root = require_object(record, "record")
    require_fields(root, ROOT_FIELDS, "record")

    schema_id = require_nonempty_string(root["schema"], "schema")
    if schema_id != SCHEMA_ID:
        fail(f"unsupported schema: {schema_id!r}")
    if require_nonempty_string(root["project_id"], "project_id") != expected_project_id:
        fail("project_id does not match expected project id")
    if require_nonempty_string(root["review_id"], "review_id") != expected_review_id:
        fail("review_id does not match expected review id")
    if not isinstance(root["nodes"], list):
        fail("nodes must be an array")
    if not isinstance(root["edges"], list):
        fail("edges must be an array")

    identifiers: set[str] = set()
    node_ids: set[str] = set()
    for index, raw_node in enumerate(root["nodes"]):
        node = require_object(raw_node, f"nodes[{index}]")
        require_fields(node, NODE_FIELDS, f"nodes[{index}]")
        node_id = require_nonempty_string(node["id"], f"nodes[{index}].id")
        if node_id in identifiers:
            fail(f"duplicate node id: {node_id}")
        identifiers.add(node_id)
        node_ids.add(node_id)
        node_type = require_nonempty_string(node["type"], f"nodes[{index}].type")
        if node_type not in NODE_TYPES:
            fail(f"unsupported node type: {node_type!r}")
        require_nonempty_string(node["label"], f"nodes[{index}].label")

    active_relationships: dict[tuple[str, str], set[str]] = {}
    for index, raw_edge in enumerate(root["edges"]):
        edge = require_object(raw_edge, f"edges[{index}]")
        require_fields(edge, EDGE_FIELDS, f"edges[{index}]")
        edge_id = require_nonempty_string(edge["id"], f"edges[{index}].id")
        if edge_id in identifiers:
            fail(f"duplicate edge id: {edge_id}")
        identifiers.add(edge_id)
        edge_type = require_nonempty_string(edge["type"], f"edges[{index}].type")
        if edge_type not in EDGE_TYPES:
            fail(f"unsupported edge type: {edge_type!r}")
        source_id = require_nonempty_string(edge["from"], f"edges[{index}].from")
        target_id = require_nonempty_string(edge["to"], f"edges[{index}].to")
        if source_id not in node_ids or target_id not in node_ids:
            fail(f"missing endpoint for edge: {edge_id}")
        if not isinstance(edge["active"], bool):
            fail(f"edges[{index}].active must be a boolean")
        provenance_kind = require_nonempty_string(edge["provenance_kind"], f"edges[{index}].provenance_kind")
        if provenance_kind not in PROVENANCE_KINDS:
            fail(f"unsupported provenance kind: {provenance_kind!r}")
        require_nonempty_string(edge["source_ref"], f"edges[{index}].source_ref")
        require_timestamp(edge["observed_at"], f"edges[{index}].observed_at")
        if edge["support_status"] != "supported":
            fail(f"unproven relationship: {edge_id}")
        if edge["active"]:
            relationship = (source_id, target_id)
            active_types = active_relationships.setdefault(relationship, set())
            if edge_type == "conflicts_with" and active_types - {"conflicts_with"}:
                fail(f"contradictory active relationships: {source_id} -> {target_id}")
            if edge_type != "conflicts_with" and "conflicts_with" in active_types:
                fail(f"contradictory active relationships: {source_id} -> {target_id}")
            active_types.add(edge_type)


def load_record(graph_path: Path) -> Any:
    try:
        return json.loads(graph_path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        fail(f"graph record does not exist: {graph_path}")
    except UnicodeDecodeError:
        fail("graph record is not UTF-8 text")
    except json.JSONDecodeError as error:
        fail(f"invalid JSON: {error.msg}")


def main(argv: list[str]) -> int:
    if len(argv) != 4:
        print(
            "usage: python3 scripts/validate-graph-record.py GRAPH_PATH EXPECTED_PROJECT_ID EXPECTED_REVIEW_ID",
            file=sys.stderr,
        )
        return 2
    graph_path = Path(argv[1])
    expected_project_id = argv[2]
    expected_review_id = argv[3]
    try:
        validate_record(load_record(graph_path), expected_project_id, expected_review_id)
    except ValidationError as error:
        print(f"FAIL: {error}", file=sys.stderr)
        return 1
    print(f"PASS: usable graph record {graph_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
