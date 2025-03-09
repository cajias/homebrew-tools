#!/bin/bash
set -e

# Configuration
VERSION=${1:-"1.0.0"}
GITHUB_USER="cajias"
SHELL_REPO="zi"
FORMULA_FILE="shell-settings.rb"

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) is not installed. Please install it first."
    echo "brew install gh"
    exit 1
fi

# Verify authentication with GitHub
if ! gh auth status &> /dev/null; then
    echo "You need to authenticate with GitHub first"
    echo "Run: gh auth login"
    exit 1
fi

echo "Creating and publishing release v$VERSION of shell-settings..."

# Step 1: Navigate to the shell settings repository
echo "Step 1: Checking shell settings repository..."
cd "$HOME/Projects/workspace/home" || exit 1

# Step 2: Tag the release if not already tagged
if ! git tag | grep -q "v$VERSION"; then
    echo "Creating tag v$VERSION..."
    git tag -a "v$VERSION" -m "Release version $VERSION"
    git push origin "v$VERSION"
else
    echo "Tag v$VERSION already exists."
fi

# Step 3: Create GitHub release if not exists
if ! gh release view "v$VERSION" &> /dev/null; then
    echo "Creating GitHub release v$VERSION..."
    gh release create "v$VERSION" --title "Shell Settings v$VERSION" --notes "Shell configuration with Sheldon plugin manager"
else
    echo "Release v$VERSION already exists on GitHub."
fi

# Step 4: Calculate SHA256 of the release tarball
echo "Calculating SHA256 of release tarball..."
TARBALL_URL="https://github.com/$GITHUB_USER/$SHELL_REPO/archive/refs/tags/v$VERSION.tar.gz"
SHA256=$(curl -sL "$TARBALL_URL" | shasum -a 256 | awk '{print $1}')
echo "SHA256: $SHA256"

# Step 5: Update the formula
echo "Updating formula $FORMULA_FILE..."
cd "$HOME/Projects/workspace/homebrew-tools" || exit 1

# Update version and SHA256
sed -i '' "s|version \".*\"|version \"$VERSION\"|g" "$FORMULA_FILE"
sed -i '' "s|url \".*\"|url \"https://github.com/$GITHUB_USER/$SHELL_REPO/archive/refs/tags/v$VERSION.tar.gz\"|g" "$FORMULA_FILE"
sed -i '' "s|sha256 \".*\"|sha256 \"$SHA256\"|g" "$FORMULA_FILE"

# Step 6: Commit and push changes
echo "Committing and pushing changes..."
git add "$FORMULA_FILE"
git commit -m "Update shell-settings formula to v$VERSION"
git push origin main

echo "Done! Users can now install your shell settings with:"
echo "brew tap $GITHUB_USER/homebrew-tools"
echo "brew install $GITHUB_USER/homebrew-tools/shell-settings"

# For local testing
echo ""
echo "For local testing:"
echo "brew tap $GITHUB_USER/homebrew-tools file://$HOME/Projects/workspace/homebrew-tools"
echo "brew install --verbose $GITHUB_USER/homebrew-tools/shell-settings"