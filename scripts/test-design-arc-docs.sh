#!/bin/sh
# Validate Design Arc's public product story and documentation boundaries.

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
repo_root=$(CDPATH= cd "$script_dir/.." && pwd)

fail() {
  printf '%s\n' "FAIL: $*" >&2
  exit 1
}

require_text() {
  file=$1
  text=$2
  grep -F "$text" "$file" >/dev/null || fail "missing required text in ${file#"$repo_root/"}: $text"
}

readme="$repo_root/README.md"
operating_layer="$repo_root/docs/codex-operating-layer.md"
behavioral_validation="$repo_root/docs/validation/behavioral-validation.md"
prompts="$repo_root/examples/prompts.md"
motion_sources="$repo_root/docs/trusted-sources/motion.md"

for file in "$readme" "$operating_layer" "$behavioral_validation" "$prompts" "$motion_sources"
do
  [ -f "$file" ] || fail "missing required documentation: ${file#"$repo_root/"}"
done

require_text "$readme" '# Design Arc'
require_text "$readme" 'Product feedback is often vague, redesign discussions become subjective, and teams approve attractive screens without knowing whether the complete journey works.'
require_text "$readme" 'Move from uncertain product feedback to a complete design direction grounded in credible sources.'
require_text "$readme" 'Design Arc audits the real journey, checks decisions against current first-party platform guidance and inspected real-product journeys, recommends the strongest path, and designs every important state before implementation begins.'
require_text "$readme" '| Grounding layer | Pain point | How Design Arc solves it | Credible sources used |'
require_text "$readme" '| Platform requirements | Designs can feel unfamiliar, exclude users, or conflict with platform conventions. | Validate the journey against current guidance for its actual platform. | Apple HIG; Android and Material guidance; W3C web accessibility standards. |'
require_text "$readme" '| Product precedent | Teams copy attractive screenshots without understanding the complete journey or failure states. | Inspect relevant end-to-end product journeys and explain why a pattern fits the objective. | Authorized benchmark research through a provider such as Mobbin. |'
require_text "$readme" '| Product judgment | Opinions and trade-offs can be presented as if a source proved them. | Tie recommendations to the confirmed objective and label judgment separately from observed evidence. | User-confirmed objective and documented Design Arc synthesis—not an external authority. |'
require_text "$readme" '| Visualization and validation | Polished screens can conceal missing transitions, errors, and recovery states. | Visualize the complete journey and inspect every important state before approving it for frontend implementation. | Google Stitch as a visualization tool—not an evidence authority. |'
require_text "$readme" '| Motion specification | Codex + affected-platform guidance + inspected motion evidence | Defines what moves, why, how it behaves, its reduced-motion alternative, and what still requires implementation proof. |'
require_text "$readme" '### Motion grounding and implementation proof'
require_text "$readme" 'Design Arc specifies material on-screen animations and screen-to-screen transitions before frontend implementation.'
require_text "$readme" 'Every material motion, including retained native or existing behavior, gets a contract with: Motion ID; journey location; purpose; trigger; start/end state; spatial behavior; choreography; timing; easing/spring; interruption; reduced motion; evidence; provenance; implementation target; implementation source; proof status.'
require_text "$readme" 'Unsupported values are `unverified`.'
require_text "$readme" 'Static screens or sequences support only start/end state, changing element, journey location, and transition intent; they cannot support exact duration, easing, springs, velocity, interruption, or choreography.'
require_text "$readme" 'Directly applicable native or current first-party specifications and inspected playable evidence can support temporal behavior; otherwise temporal values remain labeled Design Arc judgment or `unverified`.'
require_text "$readme" 'Stitch prototypes are design evidence, not staging or device implementation proof.'
require_text "$readme" '[motion grounding guide](docs/trusted-sources/motion.md)'
require_text "$readme" '## You need Design Arc if…'
require_text "$readme" '## What Design Arc produces'
require_text "$readme" '## The workflow'
require_text "$readme" '## Example: from “confusing onboarding” to a complete direction'
require_text "$readme" '## Choose how Design Arc grounds its recommendations'
require_text "$readme" '## Install and set up in 60 seconds'
require_text "$readme" 'Design Arc is installed once for your Codex profile. Each participating project keeps its own setup and may have one approved, pinned home.'
require_text "$readme" '## Coming back tomorrow'
require_text "$readme" '| First day | Open the project, run `$design-arc setup`, choose the two project preferences, and approve or decline its proposed home. |'
require_text "$readme" '| Next day | Open that project’s pinned `Design Arc — <Project Name>` task and describe the journey in ordinary language. |'
require_text "$readme" '| New product | Open the new saved project and run setup there once. Its preferences and optional home stay separate from every other product. |'
require_text "$readme" 'Each home is a launchpad, not a workspace for the design review.'
require_text "$readme" 'Every journey starter opens a clean local task in that same saved project'
require_text "$readme" 'There is no global Design Arc home.'
require_text "$readme" 'A project with no confirmed Design Arc setup receives no home and no sidebar item.'
require_text "$readme" 'Design Arc reuses an existing home for the same title and project instead of creating a duplicate.'
require_text "$readme" 'If it finds extra same-project homes, it reports them for you to clean up; it never deletes them.'
require_text "$readme" 'If Codex cannot create or pin the task, Design Arc saves confirmed preferences, says clearly that no home is ready, and gives you the exact title, starter card, and manual create-and-pin steps.'
require_text "$readme" 'Help me make our onboarding less confusing.'
require_text "$readme" 'Audit how customers complete checkout and propose a better complete journey.'
require_text "$readme" 'Redesign account recovery so people can get back in without weakening security.'
require_text "$readme" '## Approval and trust controls'
require_text "$readme" '## Methodology, sources, migration, and limitations'
require_text "$readme" 'Design Arc does not silently redesign, implement, or deploy your product. You choose the objective, evidence approach, and approval behavior.'
require_text "$readme" 'Install Design Arc as a Codex plugin, not as a standalone skill.'
require_text "$readme" 'Add https://github.com/friedbeef1/mobbin-apple-guidelines-stitch as a plugin marketplace using ref `main`, then install `design-arc@design-arc-marketplace`.'
require_text "$readme" 'Do not search skills.sh or the standalone skills registry.'
require_text "$readme" 'Use the terminal commands below; do not use the built-in plugin-install control or `request_plugin_install`.'
require_text "$readme" 'Ask me for download permission if required, verify the plugin is enabled, and tell me to start a new task.'
require_text "$readme" 'No Python knowledge is required.'
require_text "$readme" '### If Codex says “no exact package exists in the skills registry”'
require_text "$readme" 'That response means Codex used the wrong installation route.'
require_text "$readme" 'If Codex says the plugin is not in the permitted recommended-plugin list, it used the built-in plugin-install control instead of the terminal commands.'
require_text "$readme" 'render validation → Stitch Gate → authorized design handoff'
require_text "$readme" '| Approval mode | Objective | Stitch Gate |'
require_text "$readme" '| Step | Performed in / by | Why it is crucial |'
require_text "$readme" 'codex plugin marketplace add /path/to/mobbin-apple-guidelines-stitch'
require_text "$readme" 'codex plugin remove fb-ux@fb-ux-marketplace'
require_text "$readme" 'codex plugin remove apple-guidelines-stitch@fb-ux-marketplace'
require_text "$readme" 'codex plugin marketplace remove fb-ux-marketplace'
require_text "$readme" 'codex plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch --ref main'
require_text "$readme" 'codex plugin add design-arc@design-arc-marketplace'
require_text "$readme" 'Start a new Codex task.'
require_text "$readme" 'Never silently merge, rewrite, or delete either legacy preference file.'
require_text "$readme" 'not bundled or official'
require_text "$readme" 'Design Arc is not listed in Codex’s built-in recommended-plugin directory.'
require_text "$readme" 'no documented public third-party directory submission route'

python3 - "$readme" <<'PY'
from pathlib import Path
import re
import sys

text = Path(sys.argv[1]).read_text(encoding="utf-8")
install_heading = text.index("## Install and set up in 60 seconds")
approval_heading = text.index("## Approval and trust controls")
install_section = text[install_heading:approval_heading]
prompt_start = install_section.index("Install Design Arc as a Codex plugin, not as a standalone skill.")
marketplace_command = "codex plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch --ref main"
plugin_command = "codex plugin add design-arc@design-arc-marketplace"
if install_section.index(marketplace_command) < prompt_start or install_section.index(plugin_command) < prompt_start:
    raise SystemExit("FAIL: explicit plugin commands must appear directly after the copyable Codex instruction")
if "Codex handles the installation" in install_section:
    raise SystemExit("FAIL: README must not promise that Codex infers the marketplace route automatically")
if "skills.sh URL or package name" in install_section:
    raise SystemExit("FAIL: troubleshooting must not route Design Arc back to a standalone skills registry")
if "Visual Gate" in text:
    raise SystemExit("FAIL: README must use the required Stitch Gate name, not Visual Gate")

local_command = "codex plugin marketplace add /path/to/mobbin-apple-guidelines-stitch"
if local_command not in text.splitlines():
    raise SystemExit("FAIL: README must show the exact local-checkout marketplace command")
if f"{local_command} --ref main" in text:
    raise SystemExit("FAIL: local-checkout marketplace command must not use the Git-only --ref option")

headings = [
    "## You need Design Arc if…",
    "## What Design Arc produces",
    "## The workflow",
    "## Example: from “confusing onboarding” to a complete direction",
    "## Choose how Design Arc grounds its recommendations",
    "## Install and set up in 60 seconds",
    "## Coming back tomorrow",
    "## Approval and trust controls",
    "## Methodology, sources, migration, and limitations",
]
positions = [text.index(heading) for heading in headings]
if positions != sorted(positions) or len(set(positions)) != len(positions):
    raise SystemExit("FAIL: README sections are not in the required product-story order")

methodology = text[text.index("## Methodology, sources, migration, and limitations"):]
for provider in ("Apple", "Mobbin", "Stitch"):
    if provider not in methodology:
        raise SystemExit(f"FAIL: {provider} is missing from the lower methodology section")

migration_commands = [
    "codex plugin remove fb-ux@fb-ux-marketplace",
    "codex plugin remove apple-guidelines-stitch@fb-ux-marketplace",
    "codex plugin marketplace remove fb-ux-marketplace",
    "codex plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch --ref main",
    "codex plugin add design-arc@design-arc-marketplace",
    "Start a new Codex task.",
]
migration = text[text.index("### Saved preferences and migration"):]
migration_positions = [migration.index(command) for command in migration_commands]
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

require_text "$operating_layer" '# Codex as the Design Arc operating layer'
require_text "$operating_layer" '## Install once; participate per project'
require_text "$operating_layer" 'one confirmed home per participating saved project'
require_text "$operating_layer" 'There is no global Design Arc home.'
require_text "$operating_layer" 'Each journey starts in a clean local task in the same saved project'
require_text "$operating_layer" 'A project without confirmed setup gets no home and no sidebar item.'
require_text "$operating_layer" 'If task tools are unavailable or fail, preference setup may still succeed, but Design Arc must not claim that the home exists.'
require_text "$operating_layer" '.codex/design-arc.yaml'
require_text "$operating_layer" 'evidence and approval choices independently'
require_text "$operating_layer" 'Android or web first-party rules override conflicting Apple-inspired judgment'
require_text "$operating_layer" 'No mode or external-service authorization authorizes source implementation, staging, deployment, or release.'

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
require_text "$motion_sources" 'For Android and web targets, their current first-party guidance takes precedence over conflicting Apple-inspired judgment.'
require_text "$motion_sources" 'Every material motion contract must name a reduced-motion alternative; no animation is the fallback only when it still preserves the needed information and control.'
require_text "$motion_sources" 'A prototype can communicate an intended interaction, but it cannot prove runtime quality.'

require_text "$behavioral_validation" '# Design Arc instruction-contract validation'
require_text "$behavioral_validation" 'plugins/design-arc/skills/design-arc/SKILL.md'
require_text "$behavioral_validation" 'executable static instruction-contract guards; they do not execute an agent or prove runtime agent behavior.'
require_text "$behavioral_validation" 'Fresh-context scenario evidence is qualitative unless the prompt, environment, output, and scoring are stored reproducibly.'
require_text "$behavioral_validation" '## Fresh-task installation and setup evidence — 2026-08-07'
require_text "$behavioral_validation" 'Codex CLI 0.146.1'
require_text "$behavioral_validation" 'used the restricted built-in plugin-install control and failed'
require_text "$behavioral_validation" 'executed both terminal commands, verified `design-arc@design-arc-marketplace` as installed and enabled'
require_text "$behavioral_validation" 'presented Benchmarks/Guidelines and Guided/Follow recommendation/Fully automatic independently'
require_text "$behavioral_validation" '| First use | Install once, then confirm this project’s preferences and separately approve or decline one pinned home. |'
require_text "$behavioral_validation" '| Next-day return | Open the project’s pinned home and use an ordinary-language starter; the home launches a clean local task in the same project. |'
require_text "$behavioral_validation" '| New product | Reuse the installed plugin, run setup in the new saved project, and keep its optional home and preferences separate. |'
require_text "$behavioral_validation" '| Multiple products | Keep at most one approved home per participating project and never create a global home. |'
require_text "$behavioral_validation" '| Duplicate discovery | Reuse the matching same-project home, report extras for user cleanup, and create no known duplicate. |'
require_text "$behavioral_validation" '| Task tools unavailable | Save only confirmed preferences, report that no home is ready, and provide the exact title, card, and manual create-and-pin steps. |'

require_text "$prompts" '# Design Arc prompt examples'
require_text "$prompts" 'You do not need to remember a command for ordinary journey work.'
require_text "$prompts" '## Plain-language journey starters'
require_text "$prompts" 'Help me make our onboarding less confusing.'
require_text "$prompts" 'Audit how customers complete checkout and propose a better complete journey.'
require_text "$prompts" 'Redesign account recovery so people can get back in without weakening security.'
require_text "$prompts" '## Preference and recovery commands'
require_text "$prompts" '$design-arc setup'
require_text "$prompts" '$design-arc evidence benchmarks'
require_text "$prompts" '$design-arc evidence guidelines'
require_text "$prompts" '$design-arc mode guided'
require_text "$prompts" '$design-arc mode follow-recommendation'
require_text "$prompts" '$design-arc mode fully-automatic'
require_text "$prompts" 'use Guidelines for this run'
require_text "$prompts" 'Bypass both gates'

printf '%s\n' 'PASS: Design Arc product documentation'
