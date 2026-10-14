.PHONY: help

help: ## Show available repository commands
	@printf '%s\n' 'verify-dry-run  Show the Python API verification plan' 'verify-test      Run harness lint and contracts' 'verify           Exercise the local API over HTTP'

VERIFY_SKILL := python-api-azure-functions/skills/verify-python-api
include $(VERIFY_SKILL)/verify.mk
