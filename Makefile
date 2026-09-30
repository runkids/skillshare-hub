.PHONY: build format validate test audit audit-all readme update sync ci

build: ## Build skillshare-hub.json from skills/*.json (used by CI)
	@./scripts/build.sh

format: ## Sort each skills/*.json by name
	@./scripts/format.sh

validate: ## Validate skills/*.json format and rules
	@./scripts/validate.sh

test: ## Self-check the audit scripts' source parsing
	@./scripts/test-scripts.sh

audit: ## Audit new/changed skills against main
	@./scripts/audit.sh main

audit-all: build ## Audit ALL skills, enrich hub JSON
	@./scripts/audit-all.sh

readme: ## Generate README catalog
	@./scripts/readme.sh

sync: build ## Sync community skills (add top 200 + trending, prune stale)
	@./scripts/sync-community.sh

update: build audit-all readme ## Full update flow

ci: validate test audit ## Run validation, script checks and audit locally
