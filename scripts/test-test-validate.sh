#!/bin/sh
# Regress test-validate.sh cleanup when TMPDIR contains spaces.

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
task_temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/fb-ux-test-validate-regression.XXXXXX")
whitespace_tmpdir="$task_temp_dir/tmp with spaces"
split_target="$task_temp_dir/with"
sentinel="$split_target/must-survive"

cleanup() {
  rm -rf "$task_temp_dir"
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
) >/dev/null

[ -d "$sentinel" ] || fail 'test-validate cleanup targeted a split TMPDIR path'

printf '%s\n' 'PASS: test-validate cleanup preserves split-path sentinels with whitespace TMPDIR'
