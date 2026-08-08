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

readme="$repo_root/README.md"
getting_started="$repo_root/docs/getting-started.md"
using_design_arc="$repo_root/docs/using-design-arc.md"
evidence_methodology="$repo_root/docs/evidence-and-methodology.md"
upgrades_migration="$repo_root/docs/upgrades-and-migration.md"
trust_sources="$repo_root/docs/trust-limitations-and-sources.md"
operating_layer="$repo_root/docs/codex-operating-layer.md"
behavioral_validation="$repo_root/docs/validation/behavioral-validation.md"
prompts="$repo_root/examples/prompts.md"
motion_sources="$repo_root/docs/trusted-sources/motion.md"
shared_navigation='[Home](../README.md) · [Getting started](getting-started.md) · [Using Design Arc](using-design-arc.md) · [Evidence and methodology](evidence-and-methodology.md) · [Upgrades and migration](upgrades-and-migration.md) · [Trust and sources](trust-limitations-and-sources.md)'

for file in "$readme" "$getting_started" "$using_design_arc" "$evidence_methodology" "$upgrades_migration" "$trust_sources" "$operating_layer" "$behavioral_validation" "$prompts" "$motion_sources"
do
  [ -f "$file" ] || fail "missing required documentation: ${file#"$repo_root/"}"
done

python3 - "$readme" <<'PY'
from pathlib import Path
import sys

text = Path(sys.argv[1]).read_text(encoding="utf-8")
line_count = len(text.splitlines())
if not 80 <= line_count <= 110:
    raise SystemExit(f"FAIL: README must contain 80-110 lines; found {line_count}")

ask_codex_instruction = "**Ask Codex:** Install the Design Arc plugin from\nhttps://github.com/friedbeef1/mobbin-apple-guidelines-stitch"
if ask_codex_instruction not in text:
    raise SystemExit("FAIL: README is missing the exact Ask Codex installation instruction")

for forbidden_text in ("```sh", "codex plugin", "skills registry", "Python", "Saved preferences and migration", "If Codex says"):
    if forbidden_text in text:
        raise SystemExit(f"FAIL: README retains forbidden advanced-installation content: {forbidden_text}")
PY

python3 - "$repo_root" "$readme" "$getting_started" "$using_design_arc" "$evidence_methodology" "$upgrades_migration" "$trust_sources" <<'PY'
from pathlib import Path
import re
import sys

repository_root = Path(sys.argv[1]).resolve()
documentation_pages = [Path(path) for path in sys.argv[2:]]

for source in documentation_pages:
    for target in re.findall(r"\[[^\]]+\]\(([^)]+)\)", source.read_text(encoding="utf-8")):
        if target.startswith(("http://", "https://", "mailto:", "#")):
            continue
        resolved = (source.parent / target.split("#", 1)[0]).resolve()
        try:
            resolved.relative_to(repository_root)
        except ValueError:
            raise SystemExit(f"FAIL: relative link escapes repository in {source}: {target}")
        if not resolved.exists():
            raise SystemExit(f"FAIL: broken relative link in {source}: {target}")

print("PASS: repository-relative Markdown links resolve")
PY

require_text "$readme" '# Design Arc'
require_text "$readme" 'Product feedback is often vague, redesign discussions become subjective, and teams approve attractive screens without knowing whether the complete journey works.'
require_text "$readme" 'Move from uncertain product feedback to a complete design direction grounded in credible sources.'
require_text "$readme" 'Design Arc audits the real journey, checks decisions against current first-party platform guidance and inspected real-product journeys, recommends the strongest path, and designs every important state before implementation begins.'
require_text "$readme" '## You need Design Arc if…'
require_text "$readme" '## What Design Arc produces'
require_text "$readme" '## The workflow'
require_text "$readme" '## Documentation'
require_text "$readme" '[Getting started](docs/getting-started.md)'
require_text "$readme" '[Using Design Arc](docs/using-design-arc.md)'
require_text "$readme" '[Evidence and methodology](docs/evidence-and-methodology.md)'
require_text "$readme" '[Upgrades and migration](docs/upgrades-and-migration.md)'
require_text "$readme" '[Trust and sources](docs/trust-limitations-and-sources.md)'
require_text "$readme" '## Install'
require_text "$readme" '## Start a review'
require_text "$readme" 'Help me make our onboarding less confusing.'
require_text "$readme" '## Trust'
require_text "$readme" 'Design Arc does not silently redesign, implement, or deploy your product. You choose the objective, evidence approach, and approval behavior.'
require_text "$readme" '## License'
require_text "$readme" '[MIT License](LICENSE)'

for file in "$getting_started" "$using_design_arc" "$evidence_methodology" "$upgrades_migration" "$trust_sources"
do
  require_text "$file" "$shared_navigation"
done

require_text "$getting_started" '# Getting started'
require_text "$getting_started" 'How do I install Design Arc and begin my first review?'
require_text "$getting_started" 'Design Arc is installed once for your Codex profile. Each participating project keeps its own setup and may have one approved, pinned home.'
require_text "$getting_started" 'Install Design Arc as a Codex plugin, not as a standalone skill.'
require_text "$getting_started" 'Add https://github.com/friedbeef1/mobbin-apple-guidelines-stitch as a plugin marketplace using ref `main`, then install `design-arc@design-arc-marketplace`.'
require_text "$getting_started" 'Do not search skills.sh or the standalone skills registry.'
require_text "$getting_started" 'Use the terminal commands below; do not use the built-in plugin-install control or `request_plugin_install`.'
require_text "$getting_started" 'Ask me for download permission if required, verify the plugin is enabled, and tell me to start a new task.'
require_text "$getting_started" 'No Python knowledge is required.'
require_text "$getting_started" '### If Codex says “no exact package exists in the skills registry”'
require_text "$getting_started" 'That response means Codex used the wrong installation route.'
require_text "$getting_started" 'If Codex says the plugin is not in the permitted recommended-plugin list, it used the built-in plugin-install control instead of the terminal commands.'
require_text "$getting_started" 'codex plugin marketplace add /path/to/mobbin-apple-guidelines-stitch'
require_text "$getting_started" 'Next: [Using Design Arc](using-design-arc.md).'

require_text "$using_design_arc" '# Using Design Arc'
require_text "$using_design_arc" 'How do I use Design Arc after installation?'
require_text "$using_design_arc" '| First day | Open the project, run `$design-arc setup`, choose the two project preferences, and approve or decline its proposed home. |'
require_text "$using_design_arc" '| Next day | Open that project’s pinned `Design Arc — <Project Name>` task and describe the journey in ordinary language. |'
require_text "$using_design_arc" '| New product | Open the new saved project and run setup there once. Its preferences and optional home stay separate from every other product. |'
require_text "$using_design_arc" 'Each home is a launchpad, not a workspace for the design review.'
require_text "$using_design_arc" 'Every journey starter opens a clean local task in that same saved project'
require_text "$using_design_arc" 'There is no global Design Arc home.'
require_text "$using_design_arc" 'A project with no confirmed Design Arc setup receives no home and no sidebar item.'
require_text "$using_design_arc" 'Design Arc reuses an existing home for the same title and project instead of creating a duplicate.'
require_text "$using_design_arc" 'If it finds extra same-project homes, it reports them for you to clean up; it never deletes them.'
require_text "$using_design_arc" 'If Codex cannot create or pin the task, Design Arc saves confirmed preferences, says clearly that no home is ready, and gives you the exact title, starter card, and manual create-and-pin steps.'
require_text "$using_design_arc" 'Help me make our onboarding less confusing.'
require_text "$using_design_arc" 'Audit how customers complete checkout and propose a better complete journey.'
require_text "$using_design_arc" 'Redesign account recovery so people can get back in without weakening security.'
require_text "$using_design_arc" '| Approval mode | Objective | Stitch Gate |'
require_text "$using_design_arc" 'Design Arc does not silently redesign, implement, or deploy your product. You choose the objective, evidence approach, and approval behavior.'
require_text "$using_design_arc" 'Next: [Evidence and methodology](evidence-and-methodology.md).'

require_text "$evidence_methodology" '# Evidence and methodology'
require_text "$evidence_methodology" 'How are Design Arc recommendations grounded and validated?'
require_text "$evidence_methodology" '| Grounding layer | Pain point | How Design Arc solves it | Credible sources used |'
require_text "$evidence_methodology" '| Platform requirements | Designs can feel unfamiliar, exclude users, or conflict with platform conventions. | Validate the journey against current guidance for its actual platform. | Apple HIG; Android and Material guidance; W3C web accessibility standards. |'
require_text "$evidence_methodology" '| Product precedent | Teams copy attractive screenshots without understanding the complete journey or failure states. | Inspect relevant end-to-end product journeys and explain why a pattern fits the objective. | Authorized benchmark research through a provider such as Mobbin. |'
require_text "$evidence_methodology" '| Product judgment | Opinions and trade-offs can be presented as if a source proved them. | Tie recommendations to the confirmed objective and label judgment separately from observed evidence. | User-confirmed objective and documented Design Arc synthesis—not an external authority. |'
require_text "$evidence_methodology" '| Visualization and validation | Polished screens can conceal missing transitions, errors, and recovery states. | Visualize the complete journey and inspect every important state before approving it for frontend implementation. | Google Stitch as a visualization tool—not an evidence authority. |'
require_text "$evidence_methodology" '| Motion specification | Codex + affected-platform guidance + inspected motion evidence | Defines what moves, why, how it behaves, its reduced-motion alternative, and what still requires implementation proof. |'
require_text "$evidence_methodology" '### Motion grounding and implementation proof'
require_text "$evidence_methodology" 'Design Arc specifies material on-screen animations and screen-to-screen transitions before frontend implementation.'
require_text "$evidence_methodology" 'Every material motion, including retained native or existing behavior, gets a contract with: Motion ID; journey location; purpose; trigger; start/end state; spatial behavior; choreography; timing; easing/spring; interruption; reduced motion; evidence; provenance; implementation target; implementation source; proof status.'
require_text "$evidence_methodology" 'Unsupported values are `unverified`.'
require_text "$evidence_methodology" 'Static screens or sequences support only start/end state, changing element, journey location, and transition intent; they cannot support exact duration, easing, springs, velocity, interruption, or choreography.'
require_text "$evidence_methodology" 'Directly applicable native or current first-party specifications and inspected playable evidence can support temporal behavior; otherwise temporal values remain labeled Design Arc judgment or `unverified`.'
require_text "$evidence_methodology" 'Stitch prototypes are design evidence, not staging or device implementation proof.'
require_text "$evidence_methodology" 'Each direction explains motion purpose and restraint, relevant precedent and platform guidance, provenance labels, reduced-motion implications, motion-specific risks, implementation complexity, and remaining proof.'
require_text "$evidence_methodology" 'A Stitch verdict evaluates the same motion requirements and contract alignment, and `meets direction` records prototype limitations and remaining runtime proof before Fully automatic may continue.'
require_text "$evidence_methodology" '[Motion grounding](trusted-sources/motion.md)'
require_text "$evidence_methodology" '[Behavioral validation](validation/behavioral-validation.md)'
require_text "$evidence_methodology" '[Trusted sources](trusted-sources/README.md)'
require_text "$evidence_methodology" 'Next: [Upgrades and migration](upgrades-and-migration.md).'

require_text "$upgrades_migration" '# Upgrades and migration'
require_text "$upgrades_migration" 'What happens when Design Arc is upgraded or replaces an older plugin?'
require_text "$upgrades_migration" 'codex plugin remove fb-ux@fb-ux-marketplace'
require_text "$upgrades_migration" 'codex plugin remove apple-guidelines-stitch@fb-ux-marketplace'
require_text "$upgrades_migration" 'codex plugin marketplace remove fb-ux-marketplace'
require_text "$upgrades_migration" 'codex plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch --ref main'
require_text "$upgrades_migration" 'codex plugin add design-arc@design-arc-marketplace'
require_text "$upgrades_migration" 'Start a new Codex task.'
require_text "$upgrades_migration" 'Never silently merge, rewrite, or delete either legacy preference file.'
require_text "$upgrades_migration" 'Next: [Trust and sources](trust-limitations-and-sources.md).'

require_text "$trust_sources" '# Trust, limitations and sources'
require_text "$trust_sources" 'What can Design Arc prove, access, implement, or release?'
require_text "$trust_sources" 'not bundled or official'
require_text "$trust_sources" 'Design Arc is not listed in Codex’s built-in recommended-plugin directory.'
require_text "$trust_sources" 'no documented public third-party directory submission route'
require_text "$trust_sources" '[Trusted sources](trusted-sources/README.md)'
require_text "$trust_sources" '[Codex operating layer](codex-operating-layer.md)'
require_text "$trust_sources" 'Next: [Home](../README.md).'

python3 - "$readme" "$getting_started" "$evidence_methodology" "$upgrades_migration" "$trust_sources" <<'PY'
from pathlib import Path
import re
import sys

text = Path(sys.argv[1]).read_text(encoding="utf-8")
install_section = Path(sys.argv[2]).read_text(encoding="utf-8")
methodology = Path(sys.argv[3]).read_text(encoding="utf-8")
migration = Path(sys.argv[4]).read_text(encoding="utf-8")
trust = Path(sys.argv[5]).read_text(encoding="utf-8")
prompt_start = install_section.index("Install Design Arc as a Codex plugin, not as a standalone skill.")
marketplace_command = "codex plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch --ref main"
plugin_command = "codex plugin add design-arc@design-arc-marketplace"
if marketplace_command not in install_section:
    raise SystemExit("FAIL: getting-started must include the exact marketplace command")
if plugin_command not in install_section:
    raise SystemExit("FAIL: getting-started must include the exact Design Arc install command")
marketplace_position = install_section.index(marketplace_command)
plugin_position = install_section.index(plugin_command)
if marketplace_position < prompt_start or plugin_position < prompt_start:
    raise SystemExit("FAIL: explicit plugin commands must appear directly after the copyable Codex instruction")
if marketplace_position > plugin_position:
    raise SystemExit("FAIL: getting-started must add the marketplace before adding Design Arc")
if "Codex handles the installation" in install_section:
    raise SystemExit("FAIL: README must not promise that Codex infers the marketplace route automatically")
if "skills.sh URL or package name" in install_section:
    raise SystemExit("FAIL: troubleshooting must not route Design Arc back to a standalone skills registry")
if "Visual Gate" in "".join((text, install_section, methodology, migration, trust)):
    raise SystemExit("FAIL: documentation must use the required Stitch Gate name, not Visual Gate")

local_command = "codex plugin marketplace add /path/to/mobbin-apple-guidelines-stitch"
if local_command not in install_section.splitlines():
    raise SystemExit("FAIL: getting-started must show the exact local-checkout marketplace command")
if f"{local_command} --ref main" in install_section:
    raise SystemExit("FAIL: documentation local-checkout marketplace command must not use the Git-only --ref option")

headings = re.findall(r"^#{1,2} .+$", text, re.MULTILINE)
expected_headings = [
    "# Design Arc",
    "## Documentation",
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
workflow_instruction = "**Only rows marked 👤 You require your involvement. Design Arc handles every unmarked step.**"
workflow_table = """| Workflow step | Platform or source handling it | Human involvement |
| --- | --- | --- |
| Describe the outcome you want | Codex | **👤 You** |
| ↓ | | |
| Audit the current journey | Your website or app + Codex | |
| ↓ | | |
| Gather and label evidence | Mobbin + Codex in Benchmarks mode, and official platform guidance + Codex in Guidelines mode | |
| ↓ | | |
| Recommend a design direction | Codex | |
| ↓ | | |
| Approve design direction | Codex | **👤 You** |
| ↓ | | |
| Validate against platform guidance | Apple, Android, Material, or W3C guidance + Codex | |
| ↓ | | |
| Decide on any design motion | Relevant official guidance + inspected motion evidence + Codex | |
| ↓ | | |
| Visualize the complete journey | Google Stitch + Codex | |
| ↓ | | |
| Validate every important state | Google Stitch renders + Codex | |
| ↓ | | |
| Approve the visual proposal | Codex | **👤 You** |
| ↓ | | |
| Prepare the design handoff | Codex | |"""

def validate_workflow(candidate):
    expected_table = f"## The workflow\n\n{workflow_instruction}\n\n{workflow_table}"
    following_prose = "Setup resolves two independent choices: how evidence is gathered and where Codex pauses for approval."
    if not candidate.startswith(expected_table):
        raise ValueError("workflow must use the exact instruction, table header, separator, and ordered rows")
    if not candidate[len(expected_table):].startswith(f"\n\n{following_prose}"):
        raise ValueError("workflow table must end immediately after the final handoff row")
    if candidate.count("| ↓ | | |") != 10:
        raise ValueError("workflow must preserve the 10-row arrow sequence")
    if candidate.count("**👤 You**") != 3:
        raise ValueError("workflow must contain exactly three human-involvement markers")

validate_workflow(workflow)

for mutated_workflow in (
    workflow.replace(workflow_instruction, "**Design Arc handles every step.**", 1),
    workflow.replace("| Workflow step | Platform or source handling it | Human involvement |", "| Workflow | Platform | Human |", 1),
    workflow.replace(
        "| Describe the outcome you want | Codex | **👤 You** |\n| ↓ | | |\n| Audit the current journey | Your website or app + Codex | |",
        "| Audit the current journey | Your website or app + Codex | |\n| ↓ | | |\n| Describe the outcome you want | Codex | **👤 You** |",
        1,
    ),
    workflow.replace(
        "| Prepare the design handoff | Codex | |\n\nSetup resolves",
        "| Prepare the design handoff | Codex | |\n| Record a follow-up | Codex | |\n\nSetup resolves",
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
    "codex plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch --ref main",
    "codex plugin add design-arc@design-arc-marketplace",
    "Start a new Codex task.",
]
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
require_text "$motion_sources" 'After separate authorization, Motion+ can assist an implementation owner with documentation and example search, reusable source retrieval, spring and easing work, saved-transition inspection, performance auditing, and design-system adaptation.'
require_text "$motion_sources" 'Implementation targets name the runtime and UI technology, such as Web, React, SwiftUI, UIKit, or Compose; timing uses milliseconds or seconds or a parameterized physical spring; easing uses cubic-bezier values, a named platform curve, or reproducible spring parameters.'
require_text "$motion_sources" 'Interruption covers reversal, cancellation, and re-entry; provenance carries one required label plus citations and estimate basis; implementation source records authorization; proof status distinguishes specified, prototyped, staging, device, and production evidence.'
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

if [ "${DESIGN_ARC_DOCS_SKIP_BROKEN_LINK_MUTATION:-}" != '1' ]
then
  mutation_checkout="$task_temp_dir/broken-link-fixture"
  cp -R "$repo_root" "$mutation_checkout"
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
  cp -R "$repo_root" "$escape_checkout"
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

  license_checkout="$task_temp_dir/license-link-fixture"
  cp -R "$repo_root" "$license_checkout"
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
  cp -R "$repo_root" "$command_order_checkout"
  command_order_page="$command_order_checkout/docs/getting-started.md"

  python3 - "$command_order_page" <<'PY'
from pathlib import Path
import sys

page = Path(sys.argv[1])
original = page.read_text(encoding="utf-8")
marketplace_command = "codex plugin marketplace add friedbeef1/mobbin-apple-guidelines-stitch --ref main"
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

  printf '%s\n' "$output" | grep -F 'FAIL: getting-started must add the marketplace before adding Design Arc' >/dev/null || {
    printf '%s\n' "$output" >&2
    fail 'plugin-command-order mutation failed for the wrong reason'
  }
  printf '%s\n' 'PASS: plugin-command-order mutation is rejected'
fi
