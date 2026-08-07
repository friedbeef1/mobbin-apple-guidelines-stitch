#!/bin/sh
# Exercise an existing public Design Arc 0.2.0 installation upgrading to this checkout.

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
repo_root=$(CDPATH= cd "$script_dir/.." && pwd)
codex_bin=${CODEX_BIN:-codex}
published_sha=8e2318496d8e2dbc3c75e19ddde997b598188755
task_temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/design-arc-upgrade-smoke.XXXXXX")
published_checkout="$task_temp_dir/published-0.2.0"
current_checkout="$task_temp_dir/current-0.2.1"
codex_home="$task_temp_dir/codex-home"
project_root="$task_temp_dir/project"
preference_path="$project_root/.codex/design-arc.yaml"

cleanup() {
  [ -n "$task_temp_dir" ] && [ -d "$task_temp_dir" ] && rm -rf "$task_temp_dir"
}

fail() {
  printf '%s\n' "FAIL: $*" >&2
  exit 1
}

trap cleanup EXIT HUP INT TERM

command -v "$codex_bin" >/dev/null 2>&1 || fail "Codex CLI is unavailable: $codex_bin"
mkdir "$codex_home" "$project_root"
mkdir "$project_root/.codex"
git clone --quiet --no-local "$repo_root" "$published_checkout"
git -C "$published_checkout" checkout --quiet --detach "$published_sha"
git clone --quiet --no-local "$repo_root" "$current_checkout"
git -C "$repo_root" diff --binary --no-ext-diff HEAD -- . > "$task_temp_dir/current-worktree.diff"
if [ -s "$task_temp_dir/current-worktree.diff" ]
then
  git -C "$current_checkout" apply "$task_temp_dir/current-worktree.diff"
fi

printf '%s\n' \
  'evidence_mode: benchmarks' \
  'benchmark_provider: mobbin' \
  'approval_mode: follow-recommendation' \
  'design_arc_home:' \
  '  project_id: upgrade-fixture-project' \
  '  project_name: Upgrade Fixture' \
  '  title: Design Arc — Upgrade Fixture' \
  '  state: ready' \
  '  thread_id: upgrade-fixture-thread' > "$preference_path"
cp "$preference_path" "$task_temp_dir/preference-before.yaml"

CODEX_HOME="$codex_home" "$codex_bin" --version > "$task_temp_dir/codex-version.txt"
CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace add "$published_checkout" --json > "$task_temp_dir/marketplace-add-0.2.0.json"
CODEX_HOME="$codex_home" "$codex_bin" plugin add design-arc@design-arc-marketplace --json > "$task_temp_dir/plugin-add-0.2.0.json"
CODEX_HOME="$codex_home" "$codex_bin" plugin list --available --json > "$task_temp_dir/before-upgrade.json"

if CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace upgrade design-arc-marketplace --json > "$task_temp_dir/marketplace-upgrade.json" 2> "$task_temp_dir/marketplace-upgrade.stderr"
then
  printf '%s\n' succeeded > "$task_temp_dir/marketplace-upgrade.status"
else
  printf '%s\n' unavailable > "$task_temp_dir/marketplace-upgrade.status"
fi
CODEX_HOME="$codex_home" "$codex_bin" plugin list --available --json > "$task_temp_dir/after-refresh.json"

if python3 - "$task_temp_dir/after-refresh.json" <<'PY'
import json
from pathlib import Path
import sys

state = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
installed = state.get("installed")
raise SystemExit(0 if isinstance(installed, list) and len(installed) == 1 and installed[0].get("version") == "0.2.1" else 1)
PY
then
  cp "$task_temp_dir/after-refresh.json" "$task_temp_dir/after-upgrade.json"
  printf '%s\n' refresh > "$task_temp_dir/upgrade-route.txt"
else
  CODEX_HOME="$codex_home" "$codex_bin" plugin remove design-arc@design-arc-marketplace --json > "$task_temp_dir/plugin-remove-0.2.0.json"
  CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace remove design-arc-marketplace --json > "$task_temp_dir/marketplace-remove-0.2.0.json"
  CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace add "$current_checkout" --json > "$task_temp_dir/marketplace-add-0.2.1.json"
  CODEX_HOME="$codex_home" "$codex_bin" plugin add design-arc@design-arc-marketplace --json > "$task_temp_dir/plugin-add-0.2.1.json"
  CODEX_HOME="$codex_home" "$codex_bin" plugin list --available --json > "$task_temp_dir/after-upgrade.json"
  printf '%s\n' remove-add-fallback > "$task_temp_dir/upgrade-route.txt"
fi

CODEX_HOME="$codex_home" "$codex_bin" debug prompt-input "Open this project's Design Arc home." > "$task_temp_dir/prompt-input-after.json"

python3 - "$published_checkout" "$current_checkout" "$codex_home" "$task_temp_dir" "$preference_path" "$published_sha" <<'PY'
import json
from pathlib import Path
import subprocess
import sys

published, current, codex_home, temporary_dir, preference_path = (
    Path(path).resolve() for path in sys.argv[1:6]
)
expected_published_sha = sys.argv[6]


def read_json(name):
    return json.loads((temporary_dir / name).read_text(encoding="utf-8"))


def require(condition, message):
    if not condition:
        raise SystemExit(f"FAIL: {message}")


actual_published_sha = subprocess.run(
    ["git", "-C", str(published), "rev-parse", "HEAD"],
    check=True,
    capture_output=True,
    text=True,
).stdout.strip()
require(actual_published_sha == expected_published_sha, "upgrade fixture must use the exact public 0.2.0 commit")

version = (temporary_dir / "codex-version.txt").read_text(encoding="utf-8").strip()
require(version.startswith("codex-cli "), "upgrade smoke must run the real Codex CLI")

public_add = read_json("plugin-add-0.2.0.json")
require(public_add.get("version") == "0.2.0", "upgrade must begin with Design Arc 0.2.0 installed")
public_path = Path(public_add.get("installedPath", "")).resolve()
require(codex_home in public_path.parents, "public plugin cache must stay inside the isolated Codex home")

before = read_json("before-upgrade.json")
before_installed = before.get("installed")
require(isinstance(before_installed, list) and len(before_installed) == 1, "upgrade must begin with exactly one installed plugin")
require(before_installed[0].get("version") == "0.2.0", "installed state must report public version 0.2.0")

after_refresh = read_json("after-refresh.json")
after_refresh_installed = after_refresh.get("installed")
require(isinstance(after_refresh_installed, list) and len(after_refresh_installed) == 1, "refresh must retain exactly one installed plugin")

refresh_status = (temporary_dir / "marketplace-upgrade.status").read_text(encoding="utf-8").strip()
require(refresh_status in {"succeeded", "unavailable"}, "marketplace refresh must record its real CLI result")
upgrade_route = (temporary_dir / "upgrade-route.txt").read_text(encoding="utf-8").strip()
require(upgrade_route in {"refresh", "remove-add-fallback"}, "upgrade must record the CLI route that reached 0.2.1")
if after_refresh_installed[0].get("version") == "0.2.1":
    require(refresh_status == "succeeded", "a refresh cannot expose 0.2.1 when the CLI call failed")
    require(upgrade_route == "refresh", "an effective refresh must not use the remove/add fallback")
else:
    require(after_refresh_installed[0].get("version") == "0.2.0", "ineffective refresh must leave the known public version installed")
    require(upgrade_route == "remove-add-fallback", "an ineffective refresh must use the documented remove/add fallback")
    if refresh_status == "unavailable":
        refresh_error = (temporary_dir / "marketplace-upgrade.stderr").read_text(encoding="utf-8")
        require("not configured as a Git marketplace" in refresh_error, "unavailable refresh must report the installed CLI's local-marketplace boundary")
    remove = read_json("plugin-remove-0.2.0.json")
    require(remove.get("pluginId") == "design-arc@design-arc-marketplace", "fallback must remove only the canonical Design Arc plugin")
    marketplace_remove = read_json("marketplace-remove-0.2.0.json")
    require(marketplace_remove.get("marketplaceName") == "design-arc-marketplace", "fallback must remove only the Design Arc marketplace")
    marketplace_add = read_json("marketplace-add-0.2.1.json")
    require(marketplace_add.get("marketplaceName") == "design-arc-marketplace", "fallback must restore the canonical marketplace")
    require(Path(marketplace_add.get("installedRoot", "")).resolve() == current, "fallback marketplace must use the isolated current checkout")
    plugin_add = read_json("plugin-add-0.2.1.json")
    require(plugin_add.get("pluginId") == "design-arc@design-arc-marketplace", "fallback must restore the canonical plugin")
    require(plugin_add.get("version") == "0.2.1", "fallback must install Design Arc 0.2.1")
    require(not public_path.exists(), "fallback must remove the public 0.2.0 cache")

after_upgrade = read_json("after-upgrade.json")
after_upgrade_installed = after_upgrade.get("installed")
require(isinstance(after_upgrade_installed, list) and len(after_upgrade_installed) == 1, "upgrade must finish with exactly one installed plugin")
require(after_upgrade_installed[0].get("pluginId") == "design-arc@design-arc-marketplace", "upgrade must retain the canonical plugin ID")
require(after_upgrade_installed[0].get("version") == "0.2.1", "upgrade must finish with installed Design Arc 0.2.1")
require(after_upgrade_installed[0].get("enabled") is True, "upgraded Design Arc must remain enabled")
require(after_upgrade.get("available") == [], "upgrade must leave no second Design Arc version available")

cached_skills = list((codex_home / "plugins/cache").glob("*/design-arc/*/skills/design-arc/SKILL.md"))
require(len(cached_skills) == 1, "upgrade must leave exactly one cached Design Arc skill")
installed_skill = cached_skills[0]
require(installed_skill.read_bytes() == (current / "plugins/design-arc/skills/design-arc/SKILL.md").read_bytes(), "upgraded cache must contain the branch's combined Design Arc skill")
installed_manifest = installed_skill.parents[2] / ".codex-plugin/plugin.json"
require(json.loads(installed_manifest.read_text(encoding="utf-8")).get("version") == "0.2.1", "upgraded cache manifest must report 0.2.1")

prompt_items = read_json("prompt-input-after.json")
developer_text = "\n".join(
    content.get("text", "")
    for item in prompt_items
    if item.get("role") == "developer"
    for content in item.get("content", [])
    if content.get("type") == "input_text"
)
require(developer_text.count("- design-arc:design-arc:") == 1, "a post-upgrade new task must expose exactly one Design Arc skill")

require(
    preference_path.read_bytes() == (temporary_dir / "preference-before.yaml").read_bytes(),
    "upgrade must preserve the representative project preference byte-for-byte",
)

print(f"PASS: isolated Design Arc 0.2.0 to 0.2.1 upgrade via {upgrade_route} ({version})")
PY

printf '%s\n' 'PASS: isolated Design Arc plugin upgrade smoke'
