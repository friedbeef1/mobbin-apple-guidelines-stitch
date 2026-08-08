# Motion grounding

Last checked: 2026-08-08

Motion needs evidence because it changes what people perceive, control, and can tolerate, not just how a screen looks. A transition can explain where content went, confirm that an action worked, or make an interruption feel recoverable. It can also conceal a delay, make a person wait without feedback, or cause discomfort. Design Arc therefore treats motion as part of the journey to inspect and specify, rather than decorative polish to add after a screen is approved.

## Start with the product and platform

Existing product motion and standard native behavior come first. Then use the current first-party guidance for the actual platform. Apple guidance is authoritative for Apple targets. For Android and web targets, their current first-party guidance takes precedence over conflicting Apple-inspired judgment. Product-specific choices that those sources do not decide remain clearly labeled Design Arc judgment.

Every material motion contract must name a reduced-motion alternative; no animation is the fallback only when it still preserves the needed information and control. The alternative might use an immediate state change, a persistent status message, or a simpler transition, but it must still let a person understand what happened and continue the task.

Implementation targets name the runtime and UI technology, such as Web, React, SwiftUI, UIKit, or Compose; timing uses milliseconds or seconds or a parameterized physical spring; easing uses cubic-bezier values, a named platform curve, or reproducible spring parameters. Interruption covers reversal, cancellation, and re-entry; provenance carries one required label plus citations and estimate basis; implementation source records authorization; proof status distinguishes specified, prototyped, staging, device, and production evidence.

## Precedent is not an implementation recipe

Shipped-product precedent shows what was observed in a comparable journey; an implementation library supplies tools, not proof that its defaults fit this product. A library can help an authorized implementation owner build a known behavior, but it cannot establish that the behavior is accessible, suitable for the objective, or correct for the platform.

Mobbin and Page Flows can help locate comparable product journeys when their use is separately authorized. A static Mobbin screen or sequence can establish only the visible states, changing element, journey location, and intended transition. It cannot establish exact temporal mechanics. A benchmark is still observed precedent, not a requirement, endorsement, or quality verdict.

Use a recording or playable journey when the decision depends on timing, easing, spring behavior, velocity, choreography, interruption, reversal, or a missing intermediate state. Record what was actually available: source, journey, observed path and order, known frame rate, measurement method, confidence, missing states, and whether any frame-derived value is an estimate. If no playback is available, keep temporal values as Design Arc judgment or `unverified`; never invent them from static screens.

## Implementation remains optional and must be proven later

Motion and Motion+ are optional implementation dependencies, never Design Arc requirements, evidence, authority, or bundled dependencies. An authorized implementation owner may separately choose an appropriate library and validate the actual result in the product's stack. That selection neither changes the evidence record nor authorizes source changes, staging, deployment, or release.

After separate authorization, Motion+ can assist an implementation owner with documentation and example search, reusable source retrieval, spring and easing work, saved-transition inspection, performance auditing, and design-system adaptation. These are implementation aids, not motion evidence, platform guidance, approval to install, or proof that the result works.

A prototype can communicate an intended interaction, but it cannot prove runtime quality. It does not prove frame rate, interruption behavior, accessibility settings, responsiveness, browser or native behavior, safe-area handling, or device performance. Those claims require current staging or target-device evidence after authorized implementation.

## Learn more from the source

These links are reference material, not a substitute for inspecting the actual product journey or recording the evidence used for a decision.

- [Apple Human Interface Guidelines: Motion](https://developer.apple.com/design/human-interface-guidelines/motion)
- [Android Compose animation introduction](https://developer.android.com/develop/ui/compose/animation/introduction)
- [Material Design 3 motion](https://m3.material.io/styles/motion/overview/how-it-works)
- [W3C `prefers-reduced-motion`](https://www.w3.org/TR/mediaqueries-5/#prefers-reduced-motion)
- [Mobbin MCP introduction](https://docs.mobbin.com/mcp/introduction)
- [Motion quick start](https://motion.dev/docs/quick-start)
- [Motion+ AI kit installation](https://motion.dev/docs/ai-kit-install)
- [Page Flows](https://pageflows.com/)
