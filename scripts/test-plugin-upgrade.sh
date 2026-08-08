#!/bin/sh
# Exercise an immutable public Design Arc 0.2.2 installation upgrading to this checkout.

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
repo_root=$(CDPATH= cd "$script_dir/.." && pwd)
state_helper="$script_dir/test-plugin-upgrade-state.py"
codex_bin=${CODEX_BIN:-codex}
published_sha=1c9b3796e6f5f0648bae5984f1b8e3013eeac56f
task_temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/design-arc-upgrade-smoke.XXXXXX")
published_checkout="$task_temp_dir/published-0.2.2"
current_checkout="$task_temp_dir/current-0.2.3"
codex_home="$task_temp_dir/codex-home"
projects_root="$task_temp_dir/projects"
plugin_remove_marker="$task_temp_dir/plugin-remove.executed"
marketplace_remove_marker="$task_temp_dir/marketplace-remove.executed"
injected_failure=${DESIGN_ARC_UPGRADE_INJECT_FAILURE:-}

cleanup() {
  [ -n "$task_temp_dir" ] && [ -d "$task_temp_dir" ] && rm -rf "$task_temp_dir"
}

fail() {
  printf '%s\n' "FAIL: $*" >&2
  exit 1
}

snapshot_projects() {
  python3 "$state_helper" snapshot-projects "$projects_root" "$1"
}

rollback_after_failure() {
  failure_point=$1

  CODEX_HOME="$codex_home" "$codex_bin" plugin remove design-arc@design-arc-marketplace --json > "$task_temp_dir/rollback-remove-plugin.json" 2> "$task_temp_dir/rollback-remove-plugin.stderr" || :
  CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace remove design-arc-marketplace --json > "$task_temp_dir/rollback-remove-marketplace.json" 2> "$task_temp_dir/rollback-remove-marketplace.stderr" || :

  if ! CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace add "$published_checkout" --json > "$task_temp_dir/marketplace-restore-0.2.2.json" 2> "$task_temp_dir/marketplace-restore-0.2.2.stderr"
  then
    fail "rollback could not restore the immutable public marketplace after $failure_point"
  fi
  if ! CODEX_HOME="$codex_home" "$codex_bin" plugin add design-arc@design-arc-marketplace --json > "$task_temp_dir/plugin-restore-0.2.2.json" 2> "$task_temp_dir/plugin-restore-0.2.2.stderr"
  then
    fail "rollback could not restore the immutable public plugin after $failure_point"
  fi
  if ! CODEX_HOME="$codex_home" "$codex_bin" plugin list --available --json > "$task_temp_dir/after-rollback.json" 2> "$task_temp_dir/after-rollback.stderr"
  then
    fail "rollback could not read restored plugin state after $failure_point"
  fi
  if ! CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace list --json > "$task_temp_dir/marketplaces-after-rollback.json" 2> "$task_temp_dir/marketplaces-after-rollback.stderr"
  then
    fail "rollback could not read restored marketplace state after $failure_point"
  fi
  snapshot_projects "$task_temp_dir/projects-after.json"

  if ! python3 "$state_helper" validate-restoration \
    "$task_temp_dir/after-rollback.json" \
    "$task_temp_dir/marketplaces-after-rollback.json" \
    "$codex_home" \
    "$published_checkout" \
    "$task_temp_dir/projects-before.json" \
    "$task_temp_dir/projects-after.json" \
    > "$task_temp_dir/rollback-validation.out" 2> "$task_temp_dir/rollback-validation.err"
  then
    sed -n '1,200p' "$task_temp_dir/rollback-validation.err" >&2
    fail "rollback did not exactly restore immutable public 0.2.2 after $failure_point"
  fi
  sed -n '1,200p' "$task_temp_dir/rollback-validation.out"

  if [ "$injected_failure" = "$failure_point" ]
  then
    printf '%s\n' "PASS: restored exact Design Arc 0.2.2 after injected $failure_point failure"
    exit 0
  fi
  fail "upgrade failed at $failure_point; exact immutable public 0.2.2 was restored"
}

trap cleanup EXIT HUP INT TERM

command -v "$codex_bin" >/dev/null 2>&1 || fail "Codex CLI is unavailable: $codex_bin"
[ -f "$state_helper" ] || fail "upgrade state helper is unavailable: $state_helper"
mkdir "$codex_home" "$projects_root"
git clone --quiet --no-local "$repo_root" "$published_checkout"
git -C "$published_checkout" checkout --quiet --detach "$published_sha"
[ "$(git -C "$published_checkout" rev-parse HEAD)" = "$published_sha" ] || fail 'immutable public baseline checkout has the wrong commit'
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
CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace add "$published_checkout" --json > "$task_temp_dir/marketplace-add-0.2.2.json"
CODEX_HOME="$codex_home" "$codex_bin" plugin list --available --json > "$task_temp_dir/baseline-available.json"
python3 "$state_helper" validate-available "$task_temp_dir/baseline-available.json" "$published_checkout" 0.2.2 baseline
CODEX_HOME="$codex_home" "$codex_bin" plugin add design-arc@design-arc-marketplace --json > "$task_temp_dir/plugin-add-0.2.2.json"
CODEX_HOME="$codex_home" "$codex_bin" plugin list --available --json > "$task_temp_dir/before-upgrade.json"

if CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace upgrade design-arc-marketplace --json > "$task_temp_dir/marketplace-upgrade.json" 2> "$task_temp_dir/marketplace-upgrade.stderr"
then
  printf '%s\n' succeeded > "$task_temp_dir/marketplace-upgrade.status"
else
  printf '%s\n' unavailable > "$task_temp_dir/marketplace-upgrade.status"
fi
CODEX_HOME="$codex_home" "$codex_bin" plugin list --available --json > "$task_temp_dir/after-refresh.json"
CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace list --json > "$task_temp_dir/marketplaces-after-refresh.json"

if python3 - "$task_temp_dir/after-refresh.json" <<'PY'
import json
from pathlib import Path
import sys

state = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
installed = state.get("installed")
raise SystemExit(
    0
    if isinstance(installed, list)
    and len(installed) == 1
    and installed[0].get("pluginId") == "design-arc@design-arc-marketplace"
    and installed[0].get("version") == "0.2.3"
    and installed[0].get("enabled") is True
    and installed[0].get("installed") is True
    else 1
)
PY
then
  cp "$task_temp_dir/after-refresh.json" "$task_temp_dir/after-upgrade.json"
  cp "$task_temp_dir/marketplaces-after-refresh.json" "$task_temp_dir/marketplaces-after-upgrade.json"
  printf '%s\n' refresh > "$task_temp_dir/upgrade-route.txt"
else
  cp "$task_temp_dir/after-refresh.json" "$task_temp_dir/preflight-state.json"
  case "$injected_failure" in
    preflight-missing|preflight-disabled|preflight-duplicate|preflight-unexpected-source|preflight-cache-mismatch)
      python3 "$state_helper" inject-preflight "$task_temp_dir/preflight-state.json" "$codex_home" "$injected_failure"
      ;;
  esac

  if ! python3 "$state_helper" validate-baseline \
    "$task_temp_dir/preflight-state.json" \
    "$task_temp_dir/marketplaces-after-refresh.json" \
    "$codex_home" \
    "$published_checkout" \
    > "$task_temp_dir/preflight-validation.out" 2> "$task_temp_dir/preflight-validation.err"
  then
    case "$injected_failure" in
      preflight-missing|preflight-disabled|preflight-duplicate|preflight-unexpected-source|preflight-cache-mismatch)
        CODEX_HOME="$codex_home" "$codex_bin" plugin list --available --json > "$task_temp_dir/preflight-actual-state.json"
        CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace list --json > "$task_temp_dir/preflight-actual-marketplaces.json"
        python3 "$state_helper" validate-preflight-rejection \
          "$task_temp_dir/preflight-actual-state.json" \
          "$task_temp_dir/preflight-actual-marketplaces.json" \
          "$codex_home" \
          "$published_checkout" \
          "$plugin_remove_marker" \
          "$marketplace_remove_marker"
        printf '%s\n' "PASS: fallback preflight rejected $injected_failure without plugin or marketplace removal"
        exit 0
        ;;
    esac
    sed -n '1,200p' "$task_temp_dir/preflight-validation.err" >&2
    fail 'fallback preflight rejected unexpected refreshed baseline state before mutation'
  fi

  fallback_failure=
  if [ "$injected_failure" = plugin-remove ]
  then
    fallback_failure=plugin-remove
  elif CODEX_HOME="$codex_home" "$codex_bin" plugin remove design-arc@design-arc-marketplace --json > "$task_temp_dir/plugin-remove-0.2.2.json" 2> "$task_temp_dir/plugin-remove-0.2.2.stderr"
  then
    printf '%s\n' executed > "$plugin_remove_marker"
  else
    fallback_failure=plugin-remove
  fi

  if [ -z "$fallback_failure" ]
  then
    if [ "$injected_failure" = marketplace-remove ]
    then
      fallback_failure=marketplace-remove
    elif CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace remove design-arc-marketplace --json > "$task_temp_dir/marketplace-remove-0.2.2.json" 2> "$task_temp_dir/marketplace-remove-0.2.2.stderr"
    then
      printf '%s\n' executed > "$marketplace_remove_marker"
    else
      fallback_failure=marketplace-remove
    fi
  fi

  if [ -z "$fallback_failure" ]
  then
    if [ "$injected_failure" = marketplace-add ]
    then
      fallback_failure=marketplace-add
    elif ! CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace add "$current_checkout" --json > "$task_temp_dir/marketplace-add-0.2.3.json" 2> "$task_temp_dir/marketplace-add-0.2.3.stderr"
    then
      fallback_failure=marketplace-add
    fi
  fi

  if [ -z "$fallback_failure" ]
  then
    if [ "$injected_failure" = target-available-read ]
    then
      fallback_failure=target-available-read
    elif ! CODEX_HOME="$codex_home" "$codex_bin" plugin list --available --json > "$task_temp_dir/target-available.json" 2> "$task_temp_dir/target-available.stderr"
    then
      fallback_failure=target-available-read
    fi
  fi

  if [ -z "$fallback_failure" ]
  then
    if [ "$injected_failure" = target-availability ]
    then
      python3 "$state_helper" inject-target "$task_temp_dir/target-available.json"
    fi
    if ! python3 "$state_helper" validate-target "$task_temp_dir/target-available.json" "$current_checkout" > "$task_temp_dir/target-validation.out" 2> "$task_temp_dir/target-validation.err"
    then
      fallback_failure=target-availability
    fi
  fi

  if [ -z "$fallback_failure" ]
  then
    if [ "$injected_failure" = plugin-add ]
    then
      fallback_failure=plugin-add
    elif ! CODEX_HOME="$codex_home" "$codex_bin" plugin add design-arc@design-arc-marketplace --json > "$task_temp_dir/plugin-add-0.2.3.json" 2> "$task_temp_dir/plugin-add-0.2.3.stderr"
    then
      fallback_failure=plugin-add
    fi
  fi

  if [ -n "$fallback_failure" ]
  then
    rollback_after_failure "$fallback_failure"
  fi
  printf '%s\n' remove-add-fallback > "$task_temp_dir/upgrade-route.txt"

  if [ "$injected_failure" = final-plugin-read ]
  then
    rollback_after_failure final-plugin-read
  elif ! CODEX_HOME="$codex_home" "$codex_bin" plugin list --available --json > "$task_temp_dir/after-upgrade.json" 2> "$task_temp_dir/after-upgrade.stderr"
  then
    rollback_after_failure final-plugin-read
  fi

  if [ "$injected_failure" = final-marketplace-read ]
  then
    rollback_after_failure final-marketplace-read
  elif ! CODEX_HOME="$codex_home" "$codex_bin" plugin marketplace list --json > "$task_temp_dir/marketplaces-after-upgrade.json" 2> "$task_temp_dir/marketplaces-after-upgrade.stderr"
  then
    rollback_after_failure final-marketplace-read
  fi
fi

if [ "$injected_failure" = prompt-load ]
then
  rollback_after_failure prompt-load
elif ! (
  cd "$alpha_root"
  CODEX_HOME="$codex_home" "$codex_bin" debug prompt-input "Open this project's existing Design Arc home." > "$task_temp_dir/prompt-input-after.json"
)
then
  rollback_after_failure prompt-load
fi
snapshot_projects "$task_temp_dir/projects-after.json"

if [ "$injected_failure" = preservation-validation ]
then
  rollback_after_failure preservation-validation
fi

upgrade_route=$(sed -n '1p' "$task_temp_dir/upgrade-route.txt")
if ! python3 "$state_helper" validate-final \
  "$task_temp_dir/after-upgrade.json" \
  "$task_temp_dir/marketplaces-after-upgrade.json" \
  "$task_temp_dir/prompt-input-after.json" \
  "$codex_home" \
  "$current_checkout" \
  "$task_temp_dir/projects-before.json" \
  "$task_temp_dir/projects-after.json" \
  "$upgrade_route" \
  > "$task_temp_dir/final-validation.out" 2> "$task_temp_dir/final-validation.err"
then
  rollback_after_failure final-validation
fi
sed -n '1,200p' "$task_temp_dir/final-validation.out"

version=$(sed -n '1p' "$task_temp_dir/codex-version.txt")
printf '%s\n' "PASS: baseline installed/available Design Arc 0.2.2 from immutable local checkout $published_sha"
printf '%s\n' 'PASS: target installed Design Arc 0.2.3; available versions after install: 0'
printf '%s\n' 'PASS: preserved 2 preferences, 2 ready homes, 2 product sentinels, 2 active reviews; new homes: 0; review continuations: 0'
printf '%s\n' "PASS: isolated Design Arc 0.2.2 to 0.2.3 upgrade via $upgrade_route ($version)"
printf '%s\n' 'PASS: isolated Design Arc plugin upgrade smoke'
