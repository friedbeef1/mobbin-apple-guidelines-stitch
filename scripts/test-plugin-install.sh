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
CODEX_HOME="$codex_home" codex plugin add fb-ux@fb-ux-marketplace --json > "$task_temp_dir/plugin-add.json"
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
require(isinstance(plugins, list) and len(plugins) == 1, "marketplace must contain exactly one plugin")
entry = plugins[0]
require(entry.get("name") == "fb-ux", "marketplace plugin name must be fb-ux")
require(entry.get("source") == {"source": "local", "path": "./plugins/fb-ux"}, "marketplace plugin source must point to ./plugins/fb-ux")
require(entry.get("policy") == {"installation": "AVAILABLE", "authentication": "ON_INSTALL"}, "marketplace plugin policy must remain AVAILABLE/ON_INSTALL")

available = read_json("available.json")
require(available.get("installed") == [], "isolated Codex home must begin without installed plugins")
available_plugins = available.get("available")
require(isinstance(available_plugins, list) and len(available_plugins) == 1, "fresh marketplace must expose exactly one available plugin")
available_plugin = available_plugins[0]
expected_source = str((checkout / "plugins/fb-ux").resolve())
require(available_plugin.get("pluginId") == "fb-ux@fb-ux-marketplace", "available plugin id must use the marketplace selector")
require(available_plugin.get("name") == "fb-ux", "available plugin name must be fb-ux")
require(available_plugin.get("source", {}).get("path") == expected_source, "Codex marketplace must resolve the canonical plugin path")
require(available_plugin.get("installPolicy") == "AVAILABLE", "Codex marketplace must report AVAILABLE installation policy")
require(available_plugin.get("authPolicy") == "ON_INSTALL", "Codex marketplace must report ON_INSTALL authentication policy")

install = read_json("plugin-add.json")
installed_path = Path(install.get("installedPath", "")).resolve()
require(install.get("pluginId") == "fb-ux@fb-ux-marketplace", "Codex must install the fb-ux marketplace plugin")
require(installed_path.is_dir(), "Codex must report an installed plugin cache directory")
require(codex_home in installed_path.parents, "installed plugin cache must remain inside the temporary Codex home")

installed = read_json("installed.json")
installed_plugins = installed.get("installed")
require(isinstance(installed_plugins, list) and len(installed_plugins) == 1, "isolated Codex home must contain the installed fb-ux plugin")
require(installed_plugins[0].get("pluginId") == "fb-ux@fb-ux-marketplace", "Codex list must report fb-ux as installed")
require(installed_plugins[0].get("enabled") is True, "installed fb-ux plugin must be enabled")

plugin = json.loads((installed_path / ".codex-plugin/plugin.json").read_text(encoding="utf-8"))
require(plugin.get("interface", {}).get("displayName") == "FB UX", "installed plugin display name must be FB UX")
require(plugin.get("skills") == "./skills/", "installed plugin must expose ./skills/")
skill = (installed_path / "skills/fb-ux/SKILL.md").read_text(encoding="utf-8")
require(skill.startswith("---\nname: fb-ux\n"), "installed embedded skill must load with name: fb-ux")
readme = (checkout / "README.md").read_text(encoding="utf-8")
require("$fb-ux" in readme, "fresh-checkout README must document the $fb-ux invocation")
PY

printf '%s\n' 'PASS: isolated plugin installation smoke'
