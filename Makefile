# Customer Health Platform task runner (spec section 6).
#   make setup | lint | test | sf-test | run-day DATE=YYYY-MM-DD | backfill FROM=YYYY-MM-DD TO=YYYY-MM-DD
# Targets for components that do not exist yet print a notice and succeed.

SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

PIPELINES := pipelines
SF_DIR    := salesforce
DBT_DIR   := warehouse/dbt
# Local Apex tests run against QA or a scratch org, never PROD (CLAUDE.md).
SF_ORG    ?= chp-qa

HAS_PY  := $(wildcard $(PIPELINES)/pyproject.toml)
HAS_DBT := $(wildcard $(DBT_DIR)/dbt_project.yml)

.PHONY: help setup lint test sf-test run-day backfill

help:
	@echo "make setup                          install Node deps, git hooks and hook environments"
	@echo "make lint                           pre-commit on all files, Salesforce prettier and eslint"
	@echo "make test                           LWC Jest, pytest, dbt build (as each exists)"
	@echo "make sf-test [SF_ORG=chp-qa]        Apex tests in a non-PROD org"
	@echo "make run-day DATE=YYYY-MM-DD        run the daily chain for one business date"
	@echo "make backfill FROM=... TO=...       re-run a date range idempotently"

setup:
	cd $(SF_DIR) && npm install
	uvx pre-commit install-hooks
ifneq ($(HAS_PY),)
	cd $(PIPELINES) && uv sync
endif

lint:
	uvx pre-commit run --all-files
	cd $(SF_DIR) && npm run prettier:verify
	@if find $(SF_DIR)/force-app -path '*/lwc/*.js' -o -path '*/aura/*.js' | grep -q .; then \
		cd $(SF_DIR) && npm run lint; \
	else echo "No LWC/Aura JavaScript yet; eslint skipped."; fi
ifneq ($(HAS_PY),)
	cd $(PIPELINES) && uv run ruff check . && uv run ruff format --check . && uv run mypy --strict src/
endif

test:
	cd $(SF_DIR) && npx sfdx-lwc-jest -- --passWithNoTests
ifneq ($(HAS_PY),)
	cd $(PIPELINES) && uv run pytest --cov=chp --cov-fail-under=80
else
	@echo "chp package not found; pytest skipped."
endif
ifneq ($(HAS_DBT),)
	cd $(DBT_DIR) && uv run --project ../../$(PIPELINES) dbt build --target dev
else
	@echo "dbt project not found; dbt build skipped."
endif

sf-test:
	@if [ "$(SF_ORG)" = "chp-prod" ]; then echo "Refusing to run against PROD locally (CLAUDE.md)."; exit 1; fi
	cd $(SF_DIR) && sf apex run test --target-org $(SF_ORG) --test-level RunLocalTests \
		--code-coverage --result-format human --wait 30

run-day:
	@if [ -z "$(DATE)" ]; then echo "Usage: make run-day DATE=YYYY-MM-DD"; exit 1; fi
ifneq ($(HAS_PY),)
	cd $(PIPELINES) && uv run chp run-day --date $(DATE)
else
	@echo "chp package not built yet."
endif

backfill:
	@if [ -z "$(FROM)" ] || [ -z "$(TO)" ]; then echo "Usage: make backfill FROM=YYYY-MM-DD TO=YYYY-MM-DD"; exit 1; fi
ifneq ($(HAS_PY),)
	cd $(PIPELINES) && uv run chp backfill --from $(FROM) --to $(TO)
else
	@echo "chp package not built yet."
endif
