#!/bin/bash
set -euo pipefail

# ============================================================================
# DEPRECATION NOTICE
# ============================================================================
# This script is DEPRECATED and will be removed in a future version.
#
# Please use the automated GitHub Actions workflow instead:
#   .github/workflows/update-shell-settings.yml
#
# The workflow provides automated, CI/CD-managed releases that are triggered
# via repository_dispatch or workflow_dispatch events, eliminating the need
# for manual script execution.
#
# For more information, see the README.md file.
# ============================================================================

# Configuration
VERSION=${1:-"1.0.0"}
GITHUB_USER="${GITHUB_USER:-cajias}"
SHELL_REPO="zi"
FORMULA_FILE="shell-settings.rb"

# Detect script directory for relative paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed. Please install it first."
    echo "  brew install gh"
    exit 1
fi

# Verify authentication with GitHub
if ! gh auth status &> /dev/null; then
    echo "Error: You need to authenticate with GitHub first"
    echo "  Run: gh auth login"
    exit 1
fi

echo "=========================================="
echo "WARNING: This script is DEPRECATED!"
echo "=========================================="
echo "Please use the GitHub Actions workflow: .github/workflows/update-shell-settings.yml"
echo "This script will be removed in a future version."
echo "=========================================="
echo ""
echo "Creating and publishing release v$VERSION of shell-settings..."

# Step 1: Determine shell settings repository location
echo "Step 1: Locating shell settings repository..."
SHELL_REPO_PATH="${SHELL_REPO_PATH:-}"
if [ -z "$SHELL_REPO_PATH" ]; then
    # Try common locations
    for path in "$HOME/$SHELL_REPO" "$HOME/Projects/$SHELL_REPO" "$HOME/Projects/workspace/home"; do
        if [ -d "$path/.git" ]; then
            SHELL_REPO_PATH="$path"
            break
        fi
    done
fi

if [ -z "$SHELL_REPO_PATH" ] || [ ! -d "$SHELL_REPO_PATH" ]; then
    echo "Error: Could not find shell settings repository."
    echo "  Please set SHELL_REPO_PATH environment variable or specify the path."
    exit 1
fi

echo "Using repository: $SHELL_REPO_PATH"
cd "$SHELL_REPO_PATH" || exit 1

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
SHA256=$(curl -fsSL "$TARBALL_URL" | shasum -a 256 | awk '{print $1}')

if [ -z "$SHA256" ] || [ ${#SHA256} -ne 64 ]; then
    echo "Error: Failed to calculate SHA256 or invalid hash length"
    exit 1
fi

echo "SHA256: $SHA256"

# Step 5: Update the formula
echo "Updating formula $FORMULA_FILE..."
cd "$SCRIPT_DIR" || exit 1

# Cross-platform sed (works on both macOS and Linux)
if [[ "$OSTYPE" == "darwin"* ]]; then
    SED_INPLACE=(-i '')
else
    SED_INPLACE=(-i)
fi

# Update version and SHA256
sed "${SED_INPLACE[@]}" "s|version \".*\"|version \"$VERSION\"|g" "$FORMULA_FILE"
sed "${SED_INPLACE[@]}" "s|url \".*\"|url \"https://github.com/$GITHUB_USER/$SHELL_REPO/archive/refs/tags/v$VERSION.tar.gz\"|g" "$FORMULA_FILE"
sed "${SED_INPLACE[@]}" "s|sha256 \".*\"|sha256 \"$SHA256\"|g" "$FORMULA_FILE"

# Step 6: Commit and push changes
echo "Committing and pushing changes..."
git add "$FORMULA_FILE"
git commit -m "Update shell-settings formula to v$VERSION"

# Detect default branch (main or master)
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")
git push origin "$DEFAULT_BRANCH"

echo ""
echo "✓ Done! Users can now install your shell settings with:"
echo "  brew tap $GITHUB_USER/homebrew-tools"
echo "  brew install $GITHUB_USER/homebrew-tools/shell-settings"

# For local testing
echo ""
echo "For local testing:"
echo "  brew tap $GITHUB_USER/homebrew-tools file://$SCRIPT_DIR"
echo "  brew install --verbose $GITHUB_USER/homebrew-tools/shell-settings"