.PHONY: help sync

MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

help:
	@echo "Available commands:"
	@echo "  make setup            		- Initial setup (install dependencies)"

sync:
	@echo "Committing all changes and pushing to remote repository..."
	@git add . && git commit -am "Chore(sync): Committing all changes" && git push

restage:
	@echo "🧹 Performing full cleanup and fresh start..."
	@$(MAKEFILE_DIR)scripts/clean-restart.sh