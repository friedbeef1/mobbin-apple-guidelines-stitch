# Prompt examples

On first use, `$fb-ux` asks the user to choose Guided, Follow recommendation, or Fully automatic and saves the project preference in `.codex/fb-ux.yaml`. These examples can set or override that preference.

## Set Guided for the project

> `$fb-ux mode guided`. Save that for this project. Review the checkout journey for our iOS app. First, offer two or three suggested objectives and let me choose one or enter my own. After I confirm the objective, run the evidence workflow automatically and stop for my approval at the Direction and Stitch gates.

## Set Follow recommendation for the project

> `$fb-ux mode follow-recommendation`. Save that for this project. Review the subscription-upgrade journey for our web app. Confirm my objective, run the audit and research automatically, follow your recommendation, fully validate it, and create the complete Stitch proposal. Stop at the Stitch Gate.

## Set Fully automatic for the project

> `$fb-ux mode fully-automatic`. Save that for this project. My objective is to help legitimate users recover access with less uncertainty while preserving account security. Review the account-recovery journey, follow your recommendation, and continue through Stitch when the proposal meets direction. Preserve all implementation, staging, deployment, release, device-proof, external-service approval, and lane-ownership boundaries.

## Override one run without changing the project

> Use `$fb-ux` in Guided mode for this run only. Review onboarding against my objective of improving first-session activation. Do not change the saved project preference.

`Follow your recommendation` remains a one-run alias for Follow recommendation. `Bypass both gates` remains a one-run alias for Fully automatic when the request states an explicit objective.
