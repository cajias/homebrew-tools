# Variables
SCRIPT_NAME = convert_to_mp3.py
REPO_NAME = homebrew-scripts
VERSION = 1.0.0
TAR_FILE = v$(VERSION).tar.gz
HOMEBREW_FORMULA = convert-to-mp3.rb
HOMEBREW_TAP = yourusername/$(REPO_NAME)
GITHUB_USER = yourusername
GITHUB_REPO = $(REPO_NAME)

.PHONY: all release clean

all: release

# Create a tarball of the script
$(TAR_FILE): $(SCRIPT_NAME)
	tar -czvf $(TAR_FILE) $(SCRIPT_NAME)

# Create a GitHub release and upload the tarball
release: $(TAR_FILE)
	# Create GitHub release
	gh release create v$(VERSION) $(TAR_FILE) --title "v$(VERSION)" --notes "Release version $(VERSION)"
	# Get the SHA-256 checksum of the tarball
	SHA256=$$(shasum -a 256 $(TAR_FILE) | awk '{ print $$1 }')
	# Update Homebrew formula
	sed -i '' "s|url \".*\"|url \"https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)/archive/refs/tags/v$(VERSION).tar.gz\"|" $(HOMEBREW_FORMULA)
	sed -i '' "s|sha256 \".*\"|sha256 \"$$SHA256\"|" $(HOMEBREW_FORMULA)
	# Commit and push the updated formula
	git add $(HOMEBREW_FORMULA)
	git commit -m "Update Homebrew formula for v$(VERSION)"
	git push origin main
	# Publish the updated formula to Homebrew tap
	brew tap $(HOMEBREW_TAP)
	brew install $(HOMEBREW_TAP)/convert-to-mp3

clean:
	rm -f $(TAR_FILE)