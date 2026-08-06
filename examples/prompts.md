# Prompt examples

Choose `$fb-ux` when the review should use Apple guidance, inspected Mobbin journey precedent, and Stitch. Choose `$apple-guidelines-stitch` when the review should use official guidance and Stitch without a Mobbin dependency. On first use, each skill asks the user to choose Guided, Follow recommendation, or Fully automatic and saves a separate project preference: `.codex/fb-ux.yaml` or `.codex/apple-guidelines-stitch.yaml`.

## FB UX: set Guided for the project

> `$fb-ux mode guided`. Save that for this project. Review the checkout journey for our iOS app. First, offer two or three suggested objectives and let me choose one or enter my own. After I confirm the objective, inspect the current journey, use current Apple guidance and separately authorized Mobbin precedent, then stop for my approval at the Direction and Stitch gates.

## FB UX: set Follow recommendation for the project

> `$fb-ux mode follow-recommendation`. Save that for this project. Review the subscription-upgrade journey for our web app. Confirm my objective, run the audit and research automatically, follow your recommendation, fully validate it against current web guidance, and create the complete Stitch proposal. Stop at the Stitch Gate.

## Apple Guidelines + Stitch: set Guided for the project

> `$apple-guidelines-stitch mode guided`. Save that for this project. Review the account-recovery journey for our iOS app. First, offer two or three suggested objectives and let me choose one or enter my own. After I confirm the objective, use current Apple guidance and an authorized Stitch proposal only; do not use Mobbin. Stop for my approval at the Direction and Stitch gates.

## Apple Guidelines + Stitch: set Fully automatic for the project

> `$apple-guidelines-stitch mode fully-automatic`. Save that for this project. My objective is to help legitimate users recover access with less uncertainty while preserving account security. Review the Android and web account-recovery journey, apply current Android and web first-party rules over conflicting Apple-inspired judgment, follow your recommendation, and continue through Stitch only when the proposal meets direction. Preserve all implementation, staging, deployment, release, device-proof, external-service approval, and lane-ownership boundaries.

## Override one run without changing the project

> Use `$fb-ux` in Guided mode for this run only. Review onboarding against my objective of improving first-session activation. Do not change the saved project preference.

> Use `$apple-guidelines-stitch` in Guided mode for this run only. Review onboarding against my objective of improving first-session activation. Do not use Mobbin and do not change the saved project preference.

`Follow your recommendation` remains a one-run alias for Follow recommendation. `Bypass both gates` remains a one-run alias for Fully automatic when the request states an explicit objective. In either skill, the task should identify whether the active mode comes from the saved preference, an explicit override, or first-use/default selection.
