.PHONY: format validate audit ci

format: ## Format skillshare-hub.json (sort by name, 2-space indent)
	@./scripts/format.sh

validate: ## Validate skillshare-hub.json format and rules
	@./scripts/validate.sh

audit: ## Audit new/changed skills against main
	@./scripts/audit.sh main

ci: validate audit ## Run full CI locally
