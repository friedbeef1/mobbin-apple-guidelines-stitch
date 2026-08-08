#!/bin/sh
# Regress cleanup and prove the validation harness fails closed on a broken CLI subcheck.

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
repo_root=$(CDPATH= cd "$script_dir/.." && pwd)
task_temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/design-arc-test-validate-regression.XXXXXX")
whitespace_tmpdir="$task_temp_dir/tmp with spaces"
split_target="$task_temp_dir/with"
sentinel="$split_target/must-survive"
failing_codex="$task_temp_dir/failing-codex"
missing_source_checkout="$task_temp_dir/missing-trusted-source"

cleanup() {
  [ -n "$task_temp_dir" ] && [ -d "$task_temp_dir" ] && rm -rf "$task_temp_dir"
}

fail() {
  printf '%s\n' "FAIL: $*" >&2
  exit 1
}

trap cleanup EXIT HUP INT TERM

mkdir -p "$whitespace_tmpdir" "$sentinel"

(
  cd "$task_temp_dir"
  TMPDIR="$whitespace_tmpdir" sh "$script_dir/test-validate.sh"
) >/dev/null 2>&1

[ -d "$sentinel" ] || fail 'test-validate cleanup targeted a split TMPDIR path'
printf '%s\n' 'PASS: test-validate cleanup preserves split-path sentinels with whitespace TMPDIR'

cp -R "$repo_root" "$missing_source_checkout"
missing_source_file="$missing_source_checkout/docs/trusted-sources/README.md"
[ -f "$missing_source_file" ] || fail 'temporary checkout is missing trusted-sources README fixture'
rm "$missing_source_file"

if output=$(sh "$missing_source_checkout/scripts/validate.sh" 2>&1)
then
  printf '%s\n' "$output" >&2
  fail 'repository validator accepted a missing trusted-sources README'
fi

printf '%s\n' "$output" | grep -F 'FAIL: missing required file: docs/trusted-sources/README.md' >/dev/null || {
  printf '%s\n' "$output" >&2
  fail 'repository validator failed for the wrong missing trusted-sources README reason'
}
printf '%s\n' 'PASS: repository validator rejects a missing trusted-sources README'

printf '%s\n' '#!/bin/sh' 'printf "%s\n" "deliberate Codex CLI failure" >&2' 'exit 97' > "$failing_codex"
chmod +x "$failing_codex"

if CODEX_BIN="$failing_codex" sh "$script_dir/test-plugin-install.sh" >/dev/null 2>&1
then
  fail 'fresh-install harness accepted a deliberately failing Codex CLI'
fi

if CODEX_BIN="$failing_codex" sh "$script_dir/test-plugin-migration.sh" >/dev/null 2>&1
then
  fail 'migration harness accepted a deliberately failing Codex CLI'
fi

if CODEX_BIN="$failing_codex" sh "$script_dir/test-plugin-upgrade.sh" >/dev/null 2>&1
then
  fail 'upgrade harness accepted a deliberately failing Codex CLI'
fi

for failure_point in \
  preflight-missing \
  preflight-disabled \
  preflight-duplicate \
  preflight-unexpected-source \
  preflight-cache-mismatch
do
  preflight_output=$(DESIGN_ARC_UPGRADE_INJECT_FAILURE="$failure_point" sh "$script_dir/test-plugin-upgrade.sh") || {
    printf '%s\n' "$preflight_output" >&2
    fail "upgrade preflight scenario failed at $failure_point"
  }
  printf '%s\n' "$preflight_output" | grep -F "PASS: fallback preflight rejected $failure_point without plugin or marketplace removal" >/dev/null || {
    printf '%s\n' "$preflight_output" >&2
    fail "upgrade preflight scenario did not fail closed at $failure_point"
  }
done

for failure_point in \
  plugin-remove \
  marketplace-remove \
  marketplace-add \
  target-available-read \
  target-availability \
  plugin-add \
  final-plugin-read \
  final-marketplace-read \
  prompt-load \
  preservation-validation
do
  rollback_output=$(DESIGN_ARC_UPGRADE_INJECT_FAILURE="$failure_point" sh "$script_dir/test-plugin-upgrade.sh") || {
    printf '%s\n' "$rollback_output" >&2
    fail "upgrade rollback scenario failed at $failure_point"
  }
  printf '%s\n' "$rollback_output" | grep -F "PASS: restored exact Design Arc 0.2.1 after injected $failure_point failure" >/dev/null || {
    printf '%s\n' "$rollback_output" >&2
    fail "upgrade rollback scenario did not prove exact restoration at $failure_point"
  }
done

if output=$(CODEX_BIN="$failing_codex" sh "$script_dir/validate.sh" 2>&1)
then
  printf '%s\n' "$output" >&2
  fail 'repository validator accepted a deliberately failing installation subcheck'
fi

printf '%s\n' "$output" | grep -F 'FAIL: isolated plugin installation smoke failed' >/dev/null || {
  printf '%s\n' "$output" >&2
  fail 'repository validator failed for the wrong deliberate-subcheck reason'
}

[ -d "$sentinel" ] || fail 'deliberate failure cleanup removed a split-path sentinel'
printf '%s\n' 'PASS: install, migration, upgrade, and repository harnesses fail closed without source mutation'
