.PHONY: validate audit ci

validate: ## Validate skillshare-hub.json format and rules
	@./scripts/validate.sh

audit: ## Audit new/changed skills against main
	@./scripts/audit.sh main

ci: validate audit ## Run full CI locally
