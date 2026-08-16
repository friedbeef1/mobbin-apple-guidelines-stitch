#!/bin/sh
# Verify the canonical Design Arc package identity and marketplace layout.

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
repo_root=$(CDPATH= cd "$script_dir/.." && pwd)
plugin_path="$repo_root/plugins/design-arc"
plugin_manifest="$plugin_path/.codex-plugin/plugin.json"
skill_path="$plugin_path/skills/design-arc/SKILL.md"
metadata_path="$plugin_path/skills/design-arc/agents/openai.yaml"
marketplace_manifest="$repo_root/.agents/plugins/marketplace.json"
codex_skills_dir=${CODEX_SKILLS_DIR:-"$HOME/.codex/skills"}
plugin_validator="$codex_skills_dir/.system/plugin-creator/scripts/validate_plugin.py"
skill_validator="$codex_skills_dir/.system/skill-creator/scripts/quick_validate.py"

fail() {
  printf '%s\n' "FAIL: $*" >&2
  exit 1
}

for required_file in "$plugin_manifest" "$skill_path" "$metadata_path" "$marketplace_manifest"
do
  [ -f "$required_file" ] || fail "missing Design Arc identity file: ${required_file#"$repo_root/"}"
done

[ ! -e "$repo_root/plugins/fb-ux" ] || fail 'legacy fb-ux package remains active in the repository tree'
[ ! -e "$repo_root/plugins/apple-guidelines-stitch" ] || fail 'legacy apple-guidelines-stitch package remains active in the repository tree'

[ -f "$plugin_validator" ] || fail 'plugin validator is unavailable'
[ -f "$skill_validator" ] || fail 'skill validator is unavailable'
python3 "$plugin_validator" "$plugin_path"
python3 "$skill_validator" "$(dirname "$skill_path")"

python3 - "$plugin_manifest" "$marketplace_manifest" "$metadata_path" <<'PY'
import json
import sys
from pathlib import Path

plugin_path, marketplace_path, metadata_path = map(Path, sys.argv[1:])
plugin = json.loads(plugin_path.read_text(encoding="utf-8"))
marketplace = json.loads(marketplace_path.read_text(encoding="utf-8"))
metadata = metadata_path.read_text(encoding="utf-8")

expected_plugin = {
    "name": "design-arc",
    "version": "0.4.0",
    "description": "Outcome-led UI journey design for Codex.",
    "skills": "./skills/",
    "author": {"name": "James Yeang"},
    "repository": "https://github.com/friedbeef1/design-arc",
    "license": "MIT",
    "keywords": ["ux", "journey-design", "outcomes", "evidence"],
    "interface": {
        "displayName": "Design Arc",
        "shortDescription": "Turn ambiguous UI feedback into complete, evidence-grounded journeys.",
        "longDescription": "Turn a confirmed product outcome into a complete UI journey with evidence, clear trade-offs, and explicit approval gates.",
        "developerName": "James Yeang",
        "category": "Productivity",
        "capabilities": ["Outcome-led journey design", "Evidence-grounded validation"],
        "defaultPrompt": [
            "$design-arc Help me make our onboarding less confusing.",
            "$design-arc Audit how customers complete checkout and propose a better complete journey.",
            "$design-arc Redesign account recovery so people can get back in without weakening security.",
        ],
    },
}
if plugin != expected_plugin:
    raise SystemExit("Design Arc manifest must match the canonical identity contract")

expected_marketplace = {
    "name": "design-arc-marketplace",
    "interface": {"displayName": "Design Arc"},
    "plugins": [
        {
            "name": "design-arc",
            "source": {"source": "local", "path": "./plugins/design-arc"},
            "policy": {"installation": "AVAILABLE", "authentication": "ON_INSTALL"},
            "category": "Productivity",
        }
    ],
}
if marketplace != expected_marketplace:
    raise SystemExit("marketplace must expose exactly the canonical Design Arc entry")

expected_metadata = '''interface:
  display_name: "Design Arc"
  short_description: "Turn ambiguous UI feedback into complete, evidence-grounded journeys"
  default_prompt: "$design-arc Help me make this product journey less confusing."
'''
if metadata != expected_metadata:
    raise SystemExit("Design Arc agent metadata must match the canonical identity contract")
PY

printf '%s\n' 'PASS: Design Arc identity'
