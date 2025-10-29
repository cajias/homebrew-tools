# Variables
SHELL_SETTINGS_VERSION ?= 1.0.0
SHELL_SETTINGS_FORMULA = shell-settings.rb
EXTRACT_AUDIO_FORMULA = extract-audio.rb
V2A_FORMULA = v2a.rb

TAP_NAME = homebrew-tools
GITHUB_USER ?= cajias
GITHUB_SHELL_REPO = zi
MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: all help release-shell-settings install-help dev-test lint clean

all: help

# Show available targets
help:
	@echo "Available targets:"
	@echo "  help                 - Show this help message"
	@echo "  release-shell-settings - Release a new version of shell-settings"
	@echo "  install-help         - Show instructions for installing formulae"
	@echo "  dev-test             - Show instructions for local testing"
	@echo "  lint                 - Lint all formula files"
	@echo "  clean                - Clean up temporary files"
	@echo ""
	@echo "Variables:"
	@echo "  SHELL_SETTINGS_VERSION - Version to release (default: $(SHELL_SETTINGS_VERSION))"
	@echo "  GITHUB_USER            - GitHub username (default: $(GITHUB_USER))"

# Release a new version of shell-settings using the automated script
release-shell-settings:
	@echo "Releasing shell-settings v$(SHELL_SETTINGS_VERSION)..."
	@./release-shell-settings.sh $(SHELL_SETTINGS_VERSION)

# Instructions for installing formulae
install-help:
	@echo "To install these formulae:"
	@echo ""
	@echo "From GitHub (after publishing):"
	@echo "  brew tap $(GITHUB_USER)/$(TAP_NAME)"
	@echo "  brew install $(GITHUB_USER)/$(TAP_NAME)/shell-settings"
	@echo "  brew install $(GITHUB_USER)/$(TAP_NAME)/extract-audio"
	@echo "  brew install $(GITHUB_USER)/$(TAP_NAME)/v2a"
	@echo ""
	@echo "Local installation (for testing):"
	@echo "  brew tap $(GITHUB_USER)/$(TAP_NAME) file://$(MAKEFILE_DIR)"
	@echo "  brew install --verbose $(GITHUB_USER)/$(TAP_NAME)/shell-settings"

# For development testing
dev-test:
	@echo "For testing formulae locally without a release:"
	@echo ""
	@echo "1. Tap the local repository:"
	@echo "   brew tap $(GITHUB_USER)/$(TAP_NAME) file://$(MAKEFILE_DIR)"
	@echo ""
	@echo "2. For testing with a local source (no GitHub release needed):"
	@echo "   Edit the formula to point to a local file:"
	@echo "     url \"file:///path/to/local/source\""
	@echo "     sha256 :no_check"
	@echo ""
	@echo "3. Install with verbose output:"
	@echo "   brew install --verbose $(GITHUB_USER)/$(TAP_NAME)/shell-settings"
	@echo ""
	@echo "4. To reinstall after changes:"
	@echo "   brew reinstall --verbose $(GITHUB_USER)/$(TAP_NAME)/shell-settings"

# Lint formula files
lint:
	@echo "Linting formula files..."
	@for formula in $(SHELL_SETTINGS_FORMULA) $(EXTRACT_AUDIO_FORMULA) $(V2A_FORMULA); do \
		echo "Checking $$formula..."; \
		brew audit --strict --online $$formula || true; \
	done

clean:
	@echo "Cleaning up temporary files..."
	@find . -name "*.bak" -delete
	@find . -name "*~" -delete
	@echo "Clean complete."