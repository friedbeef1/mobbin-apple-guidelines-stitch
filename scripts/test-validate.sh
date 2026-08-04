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

repo_root=$(CDPATH= cd "$script_dir/.." && pwd)
[ -f "$repo_root/skills/fb-ux/SKILL.md" ] || fail 'canonical skill path must be skills/fb-ux'
grep -F 'name: fb-ux' "$repo_root/skills/fb-ux/SKILL.md" >/dev/null || fail 'SKILL.md must use the fb-ux internal name'
grep -F '$fb-ux' "$repo_root/README.md" >/dev/null || fail 'README must document the $fb-ux invocation'
legacy_skill_name='validating-ui-with-''guidelines-and-mobbin'
if grep -R -F "$legacy_skill_name" \
  "$repo_root/README.md" \
  "$repo_root/docs" \
  "$repo_root/examples" \
  "$repo_root/scripts" \
  "$repo_root/skills" >/dev/null
then
  fail 'legacy skill name remains in the distributable documentation or package'
fi
printf '%s\n' 'PASS: fb-ux identity'
