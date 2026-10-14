.PHONY: help

help: ## Show available verification commands
	@printf '%s\n' 'verify-dry-run  Show the local API verification plan' 'verify-test      Run harness lint and contracts' 'verify           Launch the API and exercise its HTTP endpoints'

VERIFY_SKILL := skills/verify-python-api
include $(VERIFY_SKILL)/verify.mk
