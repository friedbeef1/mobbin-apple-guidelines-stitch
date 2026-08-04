# FB UX: Distribution Design

## Objective

Turn the existing `fb-ux` workflow into a public, directly installable Codex skill. Prepare and validate the repository locally, then publish the same history to a public GitHub repository.

## Why This Exists

UI redesign work often jumps too quickly from a subjective reaction—“this journey feels wrong”—to isolated inspiration or generated screens. That can produce attractive mockups without proving that the proposed journey solves the product problem, follows platform conventions, or covers the states a user will actually encounter.

This skill makes the reasoning inspectable and repeatable. It begins by asking the user what outcome they are trying to accomplish rather than inferring the objective from the current interface. It then evaluates the current product against that confirmed outcome, uses Apple guidance as governing platform evidence, uses Mobbin as observed design precedent, and asks Stitch to visualize the complete selected journey. Codex remains the decision surface, so a user can understand the recommendation, compare alternatives, control the approval gates, and judge the generated result without having to reconstruct the reasoning across three external tools.

The intended outcome is not “make a prettier screen.” It is a coherent, evidence-backed journey proposal with explicit trade-offs, honest validation, complete states, and a safe boundary before implementation or deployment.

## Naming

- Public display name: `FB UX`
- Repository slug: `mobbin-apple-guidelines-stitch`
- Internal skill name: `fb-ux`

The folder, frontmatter name, default prompt, installation path, and documentation all use `fb-ux` as the canonical skill identifier.

## Repository Structure

```text
mobbin-apple-guidelines-stitch/
├── skills/
│   └── fb-ux/
│       ├── SKILL.md
│       └── agents/openai.yaml
├── examples/
│   └── prompts.md
├── scripts/
│   └── validate.sh
├── docs/superpowers/specs/
│   └── 2026-08-04-mobbin-apple-guidelines-stitch-design.md
├── .gitignore
├── LICENSE
└── README.md
```

## Distribution

Install `skills/fb-ux` directly from GitHub using a compatible Codex skill installer. The README will provide the exact command and a manual-copy fallback. The repository will not include a plugin manifest, marketplace entry, MCP server, connector, or application wrapper.

The README will state any required external access. The skill does not bundle Mobbin, Apple, or Stitch services, accounts, credentials, connectors, or proprietary content.

## Packaged Behavior

The public skill will contain this journey workflow:

1. Confirm what the user is trying to accomplish.
2. Audit the current website or app journey against that objective.
3. Perform a lightweight Apple and affected-platform grounding pass.
4. Inspect relevant Mobbin journeys and images.
5. Recommend one default direction plus meaningful alternatives.
6. Apply the Direction Approval Gate.
7. Validate the selected direction rigorously against official guidance.
8. Generate all material journey screens and states in Stitch.
9. Embed decision-ready renders and recommendations in Codex.
10. Validate the generated proposal.
11. Apply the Stitch Approval Gate.
12. Route approved work without implying implementation or deployment authority.

### Objective Confirmation

Before product audit or external research, ask the user what outcome they want the journey to achieve. Offer two or three plausible, mutually distinct objectives when the available context supports them, and always allow the user to enter their own objective. Do not make the user choose an agent-generated option.

If the initial request already states an objective, restate it concisely and ask the user to confirm or revise it. Do not inspect Apple guidance, search Mobbin, or generate in Stitch until the objective is confirmed. Use the confirmed objective as the evaluation criterion throughout the run.

Objective Confirmation is not one of the two design approval gates. Instructions to `follow your recommendation` or `bypass both gates` do not bypass an unconfirmed objective. Once the user has explicitly stated or confirmed the objective, do not ask for it again unless the scope materially changes.

Approval modes remain explicit:

- No bypass instruction: stop at both gates.
- `Follow your recommendation`: bypass only the Direction Approval Gate.
- `Bypass both gates` or an equally explicit instruction: bypass both design gates.

Bypassing gates never waives current evidence, separately required external-service payload approval, accessibility/device verification, repository ownership, implementation authorization, staging approval, or live-release approval.

## Documentation and Examples

The README will include:

- What the skill does and does not do.
- Direct skill-installation instructions and a manual fallback.
- External prerequisites for Mobbin, Apple guidance, and Stitch access.
- Objective Confirmation, including suggested choices and free-form input.
- The two approval gates and all three approval modes.
- A compact example workflow.
- Integrity and implementation boundaries.

`examples/prompts.md` will include prompts for default stopping, recommended-direction continuation, and explicit two-gate bypass. Examples will not contain copied Mobbin assets or imply service affiliation.

## Validation

Before publication:

- Validate the skill with `quick_validate.py`.
- Run the repository validation script.
- Inspect the packaged skill against the installed source.
- Check Markdown, JSON, shell syntax, and whitespace.
- Confirm the repository contains no credentials, local absolute paths, or private product artifacts.
- Perform a clean-clone smoke check where practical.

## Publication

Create a public GitHub repository named `mobbin-apple-guidelines-stitch`, commit the validated local package, and push the initial branch. Do not create a release, marketplace listing, website, deployment, or third-party integration in this scope.

Use the MIT license. The README will state that Mobbin, Apple, and Stitch are trademarks of their respective owners and that the project is an independent workflow package, not an official integration or endorsement.

## Success Criteria

- The local repository is complete and passes the skill and repository validators.
- A user can understand why the skill exists and install it directly from the README.
- The workflow cannot begin research from an inferred objective; the user must confirm or supply the intended outcome.
- Gate semantics are unambiguous in both the skill and examples.
- The public GitHub repository matches the validated local commit.
- No proprietary Mobbin content, private product evidence, credentials, or unsupported compliance claims are distributed.
