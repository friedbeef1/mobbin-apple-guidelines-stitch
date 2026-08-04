#!/bin/sh
# Validate the distributable skill without depending on the caller's directory.

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
repo_root=$(CDPATH= cd "$script_dir/.." && pwd)
skill_path="$repo_root/skills/validating-ui-with-guidelines-and-mobbin/SKILL.md"
metadata_path=${VALIDATE_OPENAI_YAML:-"$repo_root/skills/validating-ui-with-guidelines-and-mobbin/agents/openai.yaml"}

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
  docs/validation/behavioral-validation.md \
  skills/validating-ui-with-guidelines-and-mobbin/SKILL.md \
  skills/validating-ui-with-guidelines-and-mobbin/agents/openai.yaml \
  scripts/validate.sh
do
  require_file "$required_file"
done
printf '%s\n' 'PASS: required files'

awk '
  NR == 1 { valid = ($0 == "---"); next }
  valid && $0 == "name: validating-ui-with-guidelines-and-mobbin" { named = 1 }
  valid && $0 == "---" { closed = 1; exit }
  END { exit !(valid && closed && named) }
' "$skill_path" || fail 'SKILL.md must begin with YAML frontmatter containing the exact internal name'
require_text "$metadata_path" 'Mobbin - Apple Guidelines - Stitch'
require_text "$repo_root/README.md" 'skills/validating-ui-with-guidelines-and-mobbin'
printf '%s\n' 'PASS: package metadata'

for required_text in 'Objective Confirmation' 'Follow your recommendation' 'Bypass both gates'
do
  require_text "$skill_path" "$required_text"
  require_text "$repo_root/README.md" "$required_text"
done
printf '%s\n' 'PASS: workflow phrases'

private_key_prefix='-----BEGIN '
private_key_marker='PRIVATE KEY'
private_key_suffix='-----'
private_key_pattern="${private_key_prefix}[A-Z ]*${private_key_marker}[ A-Z-]*${private_key_suffix}"
credential_pattern='^[[:space:]]*([A-Z0-9]+[_-])?(API[_-]?KEY|ACCESS[_-]?KEY([_-]?ID)?|AUTH[_-]?TOKEN|CLIENT[_-]?SECRET|GITHUB[_-]?TOKEN|OPENAI[_-]?API[_-]?KEY|AWS[_-]?ACCESS[_-]?KEY([_-]?ID)?|PASSWORD|PRIVATE[_-]?KEY|SECRET|TOKEN)[[:space:]]*[:=][[:space:]]*[^[:space:]#]'

if find "$repo_root" \
  \( -path "$repo_root/.git" -o -path "$repo_root/.worktrees" -o -path "$repo_root/.superpowers" \) -prune -o \
  -type f \
  -exec grep -i -E -e "$private_key_pattern" -e "$credential_pattern" {} \; | grep . >/dev/null
then
  fail 'private key or credential assignment found'
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

if git -C "$repo_root" rev-parse --is-inside-work-tree >/dev/null 2>&1
then
  git -C "$repo_root" diff --check
  printf '%s\n' 'PASS: git diff check'
else
  printf '%s\n' 'PASS: git diff check skipped (not a worktree)'
fi

printf '%s\n' 'PASS: repository validation'
