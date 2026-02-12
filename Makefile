.PHONY: build format validate audit ci

build: ## Build skillshare-hub.json from skills/*.json
	@./scripts/build.sh

format: build ## Alias for build (build already sorts and formats)

validate: ## Validate skillshare-hub.json format and rules
	@./scripts/validate.sh

audit: ## Audit new/changed skills against main
	@./scripts/audit.sh main

ci: build validate audit ## Run full CI locally
