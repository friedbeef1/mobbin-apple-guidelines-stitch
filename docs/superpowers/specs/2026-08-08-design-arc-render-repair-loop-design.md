# Design Arc Render-Repair Loop Design

Date: 2026-08-08
Status: Approved direction; written specification awaiting user review

## Problem

Stitch can visually drift from the approved Design Arc direction. A render may
look polished while changing a specified control, state, hierarchy, label, or
interaction detail. Design Arc already requires Codex to inspect the render and
assign a Stitch verdict, but it does not require Codex to correct straightforward
drift and re-inspect the result before involving the user.

That leaves the user acting as the primary compliance checker and allows a
written correction note to be mistaken for a corrected visual proposal.

## Desired outcome

Codex should automatically correct ordinary Stitch rendering drift, inspect the
new result, and repeat only as long as the proposal is converging safely. The
user should see the visual proposal only after it matches the approved direction
or after the bounded repair process cannot resolve the remaining mismatches.

## Chosen approach

Use one initial Stitch proposal followed by at most three batched correction
rounds for the entire proposal. Each round contains every currently known,
repairable mismatch rather than retrying each mismatch independently.

Three correction rounds are the fixed maximum. A fourth, fifth, or sixth round
is not attempted automatically. Failure to converge after three precise rounds
is treated as a specification ambiguity, provider limitation, conflicting
requirement, or persistent generation failure rather than a reason for an
unbounded retry loop.

Alternatives rejected:

- Flag-only validation retains the current user burden.
- Five or six fixed rounds increase cost and oscillation risk without addressing
  the likely cause of persistent drift.
- An optional fourth round makes the stopping rule unpredictable and harder to
  audit.

## Terminology and counting

- **Initial proposal:** the first complete Stitch output. It is not a correction
  round.
- **Correction round:** one batched correction request, one resulting proposal,
  and one complete re-inspection.
- **Attempt record:** the initial proposal plus zero to three correction rounds.
- **Approved specification:** the selected Design Arc direction after the
  Direction Gate, including platform constraints, screen and state requirements,
  interaction details, material motion contracts, and explicitly labeled product
  judgment.

The maximum therefore permits four rendered proposals: the initial proposal and
three corrected proposals.

## Conformance inspection

Before assigning a Stitch verdict, Codex creates a conformance matrix for every
material screen and state. Each row records:

- screen or state identifier;
- approved requirement and its provenance;
- observed render evidence;
- `match`, `repairable drift`, `direction decision required`, or `runtime proof`;
- the exact correction or next action; and
- the render identifier on which the observation was made.

The inspection covers the approved journey sequence, controls, labels,
hierarchy, navigation, targets, spacing, containment, safe areas, orientation,
text size, accessibility representation, empty/error/success/recovery states,
assets, and every property that Stitch can express from the motion contracts.

A correction note is not proof of correction. Only inspection of a newly
generated render may change a mismatch row to `match`.

## Mismatch classification

### Repairable drift

A visible output differs from an unambiguous approved requirement, and correcting
it would not change the approved direction. Examples include the wrong shutter
shape, omitted state, incorrect label, displaced control, or inconsistent visual
token.

Codex batches all repairable drift into the next correction round without asking
the user for approval.

### Direction decision required

The correction would alter the approved product direction, resolve a material
ambiguity, choose between conflicting requirements, or introduce a new product
judgment. Codex stops immediately, explains the decision, and asks the user. It
does not spend a correction round pretending that a product decision is rendering
drift.

### Runtime proof

The requirement cannot be proven by Stitch, including device behaviour,
performance, exact runtime motion, focus behaviour, or measured accessibility.
Codex carries the item forward as unverified implementation proof. It does not
retry Stitch or claim visual compliance establishes runtime compliance.

## Repair state machine

1. Generate the initial complete proposal.
2. Inspect every material render against the approved specification.
3. If every Stitch-expressible requirement matches, assign `meets direction` and
   proceed to the existing Stitch Gate policy.
4. If a direction decision is required, external access is unavailable, or a
   correction is not authorized, stop and flag the exact blocker.
5. If repairable drift exists and fewer than three correction rounds have been
   used, send one batched correction request.
6. Inspect the complete resulting proposal again; never trust command success,
   metadata, or a written correction summary.
7. Repeat steps 3–6 until the proposal matches or the loop stops.
8. After the third unsuccessful correction round, stop and assign
   `meets with corrections` or `does not meet` according to the remaining scope.

Codex may stop before the third round when:

- the same material mismatch shows no improvement across two consecutive
  corrected proposals;
- two consecutive corrected proposals oscillate by repairing one requirement
  while breaking another;
- the provider or required render evidence becomes unavailable;
- the next correction would change the approved direction; or
- continuing would require new external authorization.

Early stopping must cite the observed render evidence and reason. It cannot be
used merely to save effort when the proposal is still safely converging.

## Verdict and gate behaviour

`meets direction` is valid only after the most recent complete proposal has been
inspected and all Stitch-expressible requirements match. Documented runtime-proof
limitations remain allowed when clearly carried forward and do not masquerade as
visual validation.

`meets with corrections` means unresolved, bounded mismatches remain but the
direction is still recognizable. `does not meet` means the proposal materially
contradicts or fails to represent the approved direction.

- **Guided:** Codex performs the repair loop automatically, then stops at the
  Stitch Gate. When the result meets direction, the user approves the visual
  proposal. When it does not, the user receives the unresolved report and choices
  to revise the direction, accept a clearly labeled product exception where
  allowed, or stop. An exception cannot convert the verdict to `meets direction`
  or waive a current first-party platform or accessibility requirement.
- **Follow recommendation:** the same Stitch behaviour as Guided. Automatic
  Direction selection does not bypass visual conformance.
- **Fully automatic:** Codex performs the same repair loop and continues past the
  Stitch Gate only on `meets direction`. Any other verdict stops and flags the
  result.

No approval mode bypasses inspection, retries, evidence integrity, platform
precedence, external authorization, or implementation and release boundaries.

## Correction request integrity

Every correction request:

- identifies the source render and affected screen/state IDs;
- states the observed mismatch and exact approved requirement;
- changes only repairable drift;
- preserves already matching requirements and the approved direction;
- requests a complete enough result to re-inspect affected and potentially
  regressed states; and
- records the new render or screen identifiers returned by Stitch.

Codex must detect new drift introduced by a correction. New mismatches join the
next batched round and remain visible in the attempt record.

## Required run record

Add a render-repair record containing:

- initial proposal identifiers;
- conformance matrix for each inspected proposal;
- correction round number from 1 through 3;
- batched correction request and provenance;
- fixed, remaining, and newly introduced mismatches;
- early-stop or exhaustion reason;
- final Stitch verdict; and
- remaining runtime or implementation proof.

The Codex conversation must summarize this evidence. A Stitch board or provider
status is not a substitute for it.

## Documentation impact

Update the Design Arc skill contract, evidence-and-methodology guide, everyday-use
guide, operating-layer explanation, and behavioral-validation documentation. The
short README workflow remains accurate: Design Arc validates every important
state before asking the user to approve the visual proposal.

The user-facing explanation should say that ordinary visual drift is corrected
automatically, the whole proposal gets at most three correction rounds, and
unresolved drift is flagged rather than silently approved.

## Verification

Add deterministic contract assertions and negative mutations proving that Design
Arc requires:

- one initial proposal plus at most three batched correction rounds;
- automatic repair of unambiguous drift before user involvement;
- complete re-inspection after every correction;
- no correction claim without a new inspected render;
- immediate stopping for direction changes or missing authorization;
- early-stop evidence and exhaustion reporting;
- no `meets direction` verdict with an unexplained render mismatch;
- Guided and Follow recommendation stopping at the Stitch Gate after repair;
- Fully automatic continuing only on `meets direction`; and
- unchanged implementation, staging, deployment, and release boundaries.

Run the focused workflow mutations, documentation checks, complete repository
validation, plugin and skill validation, safety scans, isolated install/migration/
upgrade checks, and `git diff --check`.

## Release boundary

Package this behaviour as Design Arc `0.2.3`, the next patch release after the
currently published `0.2.2`. Stop on a clean, tested, independently reviewed branch.
Publishing to GitHub and upgrading the user's installed plugin require separate
explicit approval.
