.PHONY: build format validate audit audit-all readme update sync ci

build: ## Build skillshare-hub.json from skills/*.json (used by CI)
	@./scripts/build.sh

format: ## Sort each skills/*.json by name
	@./scripts/format.sh

validate: ## Validate skills/*.json format and rules
	@./scripts/validate.sh

audit: ## Audit new/changed skills against main
	@./scripts/audit.sh main

audit-all: build ## Audit ALL skills, enrich hub JSON
	@./scripts/audit-all.sh

readme: ## Generate README catalog
	@./scripts/readme.sh

sync: build ## Sync new skills from skills.sh top 200
	@./scripts/sync-skills-sh.sh

update: build audit-all readme ## Full update flow

ci: validate audit ## Run validation and audit locally
