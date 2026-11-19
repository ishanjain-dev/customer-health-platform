# CLAUDE.md — Customer Health Platform

## Source of truth

The build specification (exported to docs/00-build-spec.pdf) defines scope and design.
If a task conflicts with it, stop and ask; propose an ADR instead of improvising.

## Non-negotiables

- Zero spend: never enable paid features, never suggest adding a payment method,
  never create a Snowflake warehouse above XSMALL or auto-suspend above 60s.
- No secrets in code, logs, tests or fixtures. Use env vars via chp.config only.
- Synthetic data only, example.com domains.
- Never run anything against PROD (Salesforce org #1, CHP_PROD, chp_prod) from a
  local session. PROD changes happen only through deploy-prod.yml.

## How to work

1. Work one GitHub issue at a time. Read its acceptance criteria first.
2. Branch: feat/CHP-<issue>-<slug> (or fix/, chore/, docs/).
3. Write or update tests first where practical; then code; then docs.
4. Run `make lint test` (and `make sf-test` for Salesforce changes) before committing.
5. Conventional Commits. Small, reviewable PRs (aim < 400 changed lines).
6. Open the PR with the template filled in, including how you tested and rollback.
7. Never merge your own PR. The owner reviews and merges.
8. Update CHANGELOG.md under "Unreleased" in the same PR.

## Coding standards

- Python 3.12, type hints everywhere, mypy --strict on src/, ruff format.
- Pipeline code talks to warehouses only through chp.warehouse.base.Warehouse.
- Every job is idempotent for a business date and accepts --date.
- Apex: one trigger per object, handler pattern, with sharing, WITH USER_MODE,
  bulk-safe, 90%+ coverage with bulk and permission tests.
- LWC: no external libraries; SLDS classes; Jest tests for every component.
- dbt: naming per section 11.1; every model documented and tested; adapter
  differences only inside dispatched macros.
- SQL: lowercase keywords; the sqlfluff config in the repo is the authority.

## Things that need the owner

Account sign-ups, Setup-only UI steps, certificates, GitHub secrets, approvals.
When one is needed, write exact click-by-click steps in the PR or issue and stop.

## Local environment (addition to spec section 18)

- sf CLI aliases: `chp-prod` = Salesforce org #1 (PROD, Dev Hub); `chp-qa` = org #2 (QA).
  `salesforce/.sf/config.json` sets target-org `chp-qa` and target-dev-hub `chp-prod`.
  Never pass `--target-org chp-prod` locally; the Dev Hub is used only to create scratch orgs.
- Git hooks: husky (installed by `npm install` in `salesforce/`) owns `core.hooksPath`.
  Its pre-commit hook runs lint-staged for `salesforce/`, then the `pre-commit` framework
  (`.pre-commit-config.yaml`) for the rest of the repo. Do not run `pre-commit install`.
