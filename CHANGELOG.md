# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Each release lists Salesforce metadata changed, dbt models changed, warehouse
migrations run, and the rollback steps.

## [Unreleased]

### Added

- Repository scaffolding (Sprint 0): root `.gitignore` and `.gitattributes`, `CLAUDE.md`,
  issue and pull request templates, `CODEOWNERS`, CI and deployment workflow skeletons,
  Dependabot, pre-commit configuration, `Makefile`, `.env.example` and the monorepo
  folder layout.
- Salesforce DX project under `salesforce/` with husky and lint-staged pre-commit hooks
  run from the repository root.
