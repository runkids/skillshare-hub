.PHONY: build format validate audit ci

build: ## Build skillshare-hub.json from skills/*.json (used by CI)
	@./scripts/build.sh

format: ## Sort each skills/*.json by name
	@./scripts/format.sh

validate: ## Validate skills/*.json format and rules
	@./scripts/validate.sh

audit: ## Audit new/changed skills against main
	@./scripts/audit.sh main

ci: validate audit ## Run validation and audit locally
