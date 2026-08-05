#!/bin/sh
# Prove that common shell-prefixed credential assignments are rejected.

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
validator="$script_dir/validate.sh"
task_temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/mobbin-validator-tests.XXXXXX")

cleanup() {
  rm -rf "$task_temp_dir"
}

fail() {
  printf '%s\n' "FAIL: $*" >&2
  exit 1
}

trap cleanup EXIT HUP INT TERM

expect_credential_rejection() {
  label=$1
  assignment=$2
  case_dir="$task_temp_dir/$label"
  mkdir "$case_dir"
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
codex_skills_dir=${CODEX_SKILLS_DIR:-"$HOME/.codex/skills"}
plugin_path="$repo_root/plugins/fb-ux"
plugin_manifest="$plugin_path/.codex-plugin/plugin.json"
marketplace_manifest="$repo_root/.agents/plugins/marketplace.json"
skill_path="$plugin_path/skills/fb-ux/SKILL.md"

missing_layout=''
[ -f "$plugin_manifest" ] || missing_layout="$missing_layout $plugin_manifest"
[ -f "$marketplace_manifest" ] || missing_layout="$missing_layout $marketplace_manifest"
[ -f "$skill_path" ] || missing_layout="$missing_layout $skill_path"
[ -z "$missing_layout" ] || fail "canonical plugin and marketplace layout is missing:$missing_layout"

python3 "$codex_skills_dir/.system/plugin-creator/scripts/validate_plugin.py" "$plugin_path"
python3 "$codex_skills_dir/.system/skill-creator/scripts/quick_validate.py" "$(dirname "$skill_path")"

python3 - "$plugin_manifest" "$marketplace_manifest" <<'PY'
import json
import sys

plugin_path, marketplace_path = sys.argv[1:]
plugin = json.load(open(plugin_path, encoding="utf-8"))
marketplace = json.load(open(marketplace_path, encoding="utf-8"))

expected_plugin = {
    "name": "fb-ux",
    "version": "0.1.0",
    "skills": "./skills/",
    "license": "MIT",
    "repository": "https://github.com/friedbeef1/mobbin-apple-guidelines-stitch",
}
for key, expected in expected_plugin.items():
    if plugin.get(key) != expected:
        raise SystemExit(f"plugin {key} must be {expected!r}")
if plugin.get("author", {}).get("name") != "James Yeang":
    raise SystemExit("plugin author must be James Yeang")
if plugin.get("interface", {}).get("displayName") != "FB UX":
    raise SystemExit("plugin display name must be FB UX")
if plugin.get("interface", {}).get("category") != "Productivity":
    raise SystemExit("plugin category must be Productivity")
if not isinstance(plugin.get("interface", {}).get("defaultPrompt"), list):
    raise SystemExit("plugin defaultPrompt must be a list")
if len(plugin["interface"]["defaultPrompt"]) > 3:
    raise SystemExit("plugin defaultPrompt must contain at most three prompts")
for forbidden in ("apps", "mcpServers", "hooks"):
    if forbidden in plugin:
        raise SystemExit(f"plugin must not declare {forbidden}")

expected_entry = {
    "name": "fb-ux",
    "source": {"source": "local", "path": "./plugins/fb-ux"},
    "policy": {"installation": "AVAILABLE", "authentication": "ON_INSTALL"},
    "category": "Productivity",
}
if marketplace.get("plugins") != [expected_entry]:
    raise SystemExit("marketplace must expose the canonical fb-ux plugin entry")
PY

grep -F 'name: fb-ux' "$skill_path" >/dev/null || fail 'SKILL.md must use the fb-ux internal name'
grep -F '$fb-ux' "$repo_root/README.md" >/dev/null || fail 'README must document the $fb-ux invocation'
legacy_skill_name='validating-ui-with-''guidelines-and-mobbin'
if grep -R -F "$legacy_skill_name" \
  "$repo_root/README.md" \
  "$repo_root/docs" \
  "$repo_root/examples" \
  "$repo_root/scripts" \
  "$repo_root/plugins" >/dev/null
then
  fail 'legacy skill name remains in the distributable documentation or package'
fi
printf '%s\n' 'PASS: fb-ux identity'

if validation_output=$("$validator" 2>&1)
then
  :
else
  printf '%s\n' "$validation_output" >&2
  fail 'repository validation failed while checking installation smoke coverage'
fi

printf '%s\n' "$validation_output" | grep -F 'PASS: isolated plugin installation smoke' >/dev/null || {
  printf '%s\n' "$validation_output" >&2
  fail 'repository validation did not run the isolated plugin installation smoke'
}
printf '%s\n' 'PASS: repository validation runs isolated plugin installation smoke'
