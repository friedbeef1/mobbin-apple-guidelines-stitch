#!/bin/sh
# Validate the distributable skill without depending on the caller's directory.

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
repo_root=$(CDPATH= cd "$script_dir/.." && pwd)
plugin_path="$repo_root/plugins/fb-ux"
skill_path="$plugin_path/skills/fb-ux/SKILL.md"
metadata_path=${VALIDATE_OPENAI_YAML:-"$plugin_path/skills/fb-ux/agents/openai.yaml"}
apple_plugin_path="$repo_root/plugins/apple-guidelines-stitch"
apple_skill_path="$apple_plugin_path/skills/apple-guidelines-stitch/SKILL.md"
apple_metadata_path="$apple_plugin_path/skills/apple-guidelines-stitch/agents/openai.yaml"
codex_skills_dir=${CODEX_SKILLS_DIR:-"$HOME/.codex/skills"}
plugin_validator="$codex_skills_dir/.system/plugin-creator/scripts/validate_plugin.py"
skill_validator="$codex_skills_dir/.system/skill-creator/scripts/quick_validate.py"

fail() {
  printf '%s\n' "FAIL: $*" >&2
  exit 1
}

require_file() {
  [ -f "$repo_root/$1" ] || fail "missing required file: $1"
}

require_text() {
  file=$1
  text=$2
  grep -F "$text" "$file" >/dev/null || fail "missing required text in ${file#"$repo_root/"}: $text"
}

for required_file in \
  README.md \
  LICENSE \
  .gitignore \
  examples/prompts.md \
  docs/codex-operating-layer.md \
  docs/validation/behavioral-validation.md \
  .agents/plugins/marketplace.json \
  plugins/fb-ux/.codex-plugin/plugin.json \
  plugins/fb-ux/skills/fb-ux/SKILL.md \
  plugins/fb-ux/skills/fb-ux/agents/openai.yaml \
  plugins/apple-guidelines-stitch/.codex-plugin/plugin.json \
  plugins/apple-guidelines-stitch/skills/apple-guidelines-stitch/SKILL.md \
  plugins/apple-guidelines-stitch/skills/apple-guidelines-stitch/agents/openai.yaml \
  scripts/test-validate.sh \
  scripts/test-test-validate.sh \
  scripts/test-plugin-install.sh \
  scripts/validate.sh
do
  require_file "$required_file"
done
printf '%s\n' 'PASS: required files'

awk '
  NR == 1 { valid = ($0 == "---"); next }
  valid && $0 == "name: fb-ux" { named = 1 }
  valid && $0 == "---" { closed = 1; exit }
  END { exit !(valid && closed && named) }
' "$skill_path" || fail 'SKILL.md must begin with YAML frontmatter containing the exact internal name'
awk '
  NR == 1 { valid = ($0 == "---"); next }
  valid && $0 == "name: apple-guidelines-stitch" { named = 1 }
  valid && $0 == "---" { closed = 1; exit }
  END { exit !(valid && closed && named) }
' "$apple_skill_path" || fail 'Apple Guidelines + Stitch SKILL.md must begin with YAML frontmatter containing the exact internal name'
require_text "$metadata_path" 'display_name: "FB UX"'
require_text "$apple_metadata_path" 'display_name: "Apple Guidelines + Stitch"'
require_text "$repo_root/README.md" 'skills/fb-ux'
require_text "$repo_root/README.md" '$fb-ux'
printf '%s\n' 'PASS: package metadata'

require_text "$repo_root/README.md" 'Install the FB UX Codex plugin from https://github.com/friedbeef1/mobbin-apple-guidelines-stitch'
require_text "$repo_root/README.md" 'Codex handles the installation and may ask for download permission.'
require_text "$repo_root/README.md" '## Advanced/manual installation'
require_text "$repo_root/README.md" 'plugins/fb-ux/skills/fb-ux/'
require_text "$repo_root/README.md" 'plugin containing the `fb-ux` skill'
require_text "$repo_root/README.md" 'Apple, Google, Mobbin, and Stitch integrations are not bundled or official.'
require_text "$repo_root/README.md" 'Guided'
require_text "$repo_root/README.md" 'Follow recommendation'
require_text "$repo_root/README.md" 'Fully automatic'
require_text "$repo_root/README.md" 'Continue only after a `meets direction` verdict'
require_text "$repo_root/docs/codex-operating-layer.md" 'Mobbin and Stitch are external, separately authorized services;'
require_text "$repo_root/README.md" '| Step | Performed in / by | Why it is crucial |'
require_text "$repo_root/docs/codex-operating-layer.md" 'without current-task evidence.'
require_text "$repo_root/README.md" 'and it never authorizes source implementation, staging, deployment, release, destructive or provider changes, or work outside the authorized integration lane.'
require_text "$repo_root/examples/prompts.md" '.codex/fb-ux.yaml'
require_text "$repo_root/docs/codex-operating-layer.md" '# Codex as the operating layer'
require_text "$repo_root/docs/codex-operating-layer.md" '## What Codex contributes'
printf '%s\n' 'PASS: distribution documentation'

[ -f "$plugin_validator" ] || fail 'plugin validator is unavailable'
[ -f "$skill_validator" ] || fail 'skill validator is unavailable'
python3 -u "$plugin_validator" "$plugin_path"
python3 -u "$skill_validator" "$(dirname "$skill_path")"
python3 -u "$plugin_validator" "$apple_plugin_path"
python3 -u "$skill_validator" "$(dirname "$apple_skill_path")"
printf '%s\n' 'PASS: plugin and embedded skill validation for both packages'

if grep -R -i -F 'mobbin' "$apple_plugin_path" >/dev/null
then
  fail 'apple-guidelines-stitch package must not reference Mobbin'
fi
printf '%s\n' 'PASS: Apple Guidelines + Stitch package has no Mobbin references'

for required_text in 'Objective Confirmation' 'Follow your recommendation' 'Bypass both gates'
do
  require_text "$skill_path" "$required_text"
  require_text "$repo_root/README.md" "$required_text"
done
printf '%s\n' 'PASS: workflow phrases'

require_text "$skill_path" 'record the active mode and whether it came from the saved project preference or an explicit one-run override'
require_text "$skill_path" 'never attribute the selection to the saved preference when an explicit one-run override is active'
require_text "$repo_root/docs/validation/behavioral-validation.md" 'plugins/fb-ux/skills/fb-ux/SKILL.md'
require_text "$repo_root/docs/validation/behavioral-validation.md" '| Guided |'
require_text "$repo_root/docs/validation/behavioral-validation.md" '| Follow recommendation |'
require_text "$repo_root/docs/validation/behavioral-validation.md" '| Fully automatic |'
require_text "$repo_root/docs/validation/behavioral-validation.md" 'Explicit objective required'
require_text "$repo_root/docs/validation/behavioral-validation.md" 'Saved preference'
require_text "$repo_root/docs/validation/behavioral-validation.md" 'One-run override precedence'
printf '%s\n' 'PASS: approval-mode provenance and current behavioral evidence'

private_key_prefix='-----BEGIN '
private_key_marker='PRIVATE KEY'
private_key_suffix='-----'
private_key_pattern="${private_key_prefix}[A-Z ]*${private_key_marker}[ A-Z-]*${private_key_suffix}"
credential_pattern='^[[:space:]]*((export|env)[[:space:]]+)*([A-Z0-9]+[_-])?(API[_-]?KEY|ACCESS[_-]?KEY([_-]?ID)?|AUTH[_-]?TOKEN|CLIENT[_-]?SECRET|GITHUB[_-]?TOKEN|OPENAI[_-]?API[_-]?KEY|AWS[_-]?ACCESS[_-]?KEY([_-]?ID)?|PASSWORD|PRIVATE[_-]?KEY|SECRET|TOKEN)[[:space:]]*[:=][[:space:]]*[^[:space:]#]'

contains_private_material() {
  scan_root=$1
  find "$scan_root" \
    \( -path "$scan_root/.git" -o -path "$scan_root/.worktrees" -o -path "$scan_root/.superpowers" \) -prune -o \
    -type f \
    -exec grep -i -E -e "$private_key_pattern" -e "$credential_pattern" {} \; | grep . >/dev/null
}

if contains_private_material "$repo_root"
then
  fail 'private key or credential assignment found'
fi

if [ -n "${VALIDATE_EXTRA_SCAN_ROOT:-}" ]
then
  [ -d "$VALIDATE_EXTRA_SCAN_ROOT" ] || fail 'VALIDATE_EXTRA_SCAN_ROOT must name a directory'
  if contains_private_material "$VALIDATE_EXTRA_SCAN_ROOT"
  then
    fail 'private key or credential assignment found'
  fi
fi

user_path_prefix='/''Users/'
if find "$repo_root" \
  \( -path "$repo_root/.git" -o -path "$repo_root/.worktrees" -o -path "$repo_root/.superpowers" \) -prune -o \
  -type f \
  ! -path "$repo_root/docs/superpowers/plans/*" \
  ! -path "$repo_root/docs/superpowers/specs/*" \
  -exec grep -l -F "$user_path_prefix" {} \; | grep . >/dev/null
then
  fail "local ${user_path_prefix} path found outside historical design/plan docs"
fi

artifact_pattern='\.(png|jpe?g|gif|webp|avif|heic|svg|psd|psb|ai|sketch|fig|xd|afdesign|afphoto|indd|eps|tiff?|bmp|raw|dng|cr2|nef|mp4|mov|m4v|avi|webm|mkv|wmv|flv|mp3|wav|aac|m4a|flac|ogg|aiff)$'
if find "$repo_root" \
  \( -path "$repo_root/.git" -o -path "$repo_root/.worktrees" -o -path "$repo_root/.superpowers" \) -prune -o \
  -type f \
  -print | grep -i -E "$artifact_pattern" >/dev/null
then
  fail 'proprietary image or media artifact found'
fi
printf '%s\n' 'PASS: safety scan'

sh "$repo_root/scripts/test-plugin-install.sh"

if git -C "$repo_root" rev-parse --is-inside-work-tree >/dev/null 2>&1
then
  git -C "$repo_root" diff --check
  printf '%s\n' 'PASS: git diff check'
else
  printf '%s\n' 'PASS: git diff check skipped (not a worktree)'
fi

printf '%s\n' 'PASS: repository validation'
