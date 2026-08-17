#!/bin/sh
# Validate Design Arc's public product story and documentation boundaries.

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
repo_root=$(CDPATH= cd "$script_dir/.." && pwd)
task_temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/design-arc-docs.XXXXXX")

cleanup() {
  [ -n "$task_temp_dir" ] && [ -d "$task_temp_dir" ] && rm -rf "$task_temp_dir"
}

fail() {
  printf '%s\n' "FAIL: $*" >&2
  exit 1
}

trap cleanup EXIT HUP INT TERM

require_text() {
  file=$1
  text=$2
  grep -F "$text" "$file" >/dev/null || fail "missing required text in ${file#"$repo_root/"}: $text"
}

forbid_text() {
  file=$1
  text=$2
  if grep -F "$text" "$file" >/dev/null
  then
    fail "forbidden text remains in ${file#"$repo_root/"}: $text"
  fi
}

copy_fixture() {
  destination=$1
  mkdir -p "$destination"
  (
    cd "$repo_root"
    tar --exclude=.git --exclude=.superpowers -cf - .
  ) | (
    cd "$destination"
    tar -xf -
  )
}

readme="$repo_root/README.md"
getting_started="$repo_root/docs/getting-started.md"
using_design_arc="$repo_root/docs/using-design-arc.md"
codex_edition="$repo_root/docs/codex.md"
claude_edition="$repo_root/docs/claude-code.md"
antigravity_edition="$repo_root/docs/antigravity.md"
advanced_controls="$repo_root/docs/advanced-controls.md"
evidence_methodology="$repo_root/docs/evidence-and-methodology.md"
upgrades_migration="$repo_root/docs/upgrades-and-migration.md"
migration_history="$repo_root/docs/migration-history.md"
trust_sources="$repo_root/docs/trust-limitations-and-sources.md"
faq="$repo_root/docs/faq.md"
operating_layer="$repo_root/docs/codex-operating-layer.md"
runtime_boundaries="$repo_root/docs/runtime-boundaries.md"
behavioral_validation="$repo_root/docs/validation/behavioral-validation.md"
prompts="$repo_root/examples/prompts.md"
motion_sources="$repo_root/docs/trusted-sources/motion.md"
trusted_source_library="$repo_root/docs/trusted-sources/README.md"
visualization_sources="$repo_root/docs/trusted-sources/visualization.md"
shared_navigation='[Home](../README.md) · [Getting started](getting-started.md) · [Using Design Arc](using-design-arc.md) · [Codex](codex.md) · [Claude Code](claude-code.md) · [Google Antigravity](antigravity.md) · [FAQ](faq.md) · [Runtime boundaries](runtime-boundaries.md) · [Advanced controls](advanced-controls.md) · [Evidence and methodology](evidence-and-methodology.md) · [Upgrades and migration](upgrades-and-migration.md) · [Migration history](migration-history.md) · [Trust and sources](trust-limitations-and-sources.md)'
historical_navigation='[Home](../README.md) · [Getting started](getting-started.md) · [Using Design Arc](using-design-arc.md) · [Codex](codex.md) · [Claude Code](claude-code.md) · [FAQ](faq.md) · [Runtime boundaries](runtime-boundaries.md) · [Advanced controls](advanced-controls.md) · [Evidence and methodology](evidence-and-methodology.md) · [Upgrades and migration](upgrades-and-migration.md) · [Migration history](migration-history.md) · [Trust and sources](trust-limitations-and-sources.md)'

for file in "$readme" "$getting_started" "$using_design_arc" "$codex_edition" "$claude_edition" "$antigravity_edition" "$faq" "$advanced_controls" "$evidence_methodology" "$upgrades_migration" "$migration_history" "$trust_sources" "$operating_layer" "$runtime_boundaries" "$behavioral_validation" "$prompts" "$motion_sources" "$trusted_source_library" "$visualization_sources"
do
  [ -f "$file" ] || fail "missing required documentation: ${file#"$repo_root/"}"
done

require_text "$readme" '[FAQ](docs/faq.md)'
require_text "$readme" 'One Design Arc, available for Codex, Claude Code, and Google Antigravity.'
require_text "$readme" '[Design Arc for Codex](docs/codex.md)'
require_text "$readme" '[Design Arc for Claude Code](docs/claude-code.md)'
require_text "$readme" '[Design Arc for Google Antigravity](docs/antigravity.md)'
require_text "$codex_edition" '## What stays the same'
require_text "$codex_edition" 'pinned project home'
require_text "$claude_edition" '## What stays the same'
require_text "$claude_edition" 'Claude Code does not create a Codex project home.'
require_text "$antigravity_edition" '# Design Arc for Google Antigravity'
require_text "$antigravity_edition" 'agy plugin install https://github.com/friedbeef1/design-arc'
require_text "$antigravity_edition" '`/design-arc`'
require_text "$antigravity_edition" 'standalone, IDE, and CLI surfaces when that surface has loaded this extension'
require_text "$antigravity_edition" 'The repository test suite validates the packaged Antigravity adapter and its written contracts.'
require_text "$antigravity_edition" 'It does not by itself prove a plugin install or `/design-arc` load on standalone, IDE, or CLI.'
require_text "$antigravity_edition" 'Google Antigravity owns `.gemini/design-arc.yaml`, `.gemini/design-arc-active-review.json`, and review artifacts under `.gemini/design-arc/reviews/`.'
require_text "$antigravity_edition" 'Never import, merge, migrate, resume, or continue an active review across runtimes.'
require_text "$antigravity_edition" 'Only when `.gemini/design-arc.yaml` is absent can Design Arc offer a one-time, explicitly confirmed preference import from Codex or Claude Code.'
require_text "$antigravity_edition" 'If both source preferences exist, choose exactly one validated source; Design Arc never merges them.'
require_text "$antigravity_edition" 'lightweight static journey board with HTML/CSS, SVG, or specifications'
require_text "$antigravity_edition" 'does not claim native image generation'
require_text "$antigravity_edition" 'Stitch remains optional and separately authorized.'
require_text "$antigravity_edition" 'The extension installation does not authorize benchmark, browser, visualization, MCP, provider, or product access.'
require_text "$antigravity_edition" 'Use a supported Google Antigravity extension update route.'
require_text "$faq" '## What is a project home?'
require_text "$faq" '## Are the Codex, Claude Code, and Google Antigravity editions different products?'
require_text "$faq" 'Project homes are a Codex-only return-path feature.'
require_text "$faq" 'For approval, naming, reuse, and returning later, read [Design Arc for Codex](codex.md).'
require_text "$faq" 'For Claude Code’s distinct return path, read [Design Arc for Claude Code](claude-code.md).'
for forbidden_shared_lifecycle in \
  'A project home is an optional pinned Codex task for one particular product.' \
  'The Design Arc plugin is installed once on your laptop; each participating product may have one separate project home. Claude Code does not use project homes. It uses an optional project reminder instead.' \
  'Codex users can also return through their pinned project home.'
do
  forbid_text "$faq" "$forbidden_shared_lifecycle"
done

python3 - "$readme" <<'PY'
from pathlib import Path
import sys

text = Path(sys.argv[1]).read_text(encoding="utf-8")
line_count = len(text.splitlines())
if not 80 <= line_count <= 130:
    raise SystemExit(f"FAIL: README must contain 80-130 lines; found {line_count}")

ask_codex_instruction = "**Ask Codex:** Install the Design Arc plugin from\nhttps://github.com/friedbeef1/design-arc"
if ask_codex_instruction not in text:
    raise SystemExit("FAIL: README is missing the exact Ask Codex installation instruction")

for forbidden_text in ("```sh", "codex plugin", "skills registry", "Python", "Saved preferences and migration", "If Codex says"):
    if forbidden_text in text:
        raise SystemExit(f"FAIL: README retains forbidden advanced-installation content: {forbidden_text}")
PY

python3 - "$repo_root" <<'PY'
from pathlib import Path
import re
import sys
from urllib.parse import unquote

repository_root = Path(sys.argv[1]).resolve()
documentation_pages = sorted(
    [repository_root / "README.md"]
    + list((repository_root / "docs").glob("*.md"))
    + list((repository_root / "docs" / "trusted-sources").glob("*.md"))
    + [repository_root / "examples" / "prompts.md"]
)


def heading_fragments(page):
    fragments = set()
    occurrences = {}
    for line in page.read_text(encoding="utf-8").splitlines():
        match = re.match(r"^#{1,6}\s+(.+?)\s*#*\s*$", line)
        if not match:
            continue
        heading = re.sub(r"<[^>]+>", "", match.group(1))
        heading = re.sub(r"[`*_~]", "", heading).strip().lower()
        slug = "".join(character for character in heading if character.isalnum() or character in " _-")
        slug = re.sub(r"\s+", "-", slug)
        occurrence = occurrences.get(slug, 0)
        occurrences[slug] = occurrence + 1
        fragments.add(slug if occurrence == 0 else f"{slug}-{occurrence}")
    return fragments

for source in documentation_pages:
    for target in re.findall(r"\[[^\]]+\]\(([^)]+)\)", source.read_text(encoding="utf-8")):
        if target.startswith(("http://", "https://", "mailto:")):
            continue
        relative_path, separator, fragment = target.partition("#")
        resolved = (source.parent / relative_path).resolve() if relative_path else source.resolve()
        try:
            resolved.relative_to(repository_root)
        except ValueError:
            raise SystemExit(f"FAIL: relative link escapes repository in {source}: {target}")
        if not resolved.exists():
            raise SystemExit(f"FAIL: broken relative link in {source}: {target}")
        if separator and resolved.suffix.lower() == ".md" and unquote(fragment) not in heading_fragments(resolved):
            raise SystemExit(f"FAIL: broken Markdown fragment in {source}: {target}")

print(f"PASS: repository-relative Markdown links and fragments resolve across {len(documentation_pages)} public pages")
PY

require_text "$readme" '# Design Arc'
require_text "$readme" 'Product feedback is often vague, redesign discussions become subjective, and teams approve attractive screens without knowing whether the complete journey works.'
require_text "$readme" 'Move from uncertain product feedback to a complete design direction grounded in credible sources.'
require_text "$readme" 'Design Arc audits the real journey, checks decisions against current first-party platform guidance and inspected real-product journeys, recommends the strongest path, and designs every important state before implementation begins.'
require_text "$readme" '## You need Design Arc if…'
require_text "$readme" '## What Design Arc produces'
require_text "$readme" '## One product, three platform editions'
require_text "$readme" '| Use | Choose it when | Start Design Arc |'
require_text "$readme" 'The product and workflow are shared. Start with Design Arc, then use the runtime page for the active host when installation, saved state, return paths, or visual capabilities differ.'
require_text "$readme" '[Codex runtime details](docs/codex.md)'
require_text "$readme" '[Claude Code runtime details](docs/claude-code.md)'
require_text "$readme" '[Runtime boundaries](docs/runtime-boundaries.md)'
require_text "$readme" '## The workflow'
require_text "$readme" '## Documentation'
require_text "$readme" '[Getting started](docs/getting-started.md)'
require_text "$readme" '[Using Design Arc](docs/using-design-arc.md)'
require_text "$readme" '[Advanced controls](docs/advanced-controls.md)'
require_text "$readme" '[Evidence and methodology](docs/evidence-and-methodology.md)'
require_text "$readme" '[Upgrades and migration](docs/upgrades-and-migration.md)'
require_text "$readme" '[Migration history](docs/migration-history.md)'
require_text "$readme" '[Trust and sources](docs/trust-limitations-and-sources.md)'
require_text "$readme" '## Install'
require_text "$readme" '**Ask Claude Code:** Add the Design Arc marketplace from'
require_text "$readme" '## Start a review'
require_text "$readme" 'Use Design Arc to help me make our onboarding less confusing.'
require_text "$readme" 'You do not need to remember a command.'
require_text "$readme" '## Trust'
require_text "$readme" 'Design Arc does not silently redesign, implement, or deploy your product. You choose the objective, evidence approach, and approval behavior.'
require_text "$readme" '## License'
require_text "$readme" '[MIT License](LICENSE)'

require_text "$codex_edition" '## State'
require_text "$codex_edition" 'Codex owns `.codex/design-arc.yaml`, its review records, and its graph records.'
require_text "$codex_edition" 'The optional pinned project home remains a Codex-owned return path.'
require_text "$codex_edition" '## Upgrade'
require_text "$codex_edition" 'Ask Codex to upgrade Design Arc safely through its configured marketplace.'
require_text "$codex_edition" 'The upgrade preserves `.codex/design-arc.yaml`, the optional pinned project home, review records, graph records, product files, and active tasks byte-for-byte.'
require_text "$codex_edition" 'After verifying the installed version and preservation result, start the next review in a clean Codex task.'
require_text "$codex_edition" 'Codex does not synchronize, merge, import, or mutate Claude Code state.'

require_text "$claude_edition" '## State'
require_text "$claude_edition" 'Claude Code owns `.claude/design-arc.yaml`, its review records, and its graph records.'
require_text "$claude_edition" 'The optional approved `CLAUDE.md` reminder remains a Claude Code-owned return path.'
require_text "$claude_edition" '## Import portable preferences from Codex'
require_text "$claude_edition" 'Claude Code offers this one-time import only when `.claude/design-arc.yaml` is absent.'
require_text "$claude_edition" 'After explicit confirmation, only evidence mode, a valid benchmark provider, approval mode, and graph assistance are copied.'
require_text "$claude_edition" 'Codex bytes, homes, active reviews, review records, and graph records are not merged or changed.'
require_text "$claude_edition" '## Upgrade'
require_text "$claude_edition" 'claude plugin update design-arc@design-arc-marketplace'
require_text "$claude_edition" 'The upgrade preserves `.claude/design-arc.yaml`, the approved `CLAUDE.md` reminder, review records, graph records, product files, and active sessions byte-for-byte.'
require_text "$claude_edition" 'After verifying the installed version and source, start the next review in a clean Claude Code session.'
require_text "$claude_edition" 'The upgrade does not import preferences or synchronize, merge, or mutate Codex state.'

forbid_text "$migration_history" '## Historical Claude preference import'
forbid_text "$migration_history" 'Claude Code may propose importing portable values from `.codex/design-arc.yaml`'

for file in "$getting_started" "$using_design_arc" "$codex_edition" "$claude_edition" "$antigravity_edition" "$faq" "$advanced_controls" "$evidence_methodology" "$upgrades_migration" "$trust_sources" "$runtime_boundaries"
do
  require_text "$file" "$shared_navigation"
done
require_text "$migration_history" "$historical_navigation"

require_text "$getting_started" '# Getting started'
require_text "$getting_started" 'How do I install Design Arc and begin my first review?'
require_text "$getting_started" '## Install once'
require_text "$getting_started" '## Start by describing the problem'
require_text "$getting_started" 'Use Design Arc to help me improve our onboarding.'
require_text "$getting_started" 'Design Arc guides setup in plain language the first time a project uses it.'
require_text "$getting_started" '## Install in Claude Code'
require_text "$getting_started" '## Install in Google Antigravity'
require_text "$getting_started" 'Choose the runtime page for the active host for installation, saved state, and returning later.'
require_text "$getting_started" '[Design Arc for Codex](codex.md)'
require_text "$getting_started" '[Design Arc for Claude Code](claude-code.md)'
require_text "$getting_started" '[Design Arc for Google Antigravity](antigravity.md)'
require_text "$getting_started" 'No Python knowledge is required.'
require_text "$getting_started" 'Technical commands and troubleshooting live in [Advanced controls](advanced-controls.md).'
require_text "$getting_started" 'Next: [Using Design Arc](using-design-arc.md).'

require_text "$using_design_arc" '# Using Design Arc'
require_text "$using_design_arc" 'Describe the product outcome you want in ordinary language.'
require_text "$using_design_arc" 'Commands are optional shortcuts, not required knowledge.'
require_text "$using_design_arc" 'Codex, Claude Code, and Google Antigravity never merge, migrate, resume, or continue an active review across runtimes.'
require_text "$using_design_arc" 'If the active host selects Design Arc for a suitable request that did not invoke it directly, it asks for permission before beginning.'
require_text "$using_design_arc" 'Automatic skill selection is not guaranteed'
require_text "$using_design_arc" 'ask for Design Arc by name when certainty matters.'
require_text "$using_design_arc" 'Design Arc does not run continuously or silently in every task.'
require_text "$using_design_arc" 'How do I use Design Arc after installation?'
require_text "$using_design_arc" 'Runtime-specific installation, invocation, saved state, returning later, visual capabilities, and upgrades belong to the [Codex runtime](codex.md), [Claude Code runtime](claude-code.md), and [Google Antigravity runtime](antigravity.md) pages.'
require_text "$using_design_arc" '[Runtime boundaries](runtime-boundaries.md)'
require_text "$using_design_arc" 'Help me make our onboarding less confusing.'
require_text "$using_design_arc" 'Audit how customers complete checkout and propose a better complete journey.'
require_text "$using_design_arc" 'Redesign account recovery so people can get back in without weakening security.'
require_text "$using_design_arc" '## Choosing the active host or Stitch for the screens'
require_text "$using_design_arc" 'Design Arc generates one complete static journey board in the active host by default.'
require_text "$using_design_arc" 'It does not build disposable application logic merely to visualize the proposal.'
require_text "$using_design_arc" 'Stitch is optional and Design Arc recommends it when any one genuine canvas trigger occurs.'
require_text "$using_design_arc" 'A Stitch recommendation is advisory and never transfers the proposal automatically.'
require_text "$using_design_arc" 'You can stay in the active host.'
require_text "$using_design_arc" 'If you say not to recommend Stitch again for this review, Design Arc suppresses every further recommendation for that review.'
require_text "$using_design_arc" 'The same validation and correction rules apply whether the active host or Stitch renders the screens.'
require_text "$using_design_arc" 'Design Arc corrects straightforward visual drift before asking you to approve the visual proposal.'
require_text "$using_design_arc" 'The initial proposal may be followed by at most three correction rounds for the whole proposal.'
require_text "$using_design_arc" 'Each round batches every known repairable mismatch, generates a new proposal, and reinspects the complete result.'
require_text "$using_design_arc" 'If the proposal still does not match, Design Arc stops and flags every unresolved mismatch and the attempts already made.'
require_text "$using_design_arc" '| Approval mode | Objective | Visual Proposal Gate |'
require_text "$using_design_arc" 'Select evidence mode<br/>Active host; You when a choice is required'
require_text "$using_design_arc" 'C -- "Guidelines only mode" --> C1'
require_text "$using_design_arc" 'Official Apple Human Interface Guidelines for Apple,'
require_text "$using_design_arc" 'Android and Material guidance for Android,'
require_text "$using_design_arc" 'or W3C guidance for web + active host'
require_text "$using_design_arc" 'C -- "Guidelines + Benchmarks mode" --> C2'
require_text "$using_design_arc" 'Mobbin journey benchmarks + applicable'
require_text "$using_design_arc" 'Google Stitch + active host'
require_text "$using_design_arc" 'Generated screens + active host'
require_text "$using_design_arc" 'Design Arc bundles no MCP server'
require_text "$using_design_arc" 'Google now provides an official Stitch MCP server and SDK'
require_text "$using_design_arc" 'only when it is separately installed, configured, and authorized'
require_text "$using_design_arc" 'name the exact configured MCP server or tool'
require_text "$using_design_arc" 'does not imply an official Mobbin MCP integration'
require_text "$using_design_arc" 'Design Arc does not silently redesign, implement, or deploy your product. You choose the objective, evidence approach, and approval behavior.'
require_text "$using_design_arc" 'Design Arc understands how requirements, evidence and screens affect one another, helping it make more precise corrections without surrendering approval control.'
require_text "$using_design_arc" 'Graph assistance is active by default for every new 0.3.0 review in both existing and new projects when no project or host-local safety control turns it off.'
require_text "$using_design_arc" 'An active review remains exactly as it started; its next clean review gains the 0.3.0 assistance.'
require_text "$using_design_arc" 'Graph assistance adds no approval gate.'
require_text "$using_design_arc" 'Graph assistance is optional internal reasoning support.'
require_text "$using_design_arc" 'People who want to inspect or manage it can use the commands in [Advanced controls](advanced-controls.md).'
require_text "$using_design_arc" 'Next: [Evidence and methodology](evidence-and-methodology.md).'

python3 - "$using_design_arc" <<'PY'
from pathlib import Path
import sys

text = Path(sys.argv[1]).read_text(encoding="utf-8")
approval_controls = text.find("## Approval and trust controls")
graph_assistance = text.find("## Graph-assisted corrections")
if approval_controls == -1 or graph_assistance == -1:
    raise SystemExit("FAIL: shared usage page is missing required core or graph guidance")
if graph_assistance < approval_controls:
    raise SystemExit("FAIL: shared usage page must keep graph assistance after core approval guidance")
PY

require_text "$advanced_controls" '# Advanced controls'
require_text "$advanced_controls" 'You do not need these commands for normal Design Arc use.'
require_text "$advanced_controls" '## Google Antigravity controls'
require_text "$advanced_controls" 'Google Antigravity guarantees the `/design-arc` entry point; start there, then ask in ordinary language for the shared action you want.'
require_text "$advanced_controls" 'agy plugin install https://github.com/friedbeef1/design-arc'
for command in \
  '$design-arc setup' \
  '$design-arc home' \
  '$design-arc evidence benchmarks' \
  '$design-arc evidence guidelines' \
  '$design-arc mode guided' \
  '$design-arc mode follow-recommendation' \
  '$design-arc mode fully-automatic' \
  '$design-arc graph on' \
  '$design-arc graph off' \
  '/design-arc:design-arc graph on' \
  '/design-arc:design-arc graph off'
do
  require_text "$advanced_controls" "$command"
done

python3 - "$codex_edition" "$claude_edition" "$advanced_controls" "$prompts" <<'PY'
from pathlib import Path
import sys

codex = Path(sys.argv[1]).read_text(encoding="utf-8")
claude = Path(sys.argv[2]).read_text(encoding="utf-8")
controls = Path(sys.argv[3]).read_text(encoding="utf-8")
prompts = Path(sys.argv[4]).read_text(encoding="utf-8")

plain_starter = "Use Design Arc to help me improve our onboarding."
for name, text in (("Codex runtime page", codex), ("Claude Code runtime page", claude)):
    if plain_starter not in text:
        raise SystemExit(f"FAIL: {name} must lead with a plain-language starter")

command_pairs = (
    ("$design-arc", "/design-arc:design-arc"),
    ("$design-arc setup", "/design-arc:design-arc setup"),
    ("$design-arc upgrade", "/design-arc:design-arc upgrade"),
    ("$design-arc evidence benchmarks", "/design-arc:design-arc evidence benchmarks"),
    ("$design-arc evidence guidelines", "/design-arc:design-arc evidence guidelines"),
    ("$design-arc mode", "/design-arc:design-arc mode"),
    ("$design-arc mode guided", "/design-arc:design-arc mode guided"),
    ("$design-arc mode follow-recommendation", "/design-arc:design-arc mode follow-recommendation"),
    ("$design-arc mode fully-automatic", "/design-arc:design-arc mode fully-automatic"),
    ("$design-arc graph", "/design-arc:design-arc graph"),
    ("$design-arc graph on", "/design-arc:design-arc graph on"),
    ("$design-arc graph off", "/design-arc:design-arc graph off"),
    ("$design-arc graph explain", "/design-arc:design-arc graph explain"),
    ("$design-arc graph rebuild", "/design-arc:design-arc graph rebuild"),
    ("$design-arc graph clear", "/design-arc:design-arc graph clear"),
    ("$design-arc graph global off", "/design-arc:design-arc graph global off"),
    ("$design-arc graph global on", "/design-arc:design-arc graph global on"),
)
for codex_command, claude_command in command_pairs:
    if codex_command not in controls or claude_command not in controls:
        raise SystemExit(f"FAIL: advanced controls must pair {codex_command} with {claude_command}")

if "$design-arc home" not in controls or "/design-arc:design-arc home" in controls:
    raise SystemExit("FAIL: project-home control must remain an explicit Codex-only exception")
if "pinned project home" not in codex:
    raise SystemExit("FAIL: Codex runtime page must preserve the Codex-only project home")
if "`CLAUDE.md` reminder" not in claude:
    raise SystemExit("FAIL: Claude Code runtime page must preserve the Claude-only reminder")
if "Claude Code does not create a Codex project home." not in claude:
    raise SystemExit("FAIL: Claude Code runtime page must reject Codex project homes")
if "Static screen images and complete journey boards directly in Codex by default." not in codex:
    raise SystemExit("FAIL: Codex runtime page must retain its direct visualization capability")
if "does not claim native image generation" not in claude:
    raise SystemExit("FAIL: Claude Code runtime page must not claim native image generation")

required_matrix_rows = (
    "| Start a review | “Use Design Arc to help me improve our onboarding.” | `$design-arc` | `/design-arc:design-arc` |",
    "| Review setup | “Show this project’s Design Arc choices.” | `$design-arc setup` | `/design-arc:design-arc setup` |",
    "| Upgrade safely | “Upgrade Design Arc safely.” | `$design-arc upgrade` | `/design-arc:design-arc upgrade` |",
    "| Use Guidelines + Benchmarks | “Use authorized benchmarks and official guidance.” | `$design-arc evidence benchmarks` | `/design-arc:design-arc evidence benchmarks` |",
    "| Use Guidelines only | “Use official guidelines only.” | `$design-arc evidence guidelines` | `/design-arc:design-arc evidence guidelines` |",
    "| Report approval behavior | “What approval mode is active?” | `$design-arc mode` | `/design-arc:design-arc mode` |",
    "| Save Guided | “Pause for both approvals in this project.” | `$design-arc mode guided` | `/design-arc:design-arc mode guided` |",
    "| Save Follow recommendation | “Follow the recommendation, then show me the visual proposal.” | `$design-arc mode follow-recommendation` | `/design-arc:design-arc mode follow-recommendation` |",
    "| Save Fully automatic | “Bypass both gates for this explicit objective.” | `$design-arc mode fully-automatic` | `/design-arc:design-arc mode fully-automatic` |",
    "| Report graph state | “Is graph assistance active for this review?” | `$design-arc graph` | `/design-arc:design-arc graph` |",
    "| Save this project on | “Turn graph assistance on for this project.” | `$design-arc graph on` | `/design-arc:design-arc graph on` |",
    "| Save this project off | “Turn graph assistance off for this project.” | `$design-arc graph off` | `/design-arc:design-arc graph off` |",
    "| Explain state | “Explain why graph assistance has this state.” | `$design-arc graph explain` | `/design-arc:design-arc graph explain` |",
    "| Rebuild this review | “Rebuild this review’s graph from the current workflow evidence.” | `$design-arc graph rebuild` | `/design-arc:design-arc graph rebuild` |",
    "| Clear this review | “Clear this review’s graph; ask me to confirm first.” | `$design-arc graph clear` | `/design-arc:design-arc graph clear` |",
    "| Set laptop safety off | “Turn graph assistance off on this laptop.” | `$design-arc graph global off` | `/design-arc:design-arc graph global off` |",
    "| Remove laptop safety ceiling | “Remove the laptop-wide graph safety ceiling.” | `$design-arc graph global on` | `/design-arc:design-arc graph global on` |",
    "| Return through a project home | `$design-arc home` | Not available; Claude Code does not create a project home. |",
    "| Add a project reminder | Not available; Codex does not use a `CLAUDE.md` reminder. | Optional approved `CLAUDE.md` reminder; no command. |",
)
errors = [f"FAIL: advanced controls is missing exact action-matrix row: {row}" for row in required_matrix_rows if row not in controls]

if "The examples below use the Codex command surface" in prompts:
    errors.append("FAIL: prompt examples must not be Codex-first")
plain_section = prompts.split("## Plain-language journey starters", 1)[1].split("## ", 1)[0]
for starter in (
    "> Help me make our onboarding less confusing.",
    "> Audit how customers complete checkout and propose a better complete journey.",
    "> Redesign account recovery so people can get back in without weakening security.",
):
    if starter not in plain_section:
        errors.append("FAIL: prompt examples must put command-free journey starters first")
if "$design-arc" in plain_section or "/design-arc:design-arc" in plain_section:
    errors.append("FAIL: plain-language journey starters must be command-free")
if "Stitch gates" in prompts or "Stitch Gate" in prompts:
    errors.append("FAIL: prompt examples must not present Stitch as a required gate")
if "past Stitch" in prompts:
    errors.append("FAIL: prompt examples must not imply that approval continues past Stitch")
if "Stitch remains optional" not in prompts:
    errors.append("FAIL: prompt examples must explicitly preserve optional Stitch")
if errors:
    raise SystemExit("\n".join(errors))
PY

for beginner_page in "$readme" "$getting_started" "$using_design_arc"
do
  forbid_text "$beginner_page" '$design-arc setup'
  forbid_text "$beginner_page" '$design-arc mode'
  forbid_text "$beginner_page" '$design-arc evidence'
  forbid_text "$beginner_page" '$design-arc graph'
  forbid_text "$beginner_page" '/design-arc:design-arc graph'
done

for forbidden_shared_runtime in \
  'Generate one complete static journey board<br/>Codex by default' \
  'Codex generates the static journey board by default.' \
  'after one Codex correction round' \
  'You can stay in Codex.' \
  'The same validation and correction rules apply whether Codex or Stitch renders the screens.' \
  '## Choosing Codex or Stitch for the screens'
do
  forbid_text "$using_design_arc" "$forbidden_shared_runtime"
done

require_text "$evidence_methodology" '# Evidence and methodology'
require_text "$evidence_methodology" 'How are Design Arc recommendations grounded and validated?'
require_text "$evidence_methodology" '| Grounding layer | Pain point | How Design Arc solves it | Credible sources used |'
require_text "$evidence_methodology" '| Platform requirements | Designs can feel unfamiliar, exclude users, or conflict with platform conventions. | Validate the journey against current guidance for its actual platform. | Apple HIG; Android and Material guidance; W3C web accessibility standards. |'
require_text "$evidence_methodology" '| Product precedent | Teams copy attractive screenshots without understanding the complete journey or failure states. | Inspect relevant end-to-end product journeys and explain why a pattern fits the objective. | Authorized benchmark research through a provider such as Mobbin. |'
require_text "$evidence_methodology" '| Product judgment | Opinions and trade-offs can be presented as if a source proved them. | Tie recommendations to the confirmed objective and label judgment separately from observed evidence. | User-confirmed objective and documented Design Arc synthesis—not an external authority. |'
require_text "$evidence_methodology" '| Visualization and validation | Polished screens can conceal missing transitions, errors, and recovery states. | Visualize the complete journey and inspect every important state before approving it for frontend implementation. | Active-host static journey boards by default; optional Google Stitch workspace—not an evidence authority. |'
require_text "$evidence_methodology" 'A single genuine trigger is enough for Design Arc to recommend Stitch'
require_text "$evidence_methodology" 'Staying in the active host remains available, and the user always approves any transfer.'
require_text "$evidence_methodology" '| Relationship context | A correction can miss dependent states when requirements, evidence, and screens are considered separately. | Keep validated relationships visible to plan the smallest compatible correction batch and the regression checks that follow. | The current Design Arc workflow record; the relationship record adds context only. |'
require_text "$evidence_methodology" 'First-party guidance remains authoritative for its platform, authorized benchmark evidence remains precedent, the active host or Stitch provides visualization, and the graph remains relationship context only.'
require_text "$evidence_methodology" 'A graph relationship is not evidence, proof, approval, a source of requirements, or authority.'
require_text "$evidence_methodology" 'The graph can focus correction planning but never replaces complete render inspection or the proposal-wide correction limit.'
require_text "$evidence_methodology" '| Motion specification | Active host + affected-platform guidance + inspected motion evidence | Defines what moves, why, how it behaves, its reduced-motion alternative, and what still requires implementation proof. |'
require_text "$evidence_methodology" 'The initial proposal may be followed by at most three correction rounds for the whole proposal.'
require_text "$evidence_methodology" 'Each round batches every known repairable mismatch, generates a new proposal, and reinspects the complete result.'
require_text "$evidence_methodology" 'A written correction is not a corrected proposal; only the inspected replacement render proves the change.'
require_text "$evidence_methodology" '### Motion grounding and implementation proof'
require_text "$evidence_methodology" 'Design Arc specifies material on-screen animations and screen-to-screen transitions before frontend implementation.'
require_text "$evidence_methodology" 'Every material motion, including retained native or existing behavior, gets a contract with: Motion ID; journey location; purpose; trigger; start/end state; spatial behavior; choreography; timing; easing/spring; interruption; reduced motion; evidence; provenance; implementation target; implementation source; proof status.'
require_text "$evidence_methodology" 'Unsupported values are `unverified`.'
require_text "$evidence_methodology" 'Static screens or sequences support only start/end state, changing element, journey location, and transition intent; they cannot support exact duration, easing, springs, velocity, interruption, or choreography.'
require_text "$evidence_methodology" 'Directly applicable native or current first-party specifications and inspected playable evidence can support temporal behavior; otherwise temporal values remain labeled Design Arc judgment or `unverified`.'
require_text "$evidence_methodology" 'Stitch prototypes are design evidence, not staging or device implementation proof.'
require_text "$evidence_methodology" 'Each direction explains motion purpose and restraint, relevant precedent and platform guidance, provenance labels, reduced-motion implications, motion-specific risks, implementation complexity, and remaining proof.'
require_text "$evidence_methodology" 'A visual verdict evaluates the same motion requirements and contract alignment, and `meets direction` records prototype limitations and remaining runtime proof before Fully automatic may continue.'
require_text "$evidence_methodology" '[Motion grounding](trusted-sources/motion.md)'
require_text "$evidence_methodology" '[Behavioral validation](validation/behavioral-validation.md)'
require_text "$evidence_methodology" '[Trusted sources](trusted-sources/README.md)'
require_text "$evidence_methodology" 'Next: [Upgrades and migration](upgrades-and-migration.md).'

require_text "$upgrades_migration" '# Upgrades and migration'
require_text "$upgrades_migration" 'How do I safely upgrade the installed Design Arc adapters today?'
require_text "$upgrades_migration" '## Current adapter upgrades'
require_text "$upgrades_migration" 'Codex, Claude Code, and Google Antigravity are independently installed adapters. Upgrading one never installs, removes, upgrades, or synchronizes either other adapter.'
require_text "$upgrades_migration" 'claude plugin update design-arc@design-arc-marketplace'
require_text "$upgrades_migration" 'Use a supported Google Antigravity extension update route.'
require_text "$upgrades_migration" 'An Antigravity adapter change preserves `.gemini/design-arc.yaml`, active-review records, review artifacts, graphs, product files, and active sessions byte-for-byte.'
require_text "$upgrades_migration" 'A Claude Code adapter change preserves `.claude/design-arc.yaml`, the approved `CLAUDE.md` reminder block, reviews, graphs, product files, and active sessions byte-for-byte.'
require_text "$upgrades_migration" 'Start a new clean session in the adapter you changed; an already-open session keeps its pinned runtime and workflow version.'
require_text "$upgrades_migration" 'For retired plugin replacement, legacy Codex preference import, and 0.2–0.3 recovery, read [Migration history](migration-history.md).'
require_text "$upgrades_migration" 'For the current one-time Codex-to-Claude portable preference import, read [Design Arc for Claude Code](claude-code.md#import-portable-preferences-from-codex).'
forbidden_current_history='codex plugin remove fb-ux@fb-ux-marketplace
codex plugin remove apple-guidelines-stitch@fb-ux-marketplace
### Moving to or from 0.3.0
### Upgrading from 0.3.0 to 0.3.1
Saved preferences and migration'
while IFS= read -r historical_text
do
  forbid_text "$upgrades_migration" "$historical_text"
done <<EOF
$forbidden_current_history
EOF
require_text "$upgrades_migration" 'Next: [Trust and sources](trust-limitations-and-sources.md).'

require_text "$migration_history" '# Migration history (legacy compatibility)'
require_text "$migration_history" 'This page preserves retired replacement and recovery instructions. It is not the current upgrade path.'
require_text "$migration_history" 'For current adapter upgrades and preservation rules, read [Upgrades and migration](upgrades-and-migration.md).'
require_text "$migration_history" 'codex plugin remove fb-ux@fb-ux-marketplace'
require_text "$migration_history" 'codex plugin remove apple-guidelines-stitch@fb-ux-marketplace'
require_text "$migration_history" 'codex plugin marketplace remove fb-ux-marketplace'
require_text "$migration_history" 'codex plugin marketplace add friedbeef1/design-arc --ref main'
require_text "$migration_history" 'codex plugin add design-arc@design-arc-marketplace'
require_text "$migration_history" 'Start a new Codex task.'
require_text "$migration_history" 'Never silently merge, rewrite, or delete either legacy preference file.'
require_text "$migration_history" '### Moving to or from 0.3.0'
require_text "$migration_history" 'Upgrading to 0.3.0 preserves project preferences, homes, active-review identity and workflow versions, graph records, and product files.'
require_text "$migration_history" 'Active reviews are not changed mid-review; a later clean review resolves the 0.3.0 default independently.'
require_text "$migration_history" 'Downgrading to an older workflow leaves graph records in place but ignores them; it does not delete or reinterpret them.'
require_text "$migration_history" '### Upgrading from 0.3.0 to 0.3.1'
require_text "$migration_history" 'Version `0.3.1` adds an activation-integrity boundary.'
require_text "$migration_history" 'Automatic selection is not guaranteed, so an unprefixed response is never presented as Design Arc work unless the skill actually loaded.'
require_text "$migration_history" 'The patch does not rewrite project preferences, recreate pinned homes, change product files, alter graph records, or convert active reviews.'

require_text "$trust_sources" '# Trust, limitations and sources'
require_text "$trust_sources" 'What can Design Arc prove, access, implement, or release?'
require_text "$trust_sources" 'Installing either adapter authorizes only that local plugin installation.'
require_text "$trust_sources" 'Benchmark, browser, visualization, MCP, provider, and product access each require their own authorization, including approval for the data sent.'
require_text "$trust_sources" '## Claude Code, Claude Desktop, and MCP'
require_text "$trust_sources" 'Design Arc 0.4.0 is packaged and verified for Claude Code.'
require_text "$trust_sources" 'It is not a Claude Desktop chat extension and does not install or configure a Desktop MCP server.'
require_text "$trust_sources" 'Claude Desktop chat MCP configuration is separate from Claude Code configuration.'
require_text "$trust_sources" '[Anthropic’s Claude Code Desktop guide](https://code.claude.com/docs/en/desktop)'
require_text "$trust_sources" '[Anthropic’s MCP guide](https://code.claude.com/docs/en/mcp)'
require_text "$trust_sources" 'access is not bundled by Design Arc'
require_text "$trust_sources" 'Design Arc is not listed in Codex’s built-in recommended-plugin directory.'
require_text "$trust_sources" 'no documented public third-party directory submission route'
require_text "$trust_sources" 'Graph assistance is a project-local relationship record for correction planning, not a new source of truth.'
require_text "$trust_sources" 'It cannot prove a requirement, establish runtime quality, replace current evidence, or authorize a product decision.'
require_text "$trust_sources" 'A failed graph record reduces assistance rather than blocking the review: Design Arc reports the issue and continues the standard workflow.'
require_text "$trust_sources" '[Trusted sources](trusted-sources/README.md)'
require_text "$trust_sources" '[Runtime boundaries](runtime-boundaries.md)'
require_text "$trust_sources" 'Next: [Home](../README.md).'

require_text "$trusted_source_library" '| Visualization and validation | A concrete proposed journey that can be inspected across material states. | Active-host static journey boards by default; optional [Google Stitch](https://stitch.withgoogle.com/) workspace. | Evidence, platform compliance, accessibility, or implementation readiness by itself. |'
require_text "$trusted_source_library" '[Visualization](visualization.md) — active-host static boards by default and Stitch as an optional persistent editing workspace.'
require_text "$visualization_sources" 'Design Arc generates a consolidated static journey board in the active host by default: Codex for the Codex adapter, Claude Code for the Claude adapter, and Google Antigravity for the Antigravity adapter.'
require_text "$visualization_sources" 'The active host is the lower-friction route for a bounded proposal and a few corrections.'
require_text "$runtime_boundaries" '# Runtime boundaries'
require_text "$runtime_boundaries" 'Design Arc is one shared workflow. The active host owns only the runtime-specific installation, invocation, saved state, return path, visualization capability, and upgrade behavior.'
require_text "$runtime_boundaries" 'The [Codex runtime](codex.md), [Claude Code runtime](claude-code.md), and [Google Antigravity runtime](antigravity.md) pages are the authoritative guides for those host-specific details.'
require_text "$runtime_boundaries" 'Codex, Claude Code, and Google Antigravity never merge, migrate, resume, or continue an active review across runtimes.'
require_text "$runtime_boundaries" 'Objective Confirmation, both evidence modes, the Direction Gate, the Visual Proposal Gate, complete-state validation, optional Stitch, and the three-round correction limit are shared workflow contracts.'
require_text "$runtime_boundaries" 'No runtime detail or approval authorizes source implementation, staging, deployment, or release.'
require_text "$operating_layer" '# Codex operating layer (compatibility page)'
require_text "$operating_layer" 'The authoritative shared boundary is [Runtime boundaries](runtime-boundaries.md).'
require_text "$operating_layer" '[Design Arc for Codex](codex.md)'

for shared_page in "$readme" "$getting_started" "$using_design_arc" "$evidence_methodology" "$trust_sources" "$faq"
do
  for forbidden_codex_default in \
    'Codex generates the static journey board by default.' \
    'Codex creates static screen images and complete journey boards directly by default.' \
    'You can stay in Codex.' \
    'Codex as the Design Arc operating layer' \
    'ask for Design Arc by name or use a confirmed Codex project home when you want certainty.'
  do
    forbid_text "$shared_page" "$forbidden_codex_default"
  done
done

for shared_doc in "$evidence_methodology" "$trusted_source_library" "$visualization_sources"
do
  for forbidden_shared_runtime in \
    'Codex-generated static journey boards by default' \
    'Codex generates one consolidated static journey board by default' \
    'Staying in Codex remains available' \
    'Codex static boards by default'
  do
    forbid_text "$shared_doc" "$forbidden_shared_runtime"
  done
done

python3 - "$readme" "$advanced_controls" "$evidence_methodology" "$upgrades_migration" "$migration_history" "$trust_sources" <<'PY'
from pathlib import Path
import re
import sys

text = Path(sys.argv[1]).read_text(encoding="utf-8")
advanced_controls = Path(sys.argv[2]).read_text(encoding="utf-8")
methodology = Path(sys.argv[3]).read_text(encoding="utf-8")
migration = Path(sys.argv[4]).read_text(encoding="utf-8")
migration_history = Path(sys.argv[5]).read_text(encoding="utf-8")
trust = Path(sys.argv[6]).read_text(encoding="utf-8")
marketplace_command = "codex plugin marketplace add friedbeef1/design-arc --ref main"
plugin_command = "codex plugin add design-arc@design-arc-marketplace"
if marketplace_command not in advanced_controls:
    raise SystemExit("FAIL: advanced controls must include the exact marketplace command")
if plugin_command not in advanced_controls:
    raise SystemExit("FAIL: advanced controls must include the exact Design Arc install command")
marketplace_position = advanced_controls.index(marketplace_command)
plugin_position = advanced_controls.index(plugin_command)
if marketplace_position > plugin_position:
    raise SystemExit("FAIL: advanced controls must add the marketplace before adding Design Arc")
if "Codex handles the installation" in advanced_controls:
    raise SystemExit("FAIL: README must not promise that Codex infers the marketplace route automatically")
if "skills.sh URL or package name" in advanced_controls:
    raise SystemExit("FAIL: troubleshooting must not route Design Arc back to a standalone skills registry")
if "Visual Gate" in "".join((text, advanced_controls, methodology, migration, trust)):
    raise SystemExit("FAIL: documentation must use the required Visual Proposal Gate name, not Visual Gate")

local_command = "codex plugin marketplace add /path/to/design-arc"
if local_command not in advanced_controls.splitlines():
    raise SystemExit("FAIL: advanced controls must show the exact local-checkout marketplace command")
if f"{local_command} --ref main" in advanced_controls:
    raise SystemExit("FAIL: documentation local-checkout marketplace command must not use the Git-only --ref option")

headings = re.findall(r"^#{1,2} .+$", text, re.MULTILINE)
expected_headings = [
    "# Design Arc",
    "## Documentation",
    "## One product, three platform editions",
    "## You need Design Arc if…",
    "## What Design Arc produces",
    "## The workflow",
    "## Install",
    "## Start a review",
    "## Trust",
    "## License",
]
if headings != expected_headings:
    raise SystemExit("FAIL: README sections are not in the approved landing-page order")

workflow_start = text.index("## The workflow")
workflow_end = text.index("## Install")
workflow = text[workflow_start:workflow_end]
workflow_instruction = "**Rows marked 👤 You show where your involvement may be needed. First-use choices, approval pauses, and the optional Stitch choice are conditional.**"
workflow_table = """| Workflow step | Platform or source handling it | Human involvement |
| --- | --- | --- |
| Describe the outcome you want | Active host | **👤 You** |
| ↓ | | |
| Choose evidence and approval behavior on first use | Active host | **👤 You — only when no saved preference exists** |
| ↓ | | |
| Audit the current journey | Your website or app + the active host | |
| ↓ | | |
| Gather and label evidence | Mobbin + the active host in Guidelines + Benchmarks mode, and official platform guidance + the active host in Guidelines only mode | |
| ↓ | | |
| Recommend a design direction | Active host | |
| ↓ | | |
| Approve design direction | Active host | **👤 You — only when the selected approval mode pauses here** |
| ↓ | | |
| Validate against platform guidance | Apple, Android, Material, or W3C guidance + the active host | |
| ↓ | | |
| Decide on any design motion | Relevant official guidance + inspected motion evidence + the active host | |
| ↓ | | |
| Choose whether to use the optional Stitch workspace | Active host | **👤 You — only if Stitch is recommended** |
| ↓ | | |
| Visualize the complete journey | Static journey board in the active host by default; optional Google Stitch workspace | |
| ↓ | | |
| Validate every important state | Generated journey screens + the active host | |
| ↓ | | |
| Approve the visual proposal | Active host | **👤 You — only when the selected approval mode pauses here** |
| ↓ | | |
| Prepare the design handoff | Active host | |"""

def validate_workflow(candidate):
    expected_table = f"## The workflow\n\n{workflow_instruction}\n\n{workflow_table}"
    following_prose = "Setup resolves two independent choices: how evidence is gathered and where Design Arc pauses for approval."
    if not candidate.startswith(expected_table):
        raise ValueError("workflow must use the exact instruction, table header, separator, and ordered rows")
    if not candidate[len(expected_table):].startswith(f"\n\n{following_prose}"):
        raise ValueError("workflow table must end immediately after the final handoff row")
    if candidate.count("| ↓ | | |") != 12:
        raise ValueError("workflow must preserve the 12-row arrow sequence")
    if candidate.count("👤 You") != 6:
        raise ValueError("workflow must contain one legend reference and five human-involvement rows")

validate_workflow(workflow)

for mutated_workflow in (
    workflow.replace(workflow_instruction, "**Design Arc handles every step.**", 1),
    workflow.replace("| Workflow step | Platform or source handling it | Human involvement |", "| Workflow | Platform | Human |", 1),
    workflow.replace(
        "| Describe the outcome you want | Active host | **👤 You** |\n| ↓ | | |\n| Choose evidence and approval behavior on first use | Active host | **👤 You — only when no saved preference exists** |",
        "| Choose evidence and approval behavior on first use | Active host | **👤 You — only when no saved preference exists** |\n| ↓ | | |\n| Describe the outcome you want | Active host | **👤 You** |",
        1,
    ),
    workflow.replace(
        "| Prepare the design handoff | Active host | |\n\nSetup resolves",
        "| Prepare the design handoff | Active host | |\n| Record a follow-up | Active host | |\n\nSetup resolves",
        1,
    ),
):
    try:
        validate_workflow(mutated_workflow)
    except ValueError:
        pass
    else:
        raise SystemExit("FAIL: workflow contract must reject instruction, header, row-order, and extra-row mutations")
print("PASS: workflow contract rejects instruction, header, row-order, and extra-row mutations")

for superseded_label in (
    "**Only the bold steps need you. Design Arc handles everything else.**",
    "**Choose preferences once**",
    "**Authorize external access if requested**",
    "**Approve the direction if your mode pauses**",
    "**Approve the visual proposal if your mode pauses**",
    "→",
):
    if superseded_label in workflow:
        raise SystemExit(f"FAIL: workflow retains superseded horizontal/manual label: {superseded_label}")

for provider in ("Apple", "Mobbin", "Stitch"):
    if provider not in methodology:
        raise SystemExit(f"FAIL: {provider} is missing from evidence and methodology")

migration_commands = [
    "codex plugin remove fb-ux@fb-ux-marketplace",
    "codex plugin remove apple-guidelines-stitch@fb-ux-marketplace",
    "codex plugin marketplace remove fb-ux-marketplace",
    "codex plugin marketplace add friedbeef1/design-arc --ref main",
    "codex plugin add design-arc@design-arc-marketplace",
    "Start a new Codex task.",
]
migration_positions = [migration_history.index(command) for command in migration_commands]
if migration_positions != sorted(migration_positions):
    raise SystemExit("FAIL: migration steps are not in the required safe order")

trusted_sources_dir = Path(sys.argv[1]).parent / "docs" / "trusted-sources"
approved_external_urls = {
    "https://developer.apple.com/design/human-interface-guidelines/",
    "https://developer.android.com/design/ui/mobile",
    "https://developer.android.com/guide/topics/ui/accessibility",
    "https://m3.material.io/",
    "https://www.w3.org/TR/WCAG22/",
    "https://www.w3.org/WAI/ARIA/apg/",
    "https://mobbin.com/",
    "https://stitch.withgoogle.com/",
    "https://developer.apple.com/design/human-interface-guidelines/motion",
    "https://developer.android.com/develop/ui/compose/animation/introduction",
    "https://m3.material.io/styles/motion/overview/how-it-works",
    "https://www.w3.org/TR/mediaqueries-5/#prefers-reduced-motion",
    "https://docs.mobbin.com/mcp/introduction",
    "https://motion.dev/docs/quick-start",
    "https://motion.dev/docs/ai-kit-install",
    "https://pageflows.com/",
}
actual_external_urls = {
    url
    for path in trusted_sources_dir.glob("*.md")
    for url in re.findall(r"https?://[^\s)]+", path.read_text(encoding="utf-8"))
}
if actual_external_urls != approved_external_urls:
    missing = sorted(approved_external_urls - actual_external_urls)
    unexpected = sorted(actual_external_urls - approved_external_urls)
    raise SystemExit(
        "FAIL: trusted sources external URL set drifted"
        f"; missing={missing}; unexpected={unexpected}"
    )
PY


require_text "$repo_root/docs/trusted-sources/platform-guidance.md" '## Motion guidance'
require_text "$repo_root/docs/trusted-sources/platform-guidance.md" 'Existing product motion and standard native behavior come first.'
require_text "$repo_root/docs/trusted-sources/platform-guidance.md" 'A screenshot or static screen sequence cannot prove exact motion timing, easing, velocity, spring behavior, or choreography.'

require_text "$repo_root/docs/trusted-sources/README.md" '[Motion grounding](motion.md)'
require_text "$motion_sources" '# Motion grounding'
require_text "$motion_sources" 'Motion needs evidence because it changes what people perceive, control, and can tolerate, not just how a screen looks.'
require_text "$motion_sources" 'Shipped-product precedent shows what was observed in a comparable journey; an implementation library supplies tools, not proof that its defaults fit this product.'
require_text "$motion_sources" 'A static Mobbin screen or sequence can establish only the visible states, changing element, journey location, and intended transition.'
require_text "$motion_sources" 'Use a recording or playable journey when the decision depends on timing, easing, spring behavior, velocity, choreography, interruption, reversal, or a missing intermediate state.'
require_text "$motion_sources" 'Motion and Motion+ are optional implementation dependencies, never Design Arc requirements, evidence, authority, or bundled dependencies.'
require_text "$motion_sources" 'After separate authorization, Motion+ can assist an implementation owner with documentation and example search, reusable source retrieval, spring and easing work, saved-transition inspection, performance auditing, and design-system adaptation.'
require_text "$motion_sources" 'Implementation targets name the runtime and UI technology, such as Web, React, SwiftUI, UIKit, or Compose; timing uses milliseconds or seconds or a parameterized physical spring; easing uses cubic-bezier values, a named platform curve, or reproducible spring parameters.'
require_text "$motion_sources" 'Interruption covers reversal, cancellation, and re-entry; provenance carries one required label plus citations and estimate basis; implementation source records authorization; proof status distinguishes specified, prototyped, staging, device, and production evidence.'
require_text "$motion_sources" 'For Android and web targets, their current first-party guidance takes precedence over conflicting Apple-inspired judgment.'
require_text "$motion_sources" 'Every material motion contract must name a reduced-motion alternative; no animation is the fallback only when it still preserves the needed information and control.'
require_text "$motion_sources" 'A prototype can communicate an intended interaction, but it cannot prove runtime quality.'

require_text "$behavioral_validation" '# Design Arc instruction-contract validation'
require_text "$behavioral_validation" 'plugins/design-arc/skills/design-arc/SKILL.md'
require_text "$behavioral_validation" 'claude-plugins/design-arc/skills/design-arc/SKILL.md'
require_text "$behavioral_validation" '`scripts/check-claude-state-contracts.py` protects Claude setup, import, reminder, profile-root, project-identity, runtime-isolation, and upgrade boundaries.'
require_text "$behavioral_validation" 'executable static instruction-contract guards; they do not execute an agent or prove runtime agent behavior.'
require_text "$behavioral_validation" 'Fresh-context scenario evidence is qualitative unless the prompt, environment, output, and scoring are stored reproducibly.'
require_text "$behavioral_validation" '## Fresh-task installation and setup evidence — 2026-08-07'
require_text "$behavioral_validation" 'Codex CLI 0.146.1'
require_text "$behavioral_validation" 'used the restricted built-in plugin-install control and failed'
require_text "$behavioral_validation" 'executed both terminal commands, verified `design-arc@design-arc-marketplace` as installed and enabled'
require_text "$behavioral_validation" 'presented Guidelines + Benchmarks/Guidelines only and Guided/Follow recommendation/Fully automatic independently'
require_text "$behavioral_validation" 'Fourteen render-repair mutations prove that the written contract rejects unbounded retries, per-mismatch retrying, user-dependent ordinary corrections, uninspected correction claims, skipped reinspection, unsafe direction changes, runtime-proof retries, premature early stopping, missing exhaustion handling, unexplained `meets direction`, incomplete repair records, and approval-mode bypasses.'
require_text "$behavioral_validation" '187 deterministic mutation rejections'
require_text "$behavioral_validation" 'Five activation-integrity mutations separately prove that direct invocation starts immediately, an indirectly selected skill asks first, pre-approval work remains isolated, declining does not let Design Arc claim control of the ordinary request, and an unselected skill cannot be credited with work it did not perform.'
require_text "$behavioral_validation" 'the direct `$design-arc` prompt loaded the candidate and proceeded without a redundant activation question, while the same unprefixed prompt received an ordinary Codex answer because the skill was not selected.'
require_text "$behavioral_validation" 'These are static instruction-contract mutations; they do not execute Stitch or prove that every future agent will follow the contract.'
require_text "$behavioral_validation" '## Isolated 0.2.2 to 0.2.3 upgrade evidence — 2026-08-08'
require_text "$behavioral_validation" '`scripts/test-plugin-upgrade.sh` checks out immutable public 0.2.2 commit `1c9b3796e6f5f0648bae5984f1b8e3013eeac56f`, uses a temporary `CODEX_HOME`, and creates only a temporary two-project fixture.'
require_text "$behavioral_validation" 'The RED identity, fresh-install, migration, and upgrade expectations required 0.2.3 while the unchanged canonical manifest still reported 0.2.2; each failed at the intended manifest-version boundary.'
require_text "$behavioral_validation" 'Changing only `plugins/design-arc/.codex-plugin/plugin.json` to 0.2.3 made the same four focused release checks GREEN.'
require_text "$behavioral_validation" 'The normal `codex plugin marketplace upgrade design-arc-marketplace` attempt did not produce the 0.2.3 installed state from the local immutable source, so the observed route was `remove-add-fallback`.'
require_text "$behavioral_validation" 'Before any removal, the immutable restoration preflight required exactly one enabled canonical 0.2.2 installation, zero other available plugins, the exact parsed baseline marketplace and plugin source, one complete byte-identical 0.2.2 cache, and unchanged two-project bytes.'
require_text "$behavioral_validation" 'Five injected preflight cases—missing, disabled, duplicate, unexpected-source, and cache-mismatch—must stop before either removal command.'
require_text "$behavioral_validation" 'Injected failures preserve rollback coverage for plugin removal, marketplace removal, target marketplace add, target availability read and validation, plugin install, final state reads, prompt loading, and preservation validation; every restoration requires the immutable 0.2.2 package and unchanged project bytes.'
require_text "$behavioral_validation" 'The passing comparison preserved exactly two preferences, two ready homes, two product sentinels, and two active reviews byte-for-byte, created zero homes, and continued zero reviews.'
require_text "$behavioral_validation" 'This is local deterministic evidence only; it is not publication, a real-profile upgrade, real Stitch execution, or product-runtime proof.'
require_text "$behavioral_validation" '## Design Arc 0.3.1 activation and upgrade evidence — 2026-08-10'
require_text "$behavioral_validation" '[0.3.1 readiness audit](0.3.1-readiness-audit.md)'
require_text "$behavioral_validation" 'The isolated upgrade proof checks out public `0.3.0` commit `55b03baf4a8dc0b52f0702f1236a865ac2c797b6`, uses a temporary `CODEX_HOME`, and creates two temporary projects.'
require_text "$behavioral_validation" 'It installed exactly one enabled `0.3.1` plugin and preserved two preferences, two ready homes, two product sentinels, two graph records, and two version-pinned active reviews byte-for-byte.'
require_text "$behavioral_validation" '| First use | Install once, then confirm this project’s preferences and separately approve or decline one pinned home. |'
require_text "$behavioral_validation" '| Next-day return | Open the project’s pinned home and use an ordinary-language starter; the home launches a clean local task in the same project. |'
require_text "$behavioral_validation" '| New product | Reuse the installed plugin, run setup in the new saved project, and keep its optional home and preferences separate. |'
require_text "$behavioral_validation" '| Multiple products | Keep at most one approved home per participating project and never create a global home. |'
require_text "$behavioral_validation" '| Duplicate discovery | Reuse the matching same-project home, report extras for user cleanup, and create no known duplicate. |'
require_text "$behavioral_validation" '| Task tools unavailable | Save only confirmed preferences, report that no home is ready, and provide the exact title, card, and manual create-and-pin steps. |'
require_text "$behavioral_validation" '## Claude Code setup and return contract'
require_text "$behavioral_validation" '| First use | Confirm `.claude/design-arc.yaml` independently and separately approve or decline the exact `CLAUDE.md` reminder block. |'
require_text "$behavioral_validation" '| Next-day return | Open the same product project in a clean Claude Code session and invoke `/design-arc:design-arc`; do not create or reuse a Codex home. |'
require_text "$behavioral_validation" '| Runtime isolation | Keep Claude preferences, active reviews, review artifacts, graphs, and sessions under Claude ownership; never merge or continue a Codex active review. |'

require_text "$prompts" '# Design Arc prompt examples'
require_text "$prompts" 'Start in ordinary language in either runtime.'
require_text "$prompts" 'automatic skill selection is not guaranteed'
require_text "$prompts" '## Plain-language journey starters'
require_text "$prompts" '> Help me make our onboarding less confusing.'
require_text "$prompts" '> Audit how customers complete checkout and propose a better complete journey.'
require_text "$prompts" '> Redesign account recovery so people can get back in without weakening security.'
require_text "$prompts" '## Optional command forms'
require_text "$prompts" '$design-arc setup'
require_text "$prompts" '/design-arc:design-arc setup'
require_text "$prompts" '$design-arc evidence benchmarks'
require_text "$prompts" '/design-arc:design-arc evidence benchmarks'
require_text "$prompts" '$design-arc evidence guidelines'
require_text "$prompts" '/design-arc:design-arc evidence guidelines'
require_text "$prompts" '$design-arc mode guided'
require_text "$prompts" '/design-arc:design-arc mode guided'
require_text "$prompts" '$design-arc mode follow-recommendation'
require_text "$prompts" '/design-arc:design-arc mode follow-recommendation'
require_text "$prompts" '$design-arc mode fully-automatic'
require_text "$prompts" '/design-arc:design-arc mode fully-automatic'
require_text "$prompts" 'use Guidelines only for this run'
require_text "$prompts" 'Bypass both gates'
forbid_text "$prompts" 'stop at the Stitch Gate'
forbid_text "$prompts" 'continues through Stitch only when the verdict'

printf '%s\n' 'PASS: Design Arc product documentation'

if [ "${DESIGN_ARC_DOCS_SKIP_BROKEN_LINK_MUTATION:-}" != '1' ]
then
  mutation_checkout="$task_temp_dir/broken-link-fixture"
  copy_fixture "$mutation_checkout"
  mutation_page="$mutation_checkout/README.md"

  python3 - "$mutation_page" <<'PY'
from pathlib import Path
import sys

page = Path(sys.argv[1])
original = page.read_text(encoding="utf-8")
target = "[Learn how to use Design Arc.](docs/using-design-arc.md)"
if target not in original:
    raise SystemExit("FAIL: broken-link fixture requires a valid menu target")
page.write_text(original.replace(target, "[Learn how to use Design Arc.](missing-page.md)", 1), encoding="utf-8")
PY

  if output=$(DESIGN_ARC_DOCS_SKIP_BROKEN_LINK_MUTATION=1 sh "$mutation_checkout/scripts/test-design-arc-docs.sh" 2>&1)
  then
    printf '%s\n' "$output" >&2
    fail 'broken-link mutation was accepted'
  fi

  printf '%s\n' "$output" | grep -F 'FAIL: broken relative link in' >/dev/null || {
    printf '%s\n' "$output" >&2
    fail 'broken-link mutation failed for the wrong reason'
  }
  printf '%s\n' 'PASS: broken-link mutation is rejected'

  escape_checkout="$task_temp_dir/escape-link-fixture"
  copy_fixture "$escape_checkout"
  escape_page="$escape_checkout/README.md"

  python3 - "$escape_page" <<'PY'
from pathlib import Path
import os
import sys

page = Path(sys.argv[1])
original = page.read_text(encoding="utf-8")
target = "[Learn how to use Design Arc.](docs/using-design-arc.md)"
if target not in original:
    raise SystemExit("FAIL: escape-link fixture requires a valid menu target")
escape_target = os.path.relpath("/etc/passwd", page.parent)
page.write_text(
    original.replace(target, f"[Learn how to use Design Arc.]({escape_target})", 1),
    encoding="utf-8",
)
PY

  if output=$(DESIGN_ARC_DOCS_SKIP_BROKEN_LINK_MUTATION=1 sh "$escape_checkout/scripts/test-design-arc-docs.sh" 2>&1)
  then
    printf '%s\n' "$output" >&2
    fail 'escape-link mutation was accepted'
  fi

  printf '%s\n' "$output" | grep -F 'FAIL: relative link escapes repository in' >/dev/null || {
    printf '%s\n' "$output" >&2
    fail 'escape-link mutation failed for the wrong reason'
  }
  printf '%s\n' 'PASS: escape-link mutation is rejected'

  fragment_checkout="$task_temp_dir/broken-fragment-fixture"
  copy_fixture "$fragment_checkout"
  fragment_page="$fragment_checkout/docs/codex.md"

  python3 - "$fragment_page" <<'PY'
from pathlib import Path
import sys

page = Path(sys.argv[1])
original = page.read_text(encoding="utf-8")
target = "[FAQ](faq.md#what-is-a-project-home)"
if target not in original:
    raise SystemExit("FAIL: broken-fragment fixture requires the exact Codex FAQ link")
page.write_text(original.replace(target, "[FAQ](faq.md#missing-project-home)", 1), encoding="utf-8")
PY

  if output=$(DESIGN_ARC_DOCS_SKIP_BROKEN_LINK_MUTATION=1 sh "$fragment_checkout/scripts/test-design-arc-docs.sh" 2>&1)
  then
    printf '%s\n' "$output" >&2
    fail 'broken-fragment mutation was accepted'
  fi

  printf '%s\n' "$output" | grep -F 'FAIL: broken Markdown fragment in' >/dev/null || {
    printf '%s\n' "$output" >&2
    fail 'broken-fragment mutation failed for the wrong reason'
  }
  printf '%s\n' 'PASS: broken-fragment mutation is rejected'

  license_checkout="$task_temp_dir/license-link-fixture"
  copy_fixture "$license_checkout"
  license_page="$license_checkout/README.md"

  python3 - "$license_page" <<'PY'
from pathlib import Path
import sys

page = Path(sys.argv[1])
original = page.read_text(encoding="utf-8")
target = "[MIT License](LICENSE)"
if target not in original:
    raise SystemExit("FAIL: license-link fixture requires the exact README licence link")
page.write_text(original.replace(target, "[MIT licence](LICENSE)", 1), encoding="utf-8")
PY

  if output=$(DESIGN_ARC_DOCS_SKIP_BROKEN_LINK_MUTATION=1 sh "$license_checkout/scripts/test-design-arc-docs.sh" 2>&1)
  then
    printf '%s\n' "$output" >&2
    fail 'license-link mutation was accepted'
  fi

  printf '%s\n' "$output" | grep -F 'missing required text in README.md: [MIT License](LICENSE)' >/dev/null || {
    printf '%s\n' "$output" >&2
    fail 'license-link mutation failed for the wrong reason'
  }
  printf '%s\n' 'PASS: license-link mutation is rejected'

  command_order_checkout="$task_temp_dir/plugin-command-order-fixture"
  copy_fixture "$command_order_checkout"
  command_order_page="$command_order_checkout/docs/advanced-controls.md"

  python3 - "$command_order_page" <<'PY'
from pathlib import Path
import sys

page = Path(sys.argv[1])
original = page.read_text(encoding="utf-8")
marketplace_command = "codex plugin marketplace add friedbeef1/design-arc --ref main"
plugin_command = "codex plugin add design-arc@design-arc-marketplace"
ordered_commands = f"{marketplace_command}\n{plugin_command}"
if ordered_commands not in original:
    raise SystemExit("FAIL: plugin-command-order fixture requires the ordered installation commands")
page.write_text(original.replace(ordered_commands, f"{plugin_command}\n{marketplace_command}", 1), encoding="utf-8")
PY

  if output=$(DESIGN_ARC_DOCS_SKIP_BROKEN_LINK_MUTATION=1 sh "$command_order_checkout/scripts/test-design-arc-docs.sh" 2>&1)
  then
    printf '%s\n' "$output" >&2
    fail 'plugin-command-order mutation was accepted'
  fi

  printf '%s\n' "$output" | grep -F 'FAIL: advanced controls must add the marketplace before adding Design Arc' >/dev/null || {
    printf '%s\n' "$output" >&2
    fail 'plugin-command-order mutation failed for the wrong reason'
  }
  printf '%s\n' 'PASS: plugin-command-order mutation is rejected'
fi
