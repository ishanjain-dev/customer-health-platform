## Summary

<!-- What changes and why, in two or three sentences. -->

## Linked issue

Closes #<!-- issue number (CHP-<n>) -->

Requirements: <!-- FR-xx / NFR-xx IDs from docs/01-business-requirements.md -->

## How it was tested

<!-- Commands run and their results: make lint test, make sf-test, dbt build, a QA run-day... -->

## Screenshots (UI changes)

<!-- LWC, record page, reports or dashboard changes. Delete if not applicable. -->

## Deployment notes

<!-- Salesforce metadata changed, dbt models changed, warehouse migrations to run,
     new env vars or secrets the owner must add, manual Setup steps (click-by-click). -->

## Rollback plan

<!-- Exact steps to undo this change in QA and PROD. -->

## Checklist (definition of done)

- [ ] Branch named `feat|fix|chore|docs/CHP-<n>-<slug>`; Conventional Commit title
- [ ] Unit or model tests added and passing in CI
- [ ] Deployed to QA and verified against the acceptance criteria
- [ ] Docs updated (data dictionary, runbook, README or ADR as relevant)
- [ ] `CHANGELOG.md` updated under "Unreleased"
- [ ] No new secrets; no new paid features
- [ ] Salesforce storage and API budget unchanged, or the change is recorded
