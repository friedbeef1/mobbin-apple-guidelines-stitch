# Visualization and validation

Last checked: 2026-08-07

Visualization turns a recommended journey into a concrete proposal that can be inspected across its material entry, transition, loading, empty, error, success, cancellation, and recovery states. Design Arc generates a consolidated static journey board in the AI coding platform by default: Codex for the Codex adapter, Claude Code for the Claude adapter, and Google Antigravity for the Antigravity adapter. It can use [Google Stitch](https://stitch.withgoogle.com/) as an optional external editing workspace after the direction is established.

## Why there are two routes

The AI coding platform is the lower-friction route for a bounded proposal and a few corrections. It generates screens rather than disposable application logic. Stitch becomes useful when sustained visual iteration, multi-screen changes, self-editing, collaboration, future-session continuity, device variants, or design export makes a persistent canvas easier to manage. Design Arc may recommend that move early, but the user always chooses it.

## What Stitch supports

Google describes Stitch as a design canvas for generating and iterating high-fidelity UI; see its official Stitch introduction. Its visual output helps a team inspect whether the proposed journey is complete enough to evaluate and whether important states are missing.

## What it cannot prove

Stitch is not an authority or evidence source by itself. Its output does not prove a platform requirement, product inspection, accessibility, safe-area behavior, browser or native behavior, physical-device compliance, implementation readiness, or release authorization. Those claims require their own current-task evidence and the relevant first-party source.

Stitch access and any payload sent to it require separate authorization. The repository neither bundles Stitch access nor treats a Stitch result as permission to implement, deploy, or otherwise change product source.
