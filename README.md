# Customer Health Platform (CHP)

A production-style Salesforce + Snowflake project for **Nimbus Analytics**, a fictional
B2B SaaS company. Every day it ingests CRM, product usage and billing data, computes a
health score (0 to 100) per account with dbt, and writes the score, band, drivers and
trend back into Salesforce, where Customer Success Managers act on alerts and tasks.

It runs on free tiers only, on a daily schedule, and is delivered with real project
discipline: issues, branches, pull requests, CI, environments, releases, runbooks and
incident write-ups. All data is synthetic.

<!-- Status badge and status page link are added when GitHub Pages is live (Sprint 4). -->

## Architecture

![CHP architecture: Salesforce, product usage and billing feed Python ingestion jobs on GitHub Actions; the warehouse models raw, staging and marts with dbt; a reverse ETL job upserts health results to the Salesforce Account, which drives alerts, tasks and the LWC card](docs/images/architecture.png)

Orchestration runs on GitHub Actions. The warehouse is DuckDB during the build, Snowflake
for the 30-day production window, then MotherDuck (free); the pipeline code and dbt project
are identical on all three. Completed follow-up tasks in Salesforce flow back into the next day's data. Details in
[docs/02-architecture.md](docs/02-architecture.md) (written in Sprint 0).

## Repository layout

| Path                    | Contents                                                                        |
| ----------------------- | ------------------------------------------------------------------------------- |
| `salesforce/`           | SFDX project: data model, Apex, Flows, LWC, reports, permission sets            |
| `pipelines/`            | Python package `chp`: generator, extract, load, reverse ETL, ops                |
| `warehouse/migrations/` | Versioned SQL for Snowflake (schemachange) and DuckDB                           |
| `warehouse/dbt/`        | dbt project: staging, intermediate, marts, ops, snapshots, tests                |
| `docs/`                 | Requirements, architecture, data dictionary, ADRs, runbooks, incidents, sprints |
| `.github/`              | Issue and PR templates, CODEOWNERS, CI/CD and scheduled workflows               |

## Getting started

Prerequisites: Git, Python 3.12, `uv`, Node LTS, Salesforce CLI (`sf`), GNU Make.

```bash
make setup     # npm install in salesforce/ (also installs git hooks), pre-commit environments
make lint      # all linters
make test      # LWC Jest, pytest, dbt build (as each component exists)
```

Copy `.env.example` to `.env` for local runs. Never commit `.env`, keys or certificates.

## How work is done

See [CLAUDE.md](CLAUDE.md) for the working rules. In short: one GitHub issue per branch
(`feat/CHP-<n>-<slug>`), Conventional Commits, a pull request using the template,
owner review, squash merge. Merges to `main` deploy to QA; `v*` tags deploy to PROD
after approval.

## License

[MIT](LICENSE)
