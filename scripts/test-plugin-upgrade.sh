#!/bin/sh
# Exercise an immutable public Design Arc 0.2.1 installation upgrading to this checkout.

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
repo_root=$(CDPATH= cd "$script_dir/.." && pwd)
codex_bin=${CODEX_BIN:-codex}
published_sha=c86240c67e1e9cae51bd6cc63a0f957d7fbca4a9
task_temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/design-arc-upgrade-smoke.XXXXXX")
published_checkout="$task_temp_dir/published-0.2.1"
current_checkout="$task_temp_dir/current-0.2.2"
codex_home="$task_temp_dir/codex-home"
projects_root="$task_temp_dir/projects"
injected_failure=${DESIGN_ARC_UPGRADE_INJECT_FAILURE:-}

cleanup() {
  [ -n "$task_temp_dir" ] && [ -d "$task_temp_dir" ] && rm -rf "$task_temp_dir"
}

fail() {
  printf '%s\n' "FAIL: $*" >&2
  exit 1
}

snapshot_projects() {
  output_path=$1
  python3 - "$projects_root" "$output_path" <<'PY'
import hashlib
import json
from pathlib import Path
import re
import sys

root = Path(sys.argv[1]).resolve()
output = Path(sys.argv[2]).resolve()

files = {
    path.relative_to(root).as_posix(): hashlib.sha256(path.read_bytes()).hexdigest()
    for path in sorted(root.rglob("*"))
    if path.is_file()
}
preferences = sorted(root.glob("*/.codex/design-arc.yaml"))
home_thread_ids = []
home_states = []
for path in preferences:
    text = path.read_text(encoding="utf-8")
    thread_match = re.search(r"(?m)^  thread_id: (.+)$", text)
    state_match = re.search(r"(?m)^  state: (.+)$", text)
    if thread_match:
        home_thread_ids.append(thread_match.group(1))
    if state_match:
        home_states.append(state_match.group(1))

review_paths = sorted(root.glob("*/.codex/design-arc-active-review.json"))
reviews = [json.loads(path.read_text(encoding="utf-8")) for path in review_paths]
product_paths = sorted(root.glob("*/product/product-state.txt"))

snapshot = {
    "files": files,
    "participating_projects": [path.parents[1].name for path in preferences],
    "home_thread_ids": sorted(home_thread_ids),
    "home_states": sorted(home_states),
    "review_thread_ids": sorted(review["thread_id"] for review in reviews),
    "review_continuation_counts": [review["continuation_count"] for review in reviews],
    "product_sentinels": [path.relative_to(root).as_posix() for path in product_paths],
}
output.write_text(json.dumps(snapshot, indent=2, sort_keys=True) + "\n", encoding="utf-8")
PY
}

trap cleanup EXIT HUP INT TERM

command -v "$codex_bin" >/dev/null 2>&1 || fail "Codex CLI is unavailable: $codex_bin"
mkdir "$codex_home" "$projects_root"
git clone --quiet --no-local "$repo_root" "$published_checkout"
git -C "$published_checkout" checkout --quiet --detach "$published_sha"
git clone --quiet --no-local "$repo_root" "$current_checkout"
git -C "$repo_root" diff --binary --no-ext-diff HEAD -- . > "$task_temp_dir/current-worktree.diff"
if [ -s "$task_temp_dir/current-worktree.diff" ]
then
  git -C "$current_checkout" apply "$task_temp_dir/current-worktree.diff"
fi

alpha_root="$projects_root/alpha-product"
beta_root="$projects_root/beta-product"
mkdir -p "$alpha_root/.codex" "$alpha_root/product" "$beta_root/.codex" "$beta_root/product"
printf '%s\n' \
  'evidence_mode: benchmarks' \
  'benchmark_provider: mobbin' \
  'approval_mode: follow-recommendation' \
  'design_arc_home:' \
  '  project_id: project-alpha' \
  '  project_name: Alpha Product' \
  '  title: Design Arc — Alpha Product' \
  '  state: ready' \
  '  thread_id: home-thread-alpha' > "$alpha_root/.codex/design-arc.yaml"
printf '%s\n' \
  'evidence_mode: guidelines' \
  'approval_mode: guided' \
  'design_arc_home:' \
  '  project_id: project-beta' \
  '  project_name: Beta Product' \
  '  title: Design Arc — Beta Product' \
  '  state: ready' \
  '  thread_id: home-thread-beta' > "$beta_root/.codex/design-arc.yaml"
printf '%s\n' '{"thread_id":"review-thread-alpha","state":"awaiting-stitch-gate","continuation_count":0}' > "$alpha_root/.codex/design-arc-active-review.json"
printf '%s\n' '{"thread_id":"review-thread-beta","state":"awaiting-direction-gate","continuation_count":0}' > "$beta_root/.codex/design-arc-active-review.json"
printf '%s\n' 'alpha product sentinel: must remain byte-for-byte unchanged' > "$alpha_root/product/product-state.txt"
printf '%s\n' 'beta product sentinel: must remain byte-for-byte unchanged' > "$beta_root/product/product-state.txt"
snapshot_projects "$task_temp_dir/projects-before.json"

CODEX_HOME="$codex_home" "$codex_bin" --version > "$task_temp_dir/codex-version.txt"
CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace add "$published_checkout" --json > "$task_temp_dir/marketplace-add-0.2.1.json"
CODEX_HOME="$codex_home" "$codex_bin" plugin list --available --json > "$task_temp_dir/baseline-available.json"
CODEX_HOME="$codex_home" "$codex_bin" plugin add design-arc@design-arc-marketplace --json > "$task_temp_dir/plugin-add-0.2.1.json"
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
raise SystemExit(0 if isinstance(installed, list) and len(installed) == 1 and installed[0].get("version") == "0.2.2" else 1)
PY
then
  cp "$task_temp_dir/after-refresh.json" "$task_temp_dir/after-upgrade.json"
  printf '%s\n' refresh > "$task_temp_dir/upgrade-route.txt"
else
  CODEX_HOME="$codex_home" "$codex_bin" plugin remove design-arc@design-arc-marketplace --json > "$task_temp_dir/plugin-remove-0.2.1.json"
  CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace remove design-arc-marketplace --json > "$task_temp_dir/marketplace-remove-0.2.1.json"
  fallback_failure=
  if [ "$injected_failure" = marketplace-add ]
  then
    fallback_failure=marketplace-add
  elif ! CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace add "$current_checkout" --json > "$task_temp_dir/marketplace-add-0.2.2.json"
  then
    fallback_failure=marketplace-add
  else
    CODEX_HOME="$codex_home" "$codex_bin" plugin list --available --json > "$task_temp_dir/target-available.json"
  fi

  if [ -z "$fallback_failure" ]
  then
    if [ "$injected_failure" = plugin-add ]
    then
      fallback_failure=plugin-add
    elif ! CODEX_HOME="$codex_home" "$codex_bin" plugin add design-arc@design-arc-marketplace --json > "$task_temp_dir/plugin-add-0.2.2.json"
    then
      fallback_failure=plugin-add
    fi
  fi

  if [ -n "$fallback_failure" ]
  then
    CODEX_HOME="$codex_home" "$codex_bin" plugin remove design-arc@design-arc-marketplace --json >/dev/null 2>&1 || :
    CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace remove design-arc-marketplace --json >/dev/null 2>&1 || :
    CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace add "$published_checkout" --json > "$task_temp_dir/marketplace-restore-0.2.1.json"
    CODEX_HOME="$codex_home" "$codex_bin" plugin add design-arc@design-arc-marketplace --json > "$task_temp_dir/plugin-restore-0.2.1.json"
    CODEX_HOME="$codex_home" "$codex_bin" plugin list --available --json > "$task_temp_dir/after-rollback.json"
    CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace list --json > "$task_temp_dir/marketplaces-after-rollback.json"
    snapshot_projects "$task_temp_dir/projects-after.json"

    python3 - "$published_checkout" "$codex_home" "$task_temp_dir" "$published_sha" "$fallback_failure" <<'PY'
import json
from pathlib import Path
import subprocess
import sys

published, codex_home, temporary_dir = (Path(path).resolve() for path in sys.argv[1:4])
expected_sha, failure_point = sys.argv[4:6]


def read_json(name):
    return json.loads((temporary_dir / name).read_text(encoding="utf-8"))


def require(condition, message):
    if not condition:
        raise SystemExit(f"FAIL: {message}")


actual_sha = subprocess.run(
    ["git", "-C", str(published), "rev-parse", "HEAD"],
    check=True,
    capture_output=True,
    text=True,
).stdout.strip()
require(actual_sha == expected_sha, "rollback source must be immutable public 0.2.1 commit c86240c")

state = read_json("after-rollback.json")
installed = state.get("installed")
require(isinstance(installed, list) and len(installed) == 1, "rollback must restore exactly one installed plugin")
require(installed[0].get("pluginId") == "design-arc@design-arc-marketplace", "rollback must restore the canonical plugin ID")
require(installed[0].get("version") == "0.2.1", "rollback must restore exact Design Arc 0.2.1")
require(installed[0].get("enabled") is True, "restored Design Arc must be enabled")
require(state.get("available") == [], "rollback must leave no second Design Arc version available")

marketplaces = read_json("marketplaces-after-rollback.json").get("marketplaces")
require(isinstance(marketplaces, list) and len(marketplaces) == 1, "rollback must restore exactly one marketplace")
require(marketplaces[0].get("name") == "design-arc-marketplace", "rollback must restore the canonical marketplace")

cached_skills = list((codex_home / "plugins/cache").glob("*/design-arc/*/skills/design-arc/SKILL.md"))
require(len(cached_skills) == 1, "rollback must leave exactly one cached Design Arc skill")
require(cached_skills[0].read_bytes() == (published / "plugins/design-arc/skills/design-arc/SKILL.md").read_bytes(), "rollback cache must match immutable public 0.2.1")

before_projects = read_json("projects-before.json")
after_projects = read_json("projects-after.json")
require(after_projects == before_projects, "rollback must preserve all participating project bytes and identities")
require(after_projects["home_thread_ids"] == ["home-thread-alpha", "home-thread-beta"], "rollback must create or replace zero project homes")
require(after_projects["review_thread_ids"] == ["review-thread-alpha", "review-thread-beta"], "rollback must preserve active-review thread identities")
require(after_projects["review_continuation_counts"] == [0, 0], "rollback must continue zero active reviews")

print(f"PASS: restored exact Design Arc 0.2.1 after injected {failure_point} failure")
PY
    exit 0
  fi

  CODEX_HOME="$codex_home" "$codex_bin" plugin list --available --json > "$task_temp_dir/after-upgrade.json"
  CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace list --json > "$task_temp_dir/marketplaces-after-upgrade.json"
  printf '%s\n' remove-add-fallback > "$task_temp_dir/upgrade-route.txt"
fi

(
  cd "$alpha_root"
  CODEX_HOME="$codex_home" "$codex_bin" debug prompt-input "Open this project's existing Design Arc home." > "$task_temp_dir/prompt-input-after.json"
)
snapshot_projects "$task_temp_dir/projects-after.json"

python3 - "$published_checkout" "$current_checkout" "$codex_home" "$task_temp_dir" "$published_sha" <<'PY'
import json
from pathlib import Path
import subprocess
import sys

published, current, codex_home, temporary_dir = (Path(path).resolve() for path in sys.argv[1:5])
expected_published_sha = sys.argv[5]


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
require(actual_published_sha == expected_published_sha, "upgrade fixture must use immutable public 0.2.1 commit c86240c")

version = (temporary_dir / "codex-version.txt").read_text(encoding="utf-8").strip()
require(version.startswith("codex-cli "), "upgrade smoke must run the real Codex CLI")

baseline_available = read_json("baseline-available.json").get("available")
require(isinstance(baseline_available, list) and len(baseline_available) == 1, "public source must expose one available plugin before install")
require(baseline_available[0].get("pluginId") == "design-arc@design-arc-marketplace", "public source must expose canonical plugin ID")
require(baseline_available[0].get("version") == "0.2.1", "public source must expose available version 0.2.1")

public_add = read_json("plugin-add-0.2.1.json")
require(public_add.get("version") == "0.2.1", "upgrade must begin with Design Arc 0.2.1 installed")
public_path = Path(public_add.get("installedPath", "")).resolve()
require(codex_home in public_path.parents, "public plugin cache must stay inside the isolated Codex home")

before = read_json("before-upgrade.json")
before_installed = before.get("installed")
require(isinstance(before_installed, list) and len(before_installed) == 1, "upgrade must begin with exactly one installed plugin")
require(before_installed[0].get("version") == "0.2.1", "installed state must report public version 0.2.1")

after_refresh = read_json("after-refresh.json")
after_refresh_installed = after_refresh.get("installed")
require(isinstance(after_refresh_installed, list) and len(after_refresh_installed) == 1, "refresh must retain exactly one installed plugin")

refresh_status = (temporary_dir / "marketplace-upgrade.status").read_text(encoding="utf-8").strip()
require(refresh_status in {"succeeded", "unavailable"}, "marketplace refresh must record its real CLI result")
upgrade_route = (temporary_dir / "upgrade-route.txt").read_text(encoding="utf-8").strip()
require(upgrade_route in {"refresh", "remove-add-fallback"}, "upgrade must record the actual route that reached 0.2.2")
if after_refresh_installed[0].get("version") == "0.2.2":
    require(refresh_status == "succeeded", "a refresh cannot expose 0.2.2 when the CLI call failed")
    require(upgrade_route == "refresh", "an effective refresh must not use the remove/add fallback")
else:
    require(after_refresh_installed[0].get("version") == "0.2.1", "ineffective refresh must leave the known public version installed")
    require(upgrade_route == "remove-add-fallback", "an ineffective refresh must use the bounded remove/add fallback")
    if refresh_status == "unavailable":
        refresh_error = (temporary_dir / "marketplace-upgrade.stderr").read_text(encoding="utf-8")
        require("not configured as a Git marketplace" in refresh_error, "unavailable refresh must report the installed CLI local-marketplace boundary")
    remove = read_json("plugin-remove-0.2.1.json")
    require(remove.get("pluginId") == "design-arc@design-arc-marketplace", "fallback must remove only the canonical Design Arc plugin")
    marketplace_remove = read_json("marketplace-remove-0.2.1.json")
    require(marketplace_remove.get("marketplaceName") == "design-arc-marketplace", "fallback must remove only the Design Arc marketplace")
    marketplace_add = read_json("marketplace-add-0.2.2.json")
    require(marketplace_add.get("marketplaceName") == "design-arc-marketplace", "fallback must restore the canonical marketplace")
    require(Path(marketplace_add.get("installedRoot", "")).resolve() == current, "fallback marketplace must use the isolated current checkout")
    target_available = read_json("target-available.json").get("available")
    require(isinstance(target_available, list) and len(target_available) == 1, "target source must expose exactly one available plugin")
    require(target_available[0].get("version") == "0.2.2", "target source must expose available version 0.2.2")
    plugin_add = read_json("plugin-add-0.2.2.json")
    require(plugin_add.get("pluginId") == "design-arc@design-arc-marketplace", "fallback must restore the canonical plugin")
    require(plugin_add.get("version") == "0.2.2", "fallback must install Design Arc 0.2.2")
    require(not public_path.exists(), "fallback must remove the public 0.2.1 cache")

after_upgrade = read_json("after-upgrade.json")
after_upgrade_installed = after_upgrade.get("installed")
require(isinstance(after_upgrade_installed, list) and len(after_upgrade_installed) == 1, "upgrade must finish with exactly one installed plugin")
require(after_upgrade_installed[0].get("pluginId") == "design-arc@design-arc-marketplace", "upgrade must retain the canonical plugin ID")
require(after_upgrade_installed[0].get("version") == "0.2.2", "upgrade must finish with installed Design Arc 0.2.2")
require(after_upgrade_installed[0].get("enabled") is True, "upgraded Design Arc must remain enabled")
require(after_upgrade.get("available") == [], "upgrade must leave zero other available Design Arc versions")

cached_plugins = list((codex_home / "plugins/cache").glob("*/design-arc/*/.codex-plugin/plugin.json"))
cached_skills = list((codex_home / "plugins/cache").glob("*/design-arc/*/skills/design-arc/SKILL.md"))
require(len(cached_plugins) == 1, "upgrade must leave exactly one cached Design Arc plugin")
require(len(cached_skills) == 1, "upgrade must leave exactly one cached Design Arc skill")
installed_skill = cached_skills[0]
require(installed_skill.read_bytes() == (current / "plugins/design-arc/skills/design-arc/SKILL.md").read_bytes(), "upgraded cache must contain the branch-identical Design Arc skill")
installed_manifest = json.loads(cached_plugins[0].read_text(encoding="utf-8"))
require(installed_manifest.get("version") == "0.2.2", "the only cached plugin manifest must report 0.2.2")

prompt_items = read_json("prompt-input-after.json")
developer_text = "\n".join(
    content.get("text", "")
    for item in prompt_items
    if item.get("role") == "developer"
    for content in item.get("content", [])
    if content.get("type") == "input_text"
)
require(developer_text.count("- design-arc:design-arc:") == 1, "one new task must load Design Arc 0.2.2 exactly once")

before_projects = read_json("projects-before.json")
after_projects = read_json("projects-after.json")
require(before_projects["participating_projects"] == ["alpha-product", "beta-product"], "upgrade fixture must discover both participating projects")
require(after_projects == before_projects, "upgrade must preserve every participating project file byte-for-byte")
require(after_projects["home_states"] == ["ready", "ready"], "upgrade must preserve ready-home metadata")
require(after_projects["home_thread_ids"] == ["home-thread-alpha", "home-thread-beta"], "upgrade must preserve task identities and create zero replacement homes")
require(after_projects["review_thread_ids"] == ["review-thread-alpha", "review-thread-beta"], "upgrade must preserve active-review thread identities")
require(after_projects["review_continuation_counts"] == [0, 0], "upgrade must continue zero active reviews")
require(after_projects["product_sentinels"] == ["alpha-product/product/product-state.txt", "beta-product/product/product-state.txt"], "upgrade fixture must cover both product-file sentinels")

print(f"PASS: baseline installed/available Design Arc 0.2.1 from immutable local checkout {expected_published_sha}")
print(f"PASS: target installed Design Arc 0.2.2; available versions after install: 0; marketplace source: {current}; route: {upgrade_route}")
print("PASS: preserved 2 preferences, 2 ready homes, 2 product sentinels, 2 active reviews; new homes: 0; review continuations: 0")
print(f"PASS: isolated Design Arc 0.2.1 to 0.2.2 upgrade via {upgrade_route} ({version})")
PY

printf '%s\n' 'PASS: isolated Design Arc plugin upgrade smoke'
