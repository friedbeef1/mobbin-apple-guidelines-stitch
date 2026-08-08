#!/usr/bin/env python3
"""State assertions for the isolated Design Arc upgrade integration test."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys


PLUGIN_ID = "design-arc@design-arc-marketplace"
PLUGIN_NAME = "design-arc"
MARKETPLACE = "design-arc-marketplace"


def fail(message: str) -> None:
    raise SystemExit(f"FAIL: {message}")


def require(condition: bool, message: str) -> None:
    if not condition:
        fail(message)


def read_json(path: Path) -> object:
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path: Path, value: object) -> None:
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def normalized(path: Path | str) -> str:
    return str(Path(path).resolve())


def tree_snapshot(root: Path) -> dict[str, dict[str, object]]:
    require(root.is_dir(), f"plugin tree is missing: {root}")
    snapshot: dict[str, dict[str, object]] = {}
    for path in sorted(root.rglob("*")):
        relative = path.relative_to(root).as_posix()
        mode = os.lstat(path).st_mode & 0o777
        if path.is_symlink():
            snapshot[relative] = {
                "type": "symlink",
                "mode": mode,
                "target": os.readlink(path),
            }
        elif path.is_dir():
            snapshot[relative] = {"type": "directory", "mode": mode}
        elif path.is_file():
            snapshot[relative] = {
                "type": "file",
                "mode": mode,
                "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
            }
        else:
            fail(f"unsupported plugin tree entry: {path}")
    return snapshot


def project_snapshot(root: Path) -> dict[str, object]:
    files = {
        path.relative_to(root).as_posix(): hashlib.sha256(path.read_bytes()).hexdigest()
        for path in sorted(root.rglob("*"))
        if path.is_file()
    }
    preferences = sorted(root.glob("*/.codex/design-arc.yaml"))
    home_thread_ids: list[str] = []
    home_states: list[str] = []
    for path in preferences:
        text = path.read_text(encoding="utf-8")
        thread_match = re.search(r"(?m)^  thread_id: (.+)$", text)
        state_match = re.search(r"(?m)^  state: (.+)$", text)
        if thread_match:
            home_thread_ids.append(thread_match.group(1))
        if state_match:
            home_states.append(state_match.group(1))

    review_paths = sorted(root.glob("*/.codex/design-arc-active-review.json"))
    reviews = [read_json(path) for path in review_paths]
    product_paths = sorted(root.glob("*/product/product-state.txt"))
    graph_paths = sorted(root.glob("*/.codex/design-arc/graphs/*.json"))
    return {
        "files": files,
        "participating_projects": [path.parents[1].name for path in preferences],
        "home_thread_ids": sorted(home_thread_ids),
        "home_states": sorted(home_states),
        "review_thread_ids": sorted(review["thread_id"] for review in reviews),
        "review_continuation_counts": [review["continuation_count"] for review in reviews],
        "review_workflow_versions": sorted(review["workflow_version"] for review in reviews),
        "product_sentinels": [path.relative_to(root).as_posix() for path in product_paths],
        "graph_records": [path.relative_to(root).as_posix() for path in graph_paths],
        "preferences_without_graph_fields": all(
            "graph_assistance" not in path.read_text(encoding="utf-8") for path in preferences
        ),
    }


def snapshot_projects(args: argparse.Namespace) -> None:
    write_json(args.output.resolve(), project_snapshot(args.projects.resolve()))


def assert_marketplace_source(item: dict[str, object], root: Path, label: str) -> str:
    source = item.get("marketplaceSource")
    require(isinstance(source, dict), f"{label} must report marketplaceSource")
    actual = source.get("source")
    require(source.get("sourceType") == "local", f"{label} marketplace source type must be local")
    require(isinstance(actual, str), f"{label} marketplace source must be a path")
    require(normalized(actual) == normalized(root), f"{label} marketplace source must match expected checkout")
    return normalized(actual)


def assert_plugin_item(item: object, version: str, source_root: Path, label: str) -> dict[str, object]:
    require(isinstance(item, dict), f"{label} must be an object")
    require(item.get("pluginId") == PLUGIN_ID, f"{label} plugin ID must be canonical")
    require(item.get("name") == PLUGIN_NAME, f"{label} plugin name must be canonical")
    require(item.get("marketplaceName") == MARKETPLACE, f"{label} marketplace name must be canonical")
    require(item.get("version") == version, f"{label} version must be {version}")
    require(item.get("enabled") is True, f"{label} must be enabled")
    require(item.get("installed") is True, f"{label} must report installed true")
    source = item.get("source")
    require(isinstance(source, dict), f"{label} must report plugin source")
    require(source.get("source") == "local", f"{label} plugin source type must be local")
    require(
        normalized(str(source.get("path", ""))) == normalized(source_root / "plugins/design-arc"),
        f"{label} plugin source path must match expected checkout",
    )
    assert_marketplace_source(item, source_root, label)
    return item


def assert_marketplaces(value: object, source_root: Path, label: str) -> str:
    require(isinstance(value, dict), f"{label} marketplace response must be an object")
    marketplaces = value.get("marketplaces")
    require(isinstance(marketplaces, list) and len(marketplaces) == 1, f"{label} must contain exactly one marketplace")
    marketplace = marketplaces[0]
    require(isinstance(marketplace, dict), f"{label} marketplace must be an object")
    require(marketplace.get("name") == MARKETPLACE, f"{label} marketplace name must be canonical")
    require(normalized(str(marketplace.get("root", ""))) == normalized(source_root), f"{label} marketplace root must match expected checkout")
    return assert_marketplace_source(marketplace, source_root, label)


def parsed_marketplace_source(value: object, label: str) -> Path:
    require(isinstance(value, dict), f"{label} marketplace response must be an object")
    marketplaces = value.get("marketplaces")
    require(isinstance(marketplaces, list) and len(marketplaces) == 1, f"{label} must contain exactly one marketplace")
    marketplace = marketplaces[0]
    require(isinstance(marketplace, dict), f"{label} marketplace must be an object")
    require(marketplace.get("name") == MARKETPLACE, f"{label} marketplace name must be canonical")
    source = marketplace.get("marketplaceSource")
    require(isinstance(source, dict), f"{label} must report marketplaceSource")
    require(source.get("sourceType") == "local", f"{label} marketplace source type must be local")
    actual = source.get("source")
    require(isinstance(actual, str), f"{label} marketplace source must be a path")
    parsed = Path(actual).resolve()
    require(parsed.is_dir(), f"{label} parsed marketplace source must exist")
    require(normalized(str(marketplace.get("root", ""))) == normalized(parsed), f"{label} marketplace root must equal parsed source")
    return parsed


def cache_roots(codex_home: Path) -> list[Path]:
    root = codex_home / "plugins/cache" / MARKETPLACE / PLUGIN_NAME
    if not root.exists():
        return []
    return sorted(path for path in root.iterdir() if path.is_dir())


def assert_exact_cache(codex_home: Path, source_root: Path, version: str, label: str) -> Path:
    roots = cache_roots(codex_home)
    require(len(roots) == 1, f"{label} must contain exactly one cached plugin version")
    cached_root = roots[0]
    require(cached_root.name == version, f"{label} cached version must be {version}")

    manifests = list((codex_home / "plugins/cache").glob(f"*/{PLUGIN_NAME}/*/.codex-plugin/plugin.json"))
    skills = list((codex_home / "plugins/cache").glob(f"*/{PLUGIN_NAME}/*/skills/design-arc/SKILL.md"))
    require(len(manifests) == 1, f"{label} must contain exactly one cached manifest")
    require(len(skills) == 1, f"{label} must contain exactly one cached Design Arc skill")
    require(manifests[0].is_relative_to(cached_root), f"{label} manifest must belong to the only cache root")
    require(skills[0].is_relative_to(cached_root), f"{label} skill must belong to the only cache root")

    manifest = read_json(manifests[0])
    require(isinstance(manifest, dict) and manifest.get("version") == version, f"{label} manifest version must be {version}")
    source_plugin = source_root / "plugins/design-arc"
    require(
        manifests[0].read_bytes() == (source_plugin / ".codex-plugin/plugin.json").read_bytes(),
        f"{label} cached manifest bytes must match immutable source",
    )
    require(
        tree_snapshot(cached_root) == tree_snapshot(source_plugin),
        f"{label} complete cached plugin tree must equal immutable source",
    )
    return cached_root


def assert_installed_state(state_path: Path, source_root: Path, version: str, label: str) -> dict[str, object]:
    state = read_json(state_path)
    require(isinstance(state, dict), f"{label} plugin state must be an object")
    installed = state.get("installed")
    require(isinstance(installed, list) and len(installed) == 1, f"{label} must contain exactly one installed plugin")
    item = assert_plugin_item(installed[0], version, source_root, label)
    require(state.get("available") == [], f"{label} must contain zero other available plugins")
    return item


def validate_baseline(args: argparse.Namespace) -> None:
    baseline = args.baseline.resolve()
    assert_installed_state(args.state, baseline, args.version, "fallback preflight")
    assert_marketplaces(read_json(args.marketplaces), baseline, "fallback preflight")
    assert_exact_cache(args.codex_home.resolve(), baseline, args.version, "fallback preflight")


def inject_preflight(args: argparse.Namespace) -> None:
    state = read_json(args.state)
    require(isinstance(state, dict), "preflight injection state must be an object")
    installed = state.get("installed")
    require(isinstance(installed, list) and len(installed) == 1, "preflight injection requires one installed plugin")
    if args.mode == "preflight-missing":
        state["installed"] = []
    elif args.mode == "preflight-disabled":
        installed[0]["enabled"] = False
    elif args.mode == "preflight-duplicate":
        installed.append(json.loads(json.dumps(installed[0])))
    elif args.mode == "preflight-unexpected-source":
        installed[0]["marketplaceSource"]["source"] = str(args.state.parent / "unexpected-source")
    elif args.mode == "preflight-cache-mismatch":
        roots = cache_roots(args.codex_home.resolve())
        require(len(roots) == 1, "cache mismatch injection requires one cache root")
        (roots[0] / "injected-unexpected-file.txt").write_text("unexpected\n", encoding="utf-8")
    else:
        fail(f"unsupported preflight injection: {args.mode}")
    write_json(args.state, state)


def validate_preflight_rejection(args: argparse.Namespace) -> None:
    baseline = args.baseline.resolve()
    assert_installed_state(args.actual_state, baseline, args.version, "preflight rejection")
    assert_marketplaces(read_json(args.actual_marketplaces), baseline, "preflight rejection")
    require(not args.plugin_remove_marker.exists(), "preflight rejection must not execute plugin removal")
    require(not args.marketplace_remove_marker.exists(), "preflight rejection must not execute marketplace removal")
    roots = cache_roots(args.codex_home.resolve())
    require(len(roots) == 1 and roots[0].name == args.version, "preflight rejection must retain the baseline cache root")


def inject_target(args: argparse.Namespace) -> None:
    value = read_json(args.state)
    require(isinstance(value, dict), "target availability injection state must be an object")
    available = value.get("available")
    require(isinstance(available, list) and len(available) == 1, "target availability injection requires one available plugin")
    available[0]["version"] = "0.2.2"
    write_json(args.state, value)


def assert_available_state(state_path: Path, source_root: Path, version: str, label: str) -> None:
    target = source_root.resolve()
    value = read_json(state_path)
    require(isinstance(value, dict), f"{label} availability must be an object")
    require(value.get("installed") == [], f"{label} source must have no installed plugin before install")
    available = value.get("available")
    require(isinstance(available, list) and len(available) == 1, f"{label} source must expose exactly one available plugin")
    item = available[0]
    require(isinstance(item, dict), f"{label} available plugin must be an object")
    require(item.get("pluginId") == PLUGIN_ID, f"{label} available plugin ID must be canonical")
    require(item.get("name") == PLUGIN_NAME, f"{label} available plugin name must be canonical")
    require(item.get("marketplaceName") == MARKETPLACE, f"{label} marketplace name must be canonical")
    require(item.get("version") == version, f"{label} source must expose exact available version {version}")
    require(item.get("enabled") is False and item.get("installed") is False, f"{label} plugin must be available but not installed")
    source = item.get("source")
    require(isinstance(source, dict) and source.get("source") == "local", f"{label} plugin source must be local")
    require(normalized(str(source.get("path", ""))) == normalized(target / "plugins/design-arc"), f"{label} plugin path must match expected checkout")
    assert_marketplace_source(item, target, f"{label} available plugin")


def validate_available(args: argparse.Namespace) -> None:
    assert_available_state(args.state, args.source, args.version, args.label)


def validate_target(args: argparse.Namespace) -> None:
    assert_available_state(args.state, args.target, "0.3.0", "target")


def assert_projects(before_path: Path, after_path: Path, label: str, workflow_version: str) -> None:
    before = read_json(before_path)
    after = read_json(after_path)
    require(after == before, f"{label} must preserve every participating project byte and identity")
    require(before["participating_projects"] == ["alpha-product", "beta-product"], f"{label} must cover both participating projects")
    require(after["home_states"] == ["ready", "ready"], f"{label} must preserve ready-home metadata")
    require(after["home_thread_ids"] == ["home-thread-alpha", "home-thread-beta"], f"{label} must preserve home thread identities")
    require(after["review_thread_ids"] == ["review-thread-alpha", "review-thread-beta"], f"{label} must preserve active-review thread identities")
    require(after["review_continuation_counts"] == [0, 0], f"{label} must continue zero active reviews")
    require(after["review_workflow_versions"] == [workflow_version, workflow_version], f"{label} must pin both active reviews to {workflow_version}")
    require(len(after["graph_records"]) == 2, f"{label} must preserve two graph records")
    require(after["preferences_without_graph_fields"] is True, f"{label} preferences must retain no graph field")


def validate_restoration(args: argparse.Namespace) -> None:
    baseline = args.baseline.resolve()
    assert_installed_state(args.state, baseline, args.version, "rollback restoration")
    source = assert_marketplaces(read_json(args.marketplaces), baseline, "rollback restoration")
    assert_exact_cache(args.codex_home.resolve(), baseline, args.version, "rollback restoration")
    require(not list((args.codex_home / "plugins/cache").glob("*/design-arc/0.3.0")), "rollback restoration must leave no stale 0.3.0 cache")
    assert_projects(args.projects_before, args.projects_after, "rollback restoration", args.version)
    print(f"PASS: parsed restored marketplace source: {source}")


def validate_final(args: argparse.Namespace) -> None:
    target = args.target.resolve()
    parsed_source = parsed_marketplace_source(read_json(args.marketplaces), "final upgrade")
    assert_installed_state(args.state, parsed_source, "0.3.0", "final upgrade")
    if args.route == "remove-add-fallback":
        require(parsed_source == target, "fallback marketplace source must be the isolated current checkout")
    cached_root = assert_exact_cache(args.codex_home.resolve(), target, "0.3.0", "final upgrade")
    require(not list((args.codex_home / "plugins/cache").glob(f"*/design-arc/{args.baseline_version}")), "final upgrade must leave no stale baseline cache")

    prompt_items = read_json(args.prompt)
    require(isinstance(prompt_items, list), "new-task prompt input must be a JSON list")
    developer_text = "\n".join(
        content.get("text", "")
        for item in prompt_items
        if item.get("role") == "developer"
        for content in item.get("content", [])
        if content.get("type") == "input_text"
    )
    require(developer_text.count("- design-arc:design-arc:") == 1, "one new task must load Design Arc 0.3.0 exactly once")
    assert_projects(args.projects_before, args.projects_after, "final upgrade", args.baseline_version)
    contract_check = subprocess.run(
        [
            sys.executable,
            str(Path(__file__).with_name("check-workflow-contracts.py")),
            "--skill",
            str(cached_root / "skills/design-arc/SKILL.md"),
        ],
        capture_output=True,
        text=True,
        check=False,
    )
    require(contract_check.returncode == 0, "installed 0.3.0 skill must resolve the graph-active new-review contract")
    print(f"PASS: parsed marketplace source: {parsed_source}; route: {args.route}")
    print("PASS: installed 0.3.0 contract resolves graph active only for the next new review")


def validate_downgrade(args: argparse.Namespace) -> None:
    baseline = args.baseline.resolve()
    assert_installed_state(args.state, baseline, "0.2.3", "simulated downgrade")
    assert_marketplaces(read_json(args.marketplaces), baseline, "simulated downgrade")
    cached_root = assert_exact_cache(args.codex_home.resolve(), baseline, "0.2.3", "simulated downgrade")
    require(not list((args.codex_home / "plugins/cache").glob("*/design-arc/0.3.0")), "simulated downgrade must leave no 0.3.0 cache")
    require(not (cached_root / "skills/design-arc/references/graph-record.schema.json").exists(), "exact 0.2.3 must ignore unsupported graph schema")
    require(not (cached_root / "skills/design-arc/scripts/validate-graph-record.py").exists(), "exact 0.2.3 must ignore unsupported graph validator")
    assert_projects(args.projects_before, args.projects_after, "simulated downgrade", "0.2.3")
    prompt_items = read_json(args.prompt)
    require(isinstance(prompt_items, list), "downgrade prompt input must be a JSON list")
    developer_text = "\n".join(
        content.get("text", "")
        for item in prompt_items
        if item.get("role") == "developer"
        for content in item.get("content", [])
        if content.get("type") == "input_text"
    )
    require(developer_text.count("- design-arc:design-arc:") == 1, "downgraded task must load exact Design Arc 0.2.3 once")
    print("PASS: exact 0.2.3 downgrade ignores unsupported graph machinery and preserves graph records/state")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command", required=True)

    snapshot = subparsers.add_parser("snapshot-projects")
    snapshot.add_argument("projects", type=Path)
    snapshot.add_argument("output", type=Path)
    snapshot.set_defaults(func=snapshot_projects)

    preflight = subparsers.add_parser("validate-baseline")
    preflight.add_argument("state", type=Path)
    preflight.add_argument("marketplaces", type=Path)
    preflight.add_argument("codex_home", type=Path)
    preflight.add_argument("baseline", type=Path)
    preflight.add_argument("version")
    preflight.set_defaults(func=validate_baseline)

    injection = subparsers.add_parser("inject-preflight")
    injection.add_argument("state", type=Path)
    injection.add_argument("codex_home", type=Path)
    injection.add_argument("mode")
    injection.set_defaults(func=inject_preflight)

    rejected = subparsers.add_parser("validate-preflight-rejection")
    rejected.add_argument("actual_state", type=Path)
    rejected.add_argument("actual_marketplaces", type=Path)
    rejected.add_argument("codex_home", type=Path)
    rejected.add_argument("baseline", type=Path)
    rejected.add_argument("version")
    rejected.add_argument("plugin_remove_marker", type=Path)
    rejected.add_argument("marketplace_remove_marker", type=Path)
    rejected.set_defaults(func=validate_preflight_rejection)

    inject_target_parser = subparsers.add_parser("inject-target")
    inject_target_parser.add_argument("state", type=Path)
    inject_target_parser.set_defaults(func=inject_target)

    target_parser = subparsers.add_parser("validate-target")
    target_parser.add_argument("state", type=Path)
    target_parser.add_argument("target", type=Path)
    target_parser.set_defaults(func=validate_target)

    available_parser = subparsers.add_parser("validate-available")
    available_parser.add_argument("state", type=Path)
    available_parser.add_argument("source", type=Path)
    available_parser.add_argument("version")
    available_parser.add_argument("label")
    available_parser.set_defaults(func=validate_available)

    restoration = subparsers.add_parser("validate-restoration")
    restoration.add_argument("state", type=Path)
    restoration.add_argument("marketplaces", type=Path)
    restoration.add_argument("codex_home", type=Path)
    restoration.add_argument("baseline", type=Path)
    restoration.add_argument("version")
    restoration.add_argument("projects_before", type=Path)
    restoration.add_argument("projects_after", type=Path)
    restoration.set_defaults(func=validate_restoration)

    final = subparsers.add_parser("validate-final")
    final.add_argument("state", type=Path)
    final.add_argument("marketplaces", type=Path)
    final.add_argument("prompt", type=Path)
    final.add_argument("codex_home", type=Path)
    final.add_argument("target", type=Path)
    final.add_argument("projects_before", type=Path)
    final.add_argument("projects_after", type=Path)
    final.add_argument("route")
    final.add_argument("baseline_version")
    final.set_defaults(func=validate_final)

    downgrade = subparsers.add_parser("validate-downgrade")
    downgrade.add_argument("state", type=Path)
    downgrade.add_argument("marketplaces", type=Path)
    downgrade.add_argument("prompt", type=Path)
    downgrade.add_argument("codex_home", type=Path)
    downgrade.add_argument("baseline", type=Path)
    downgrade.add_argument("projects_before", type=Path)
    downgrade.add_argument("projects_after", type=Path)
    downgrade.set_defaults(func=validate_downgrade)
    return parser


def main() -> int:
    args = build_parser().parse_args()
    args.func(args)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
