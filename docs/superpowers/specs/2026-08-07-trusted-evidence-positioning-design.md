# Design Arc trusted-evidence positioning

## Objective

Make credible-source grounding visible within the opening of the Design Arc README so readers understand immediately that recommendations are supported, traceable, and not based on taste alone.

## Approved direction

Keep the hero provider-neutral and outcome-led. Use **credible sources** as the plain-language promise. Immediately beneath the hero, define that promise using the actual evidence hierarchy:

1. Current first-party guidance for the product's platform.
2. Inspected, relevant end-to-end product journeys when benchmark access is authorized.
3. Clearly labeled product-specific judgment where sources do not determine the answer.
4. Stitch visualization as a proposal and validation surface, not an evidence source by itself.

Apple, Android, web, Mobbin, and Stitch may be named in the explanation beneath the generic promise, but they do not become the product's identity or headline.

## README changes

- Change the primary outcome line from “evidence-backed” to “grounded in credible sources.”
- Expand the opening description to mention current first-party platform guidance and inspected real-product journeys.
- Add a compact “Grounded, not guessed” block immediately after the introduction.
- Explain the distinction among authoritative guidance, observed precedent, product judgment, and visualization.
- Link that opening block to a repository-owned Trusted Sources Library.
- Rename “Choose your evidence approach” to “Choose how Design Arc grounds its recommendations.”
- Preserve the existing detailed evidence-mode table, provider limitations, authorization requirements, gates, installation instructions, upgrade guidance, and trademarks.

## Proposed opening

> **Move from uncertain product feedback to a complete design direction grounded in credible sources.**  
> Design Arc audits the real journey, checks decisions against current first-party platform guidance and inspected real-product journeys, recommends the strongest path, and designs every important state before implementation begins.

Then:

> **Grounded, not guessed.** Design Arc keeps authoritative platform guidance, observed product precedent, and product-specific judgment distinct, so teams can see what supports each recommendation.

The supporting points will state:

- First-party platform guidance is authoritative for its platform.
- Relevant complete product journeys provide precedent only when actually inspected.
- Popularity, metadata, and isolated screenshots are not proof of quality.
- Product judgment is labeled rather than presented as sourced fact.
- Stitch visualizes and tests the proposed journey but is not evidence by itself.

## Trusted Sources Library

Add `docs/trusted-sources/` as a small, readable source library:

```text
docs/trusted-sources/
  README.md
  platform-guidance.md
  product-benchmarks.md
  visualization.md
```

The README links directly to `docs/trusted-sources/README.md` from the opening “Grounded, not guessed” block.

Each writeup explains:

- what kind of source it covers;
- when Design Arc uses it;
- what authority that source does and does not have;
- links to current official pages for deeper reading;
- the date those links were last checked.

`platform-guidance.md` links to official Apple Human Interface Guidelines, Android design and accessibility guidance, Material Design, and W3C web and accessibility standards. It makes platform precedence explicit: the affected platform's current first-party rules govern that platform.

`product-benchmarks.md` explains that benchmark providers such as Mobbin supply inspected product precedent, not first-party requirements or automatic proof of quality. It links to the provider's official site and keeps access requirements explicit.

`visualization.md` explains that Google Stitch is a visualization surface rather than an authority or evidence source. It links to Google's official Stitch information and preserves separate access and payload authorization.

The repository does not copy, mirror, bundle, or offer downloads of external guidance, benchmark libraries, screenshots, or provider documentation. It links to official pages so readers can learn more from the source.

## Success criteria

- A reader sees credible-source grounding before the first section heading.
- The opening remains understandable without knowing Apple, Mobbin, or Stitch.
- Named sources appear close enough to make “credible” concrete.
- The opening links to a repository source index, and every linked writeup routes readers to official external pages for deeper information.
- Official guidance, benchmark precedent, Design Arc judgment, and visualization remain clearly separated.
- No external material is copied or offered for download.
- The copy does not imply bundled access, official provider endorsement, universal Apple precedence, or benchmark evidence in Guidelines mode.
- Existing Design Arc evidence integrity and authorization boundaries remain unchanged.
