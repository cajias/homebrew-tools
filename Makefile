# Variables
SHELL_SETTINGS_VERSION = 1.0.0
SHELL_SETTINGS_FORMULA = shell-settings.rb
EXTRACT_AUDIO_FORMULA = extract-audio.rb

TAP_NAME = homebrew-tools
GITHUB_USER = cajias
GITHUB_SHELL_REPO = zi

.PHONY: all shell-settings extract-audio clean

all: shell-settings extract-audio

# Update the shell-settings formula with the latest release
shell-settings:
	@echo "Updating shell-settings formula..."
	@echo "You must first create a release of your shell settings repository:"
	@echo "1. In your shell settings repo ($(GITHUB_USER)/$(GITHUB_SHELL_REPO)):"
	@echo "   git tag -a v$(SHELL_SETTINGS_VERSION) -m \"Release version $(SHELL_SETTINGS_VERSION)\""
	@echo "   git push origin v$(SHELL_SETTINGS_VERSION)"
	@echo "2. Create a release on GitHub for tag v$(SHELL_SETTINGS_VERSION)"
	@echo "3. Download the tarball and calculate the SHA256:"
	@echo "   curl -sL https://github.com/$(GITHUB_USER)/$(GITHUB_SHELL_REPO)/archive/refs/tags/v$(SHELL_SETTINGS_VERSION).tar.gz | shasum -a 256"
	@echo "4. Update the formula with the SHA256:"
	@echo "   sed -i '' \"s|sha256 \\\"PLACEHOLDER_SHA256\\\"|sha256 \\\"YOUR_SHA256_HERE\\\"|\" $(SHELL_SETTINGS_FORMULA)"
	@echo "5. Commit and push the updated formula:"
	@echo "   git add $(SHELL_SETTINGS_FORMULA)"
	@echo "   git commit -m \"Update shell-settings formula to v$(SHELL_SETTINGS_VERSION)\""
	@echo "   git push origin main"
	@echo ""
	@echo "Once published, users can install it with:"
	@echo "brew tap $(GITHUB_USER)/$(TAP_NAME)"
	@echo "brew install $(GITHUB_USER)/$(TAP_NAME)/shell-settings"

# Helper to create new release for extract-audio
extract-audio:
	@echo "For extract-audio, follow similar steps to release a new version"
	@echo "1. Update the version and URL in $(EXTRACT_AUDIO_FORMULA)"
	@echo "2. Calculate the SHA256 of the new release"
	@echo "3. Update the formula and push changes"

# Instructions for installing formulae
install-help:
	@echo "To install these formulae locally:"
	@echo "brew tap $(GITHUB_USER)/$(TAP_NAME) file:///Users/rc/Projects/workspace/$(TAP_NAME)"
	@echo "brew install $(GITHUB_USER)/$(TAP_NAME)/shell-settings"
	@echo "brew install $(GITHUB_USER)/$(TAP_NAME)/extract-audio"

# For development testing
dev-test:
	@echo "For testing the formula locally without a release:"
	@echo "1. brew tap $(GITHUB_USER)/$(TAP_NAME) file:///Users/rc/Projects/workspace/$(TAP_NAME)"
	@echo "2. Edit the formula to point to a local file:"
	@echo "   url \"file:///Users/rc/Projects/workspace/zi\""
	@echo "   sha256 :no_check"
	@echo "3. Run: brew install --verbose $(GITHUB_USER)/$(TAP_NAME)/shell-settings"

clean:
	@echo "Cleaning up..."