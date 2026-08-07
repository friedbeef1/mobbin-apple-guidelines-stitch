#!/bin/sh
# Regress cleanup and prove the validation harness fails closed on a broken CLI subcheck.

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
task_temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/design-arc-test-validate-regression.XXXXXX")
whitespace_tmpdir="$task_temp_dir/tmp with spaces"
split_target="$task_temp_dir/with"
sentinel="$split_target/must-survive"
failing_codex="$task_temp_dir/failing-codex"

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
