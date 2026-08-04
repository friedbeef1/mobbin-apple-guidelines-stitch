#!/bin/sh
# Prove that common shell-prefixed credential assignments are rejected.

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
validator="$script_dir/validate.sh"
temporary_dirs=''

cleanup() {
  for temporary_dir in $temporary_dirs
  do
    rm -rf "$temporary_dir"
  done
}

fail() {
  printf '%s\n' "FAIL: $*" >&2
  exit 1
}

trap cleanup EXIT HUP INT TERM

expect_credential_rejection() {
  label=$1
  assignment=$2
  case_dir=$(mktemp -d "${TMPDIR:-/tmp}/mobbin-validator-${label}.XXXXXX")
  temporary_dirs="$temporary_dirs $case_dir"
  printf '%s\n' "$assignment" > "$case_dir/fixture.env"

  if output=$(VALIDATE_EXTRA_SCAN_ROOT="$case_dir" "$validator" 2>&1)
  then
    printf '%s\n' "$output" >&2
    fail "$label credential fixture was accepted"
  fi

  printf '%s\n' "$output" | grep -F 'FAIL: private key or credential assignment found' >/dev/null || {
    printf '%s\n' "$output" >&2
    fail "$label credential fixture failed for the wrong reason"
  }
  printf '%s\n' "PASS: rejected $label credential assignment"
}

github_token_name='GITHUB_''TOKEN'
openai_key_name='OPENAI_''API_KEY'

expect_credential_rejection export "export ${github_token_name}=test-placeholder"
expect_credential_rejection env "env ${openai_key_name}=test-placeholder"
expect_credential_rejection repeated-prefixes "export env ${github_token_name}=test-placeholder"

printf '%s\n' 'PASS: validator negative cases'
