# Platform guidance

Last checked: 2026-08-07

Platform guidance supplies the current first-party rules that constrain a proposal's behavior, conventions, and accessibility. Design Arc uses it for every affected platform before calling a journey ready for a design handoff.

## Authority and precedence

The affected platform's current first-party rules govern that platform. Apple Human Interface Guidelines are authoritative for Apple targets; Android's current guidance governs Android targets; and W3C standards and accessibility guidance govern web targets. Material Design is useful Android guidance, but it does not override Android platform requirements or the first-party rules of another target platform.

Platform guidance does not determine the product objective, prove that a user journey was inspected, choose every trade-off, or make a generated proposal implementation-ready. Design Arc labels those product-specific decisions as judgment and validates them separately.

## Motion guidance

Existing product motion and standard native behavior come first. Design Arc uses the affected platform's current first-party guidance to decide when motion is purposeful, how it preserves continuity and feedback, whether it can be interrupted, and what reduced-motion alternative is required. Custom duration, easing, spring, and choreography choices remain labeled product judgment unless current evidence supports them.

Inspected product motion may supply precedent for a comparable interaction. A screenshot or static screen sequence cannot prove exact motion timing, easing, velocity, spring behavior, or choreography. Stitch may demonstrate a design interaction, but only the implemented staging or device experience can prove runtime behavior, responsiveness, accessibility settings, and performance.

## Official sources

- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/) — Apple platform design principles and component guidance.
- [Android design guidance](https://developer.android.com/design/ui/mobile) — Android UI and platform guidance.
- [Android accessibility guidance](https://developer.android.com/guide/topics/ui/accessibility) — accessibility considerations for Android UI.
- [Material Design](https://m3.material.io/) — Google's Material system guidance, including design and accessibility patterns.
- W3C web standards — standards for the open web platform.
- [W3C Web Content Accessibility Guidelines 2.2](https://www.w3.org/TR/WCAG22/) — stable, referenceable accessibility guidance for web content.
- [WAI-ARIA Authoring Practices Guide](https://www.w3.org/WAI/ARIA/apg/) — accessible interaction-pattern guidance for web interfaces.

Use the relevant current source for the product being reviewed; do not apply Apple-inspired judgment as a substitute for Android or web requirements.
