# Design Arc trusted sources

Last checked: 2026-08-07

Grounding makes a recommendation explainable instead of taste-based. Design Arc keeps four layers separate so a reader can see whether a conclusion comes from a platform requirement, an inspected product journey, explicit product judgment, or a visualization of the proposal.

| Grounding layer | What it supports | Named sources | What it cannot prove |
| --- | --- | --- | --- |
| Platform requirements | Current behavior, accessibility, and conventions for the affected platform. | [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/), [Android design guidance](https://developer.android.com/design/ui/mobile), [Material Design](https://m3.material.io/), and W3C web standards. | The best product trade-off for a particular objective. |
| Product precedent | How a relevant, complete real-product journey handles a similar decision and non-happy states. | An authorized provider such as [Mobbin](https://mobbin.com/). | A requirement, quality verdict, or proof that a pattern fits this product. |
| Product judgment | The recommendation and trade-offs for the user-confirmed objective where sources do not decide one answer. | Design Arc synthesis, labeled as judgment. | An external fact or provider endorsement. |
| Visualization and validation | A concrete proposed journey that can be inspected across material states. | [Google Stitch](https://stitch.withgoogle.com/). | Evidence, platform compliance, accessibility, or implementation readiness by itself. |

The affected platform's current first-party rules govern that platform. Benchmark precedent is used only when access is separately authorized and relevant journeys are actually inspected. Guidelines mode performs no benchmark lookup and makes no benchmark-evidence claim.

Read the focused guides for the source type and its limits:

- [Platform guidance](platform-guidance.md) — first-party platform and accessibility authority.
- [Product benchmarks](product-benchmarks.md) — observed precedent and authorization limits.
- [Visualization](visualization.md) — Stitch as a proposal and validation surface.

This repository links to external sources; it does not copy, mirror, bundle, or offer downloads of their guidance, libraries, screenshots, or documentation.
