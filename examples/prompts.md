# Prompt examples

Each request below starts by asking Codex to offer suggested objectives and retain a free-form choice. Objective Confirmation still happens before the product is inspected, external sources are researched, or a Stitch proposal is generated.

## Default mode: stop at both design gates

> Use `$fb-ux` to review the checkout journey for our iOS app. First, offer two or three suggested objectives and let me choose one or enter my own. After I confirm the objective, audit the current journey, ground the review in current Apple guidance, inspect relevant Mobbin flows, and recommend directions. Stop for my approval at the Direction Gate, then stop again at the Stitch Gate after presenting the validated complete Stitch journey.

## Recommended-direction mode: stop at Stitch

> Use `$fb-ux` to review the subscription-upgrade journey for our web app. First, offer two or three suggested objectives and let me choose one or enter my own. After I confirm the objective, audit the journey, use current first-party guidance and inspected Mobbin flows, then recommend directions. Follow your recommendation. Fully validate it and create the complete Stitch proposal, but stop at the Stitch Gate so I can approve the rendered proposal.

## Two-gate bypass mode: route only the validated proposal

> Use `$fb-ux` to review the account-recovery journey for our mobile app. First, offer two or three suggested objectives and let me choose one or enter my own. Do not begin the audit until I confirm an objective. After confirmation, audit the current journey, use current official guidance and inspected Mobbin precedent, recommend directions, and Bypass both gates. Preserve evidence integrity and all implementation, staging, deployment, release, device-proof, external-service approval, and lane-ownership boundaries: route only the validated Stitch proposal to the authorized integration lane.
