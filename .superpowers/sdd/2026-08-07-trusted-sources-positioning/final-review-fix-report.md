# Final-review fix report — trusted-source destination allowlist

## Scope

- Base reviewed: `004260ca896c044243774c1d80ba025875485af9`
- Publication remains unauthorized; no push, deployment, installation, or provider action occurred.

## Finding corrected

The trusted-sources library exposed two external destinations outside the approved eight:

- `https://www.w3.org/standards/`
- `https://blog.google/innovation-and-ai/models-and-research/google-labs/stitch-ai-ui-design/`

Their destination links were removed while preserving the surrounding W3C and Stitch prose. The exact approved external destinations remain:

1. `https://developer.apple.com/design/human-interface-guidelines/`
2. `https://developer.android.com/design/ui/mobile`
3. `https://developer.android.com/guide/topics/ui/accessibility`
4. `https://m3.material.io/`
5. `https://www.w3.org/TR/WCAG22/`
6. `https://www.w3.org/WAI/ARIA/apg/`
7. `https://mobbin.com/`
8. `https://stitch.withgoogle.com/`

## Regression guard and TDD evidence

`scripts/test-design-arc-docs.sh` now reads every Markdown file directly under `docs/trusted-sources/`, extracts only `http`/`https` destinations, and fails unless their set is exactly the approved eight. Relative/internal links are intentionally outside this check.

- RED: before the documentation correction, the focused test failed with only the two unexpected destinations above.
- GREEN: after the correction, the same focused test passed.

## Verification

- `sh scripts/test-design-arc-docs.sh` passed.
- `sh scripts/test-test-validate.sh` passed.
- `sh scripts/validate.sh` passed, including 103 deterministic contract mutations, installation/migration/upgrade smoke tests, safety scans, and syntax checks.
- `git diff --check` passed.

## Remaining concern

The exact-destination allowlist deliberately requires a conscious review and test update when an additional external trusted-source destination is approved. This prevents unreviewed destination drift while leaving ordinary relative documentation links unconstrained.
