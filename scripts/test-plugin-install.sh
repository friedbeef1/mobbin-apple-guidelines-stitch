#!/bin/sh
# Verify the published plugin can be discovered and installed without using caller state.

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
repo_root=$(CDPATH= cd "$script_dir/.." && pwd)
task_temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/fb-ux-plugin-smoke.XXXXXX")
checkout_path="$task_temp_dir/checkout"
codex_home="$task_temp_dir/codex-home"

cleanup() {
  rm -rf "$task_temp_dir"
}

fail() {
  printf '%s\n' "FAIL: $*" >&2
  exit 1
}

trap cleanup EXIT HUP INT TERM

mkdir "$codex_home"
git clone --quiet --no-local "$repo_root" "$checkout_path"

CODEX_HOME="$codex_home" codex plugin marketplace add "$checkout_path" --json > "$task_temp_dir/marketplace-add.json"
CODEX_HOME="$codex_home" codex plugin list --available --json > "$task_temp_dir/available.json"
CODEX_HOME="$codex_home" codex plugin add fb-ux@fb-ux-marketplace --json > "$task_temp_dir/fb-ux-add.json"
CODEX_HOME="$codex_home" codex plugin add apple-guidelines-stitch@fb-ux-marketplace --json > "$task_temp_dir/apple-guidelines-stitch-add.json"
CODEX_HOME="$codex_home" codex plugin list --json > "$task_temp_dir/installed.json"

python3 - "$checkout_path" "$codex_home" "$task_temp_dir" <<'PY'
import json
from pathlib import Path
import sys

checkout, codex_home, temporary_dir = (Path(path).resolve() for path in sys.argv[1:])

def read_json(name):
    return json.loads((temporary_dir / name).read_text(encoding="utf-8"))

def require(condition, message):
    if not condition:
        raise SystemExit(message)

marketplace = json.loads((checkout / ".agents/plugins/marketplace.json").read_text(encoding="utf-8"))
require(marketplace.get("name") == "fb-ux-marketplace", "marketplace must use the fb-ux-marketplace name")
require(marketplace.get("interface", {}).get("displayName") == "FB UX Marketplace", "marketplace display name must identify FB UX")
plugins = marketplace.get("plugins")
expected_entries = [
    {
        "name": "fb-ux",
        "source": {"source": "local", "path": "./plugins/fb-ux"},
        "policy": {"installation": "AVAILABLE", "authentication": "ON_INSTALL"},
        "category": "Productivity",
    },
    {
        "name": "apple-guidelines-stitch",
        "source": {"source": "local", "path": "./plugins/apple-guidelines-stitch"},
        "policy": {"installation": "AVAILABLE", "authentication": "ON_INSTALL"},
        "category": "Productivity",
    },
]
require(plugins == expected_entries, "marketplace must expose the canonical fb-ux and apple-guidelines-stitch plugin entries")

available = read_json("available.json")
require(available.get("installed") == [], "isolated Codex home must begin without installed plugins")
available_plugins = available.get("available")
require(isinstance(available_plugins, list) and len(available_plugins) == 2, "fresh marketplace must expose exactly two available plugins")
available_by_id = {plugin.get("pluginId"): plugin for plugin in available_plugins}
for name in ("fb-ux", "apple-guidelines-stitch"):
    plugin_id = f"{name}@fb-ux-marketplace"
    available_plugin = available_by_id.get(plugin_id)
    require(available_plugin is not None, f"available plugin id must include {plugin_id}")
    require(available_plugin.get("name") == name, f"available plugin name must be {name}")
    expected_source = str((checkout / "plugins" / name).resolve())
    require(available_plugin.get("source", {}).get("path") == expected_source, f"Codex marketplace must resolve the canonical {name} plugin path")
    require(available_plugin.get("installPolicy") == "AVAILABLE", f"Codex marketplace must report AVAILABLE installation policy for {name}")
    require(available_plugin.get("authPolicy") == "ON_INSTALL", f"Codex marketplace must report ON_INSTALL authentication policy for {name}")

installed = read_json("installed.json")
installed_plugins = installed.get("installed")
require(isinstance(installed_plugins, list) and len(installed_plugins) == 2, "isolated Codex home must contain both installed plugins")
installed_by_id = {plugin.get("pluginId"): plugin for plugin in installed_plugins}
expected_display_names = {
    "fb-ux": "FB UX",
    "apple-guidelines-stitch": "Apple Guidelines + Stitch",
}
installed_paths = set()
for name, display_name in expected_display_names.items():
    plugin_id = f"{name}@fb-ux-marketplace"
    installed_plugin = installed_by_id.get(plugin_id)
    require(installed_plugin is not None, f"Codex list must report {name} as installed")
    require(installed_plugin.get("enabled") is True, f"installed {name} plugin must be enabled")

    install = read_json(f"{name}-add.json")
    installed_path = Path(install.get("installedPath", "")).resolve()
    require(install.get("pluginId") == plugin_id, f"Codex must install the {name} marketplace plugin")
    require(installed_path.is_dir(), f"Codex must report an installed {name} plugin cache directory")
    require(codex_home in installed_path.parents, f"installed {name} plugin cache must remain inside the temporary Codex home")
    installed_paths.add(installed_path)

    plugin = json.loads((installed_path / ".codex-plugin/plugin.json").read_text(encoding="utf-8"))
    require(plugin.get("interface", {}).get("displayName") == display_name, f"installed plugin display name must be {display_name}")
    require(plugin.get("skills") == "./skills/", f"installed {name} plugin must expose ./skills/")
    skill = (installed_path / "skills" / name / "SKILL.md").read_text(encoding="utf-8")
    require(skill.startswith(f"---\nname: {name}\n"), f"installed embedded skill must load with name: {name}")

require(len(installed_paths) == 2, "installed plugins must use unique cache paths")
readme = (checkout / "README.md").read_text(encoding="utf-8")
require("$fb-ux" in readme, "fresh-checkout README must document the $fb-ux invocation")
require("$apple-guidelines-stitch" in readme, "fresh-checkout README must document the $apple-guidelines-stitch invocation")
PY

printf '%s\n' 'PASS: isolated plugin installation smoke'
