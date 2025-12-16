# homebrew-tools

[![Test Homebrew Formulae](https://github.com/cajias/homebrew-tools/actions/workflows/test.yml/badge.svg)](https://github.com/cajias/homebrew-tools/actions/workflows/test.yml)

This repository contains Homebrew formulae for my personal tools and configurations.

## Available Formulae

### shell-settings

My personal ZSH configuration with **dual plugin manager support**:

**Default: zi/zinit** (fast, feature-rich, zsh-based)
**Alternative: Sheldon** (blazing fast, Rust-based, simple)

> **Note:** This formula is packaged from the [cajias/dotfiles](https://github.com/cajias/dotfiles) repository. The name "shell-settings" is used in Homebrew to better describe the tool's purpose.

Features:
- Syntax highlighting
- Auto-suggestions
- Git integration
- SSH agent setup
- NVM for Node.js
- direnv support
- Easy switching between plugin managers
- Weekly brew auto-update script

### extract-audio

A utility to extract audio from video files, with support for various formats.

## Installation

### Quick Install (Recommended)

Run the one-line installer:

```bash
curl -fsSL https://raw.githubusercontent.com/cajias/homebrew-tools/main/install.sh | bash
```

This interactive script will:
- Check prerequisites (Homebrew)
- Tap the repository
- Let you choose which tools to install
- Optionally install modern CLI tools (zoxide, eza, bat, fzf, atuin, etc.)
- Help you configure your shell (zi or Sheldon)

### Manual Installation

```bash
# Tap the repository
brew tap cajias/homebrew-tools

# Install the shell settings (default: zi-based)
brew install cajias/homebrew-tools/shell-settings

# Optional: Install Sheldon if you want to try the alternative configuration
brew install sheldon

# Install the audio extraction utility
brew install cajias/homebrew-tools/extract-audio

# Install the video to audio converter
brew install cajias/homebrew-tools/v2a
```

### Using shell-settings

After installation, you'll have two configuration options:

**Option 1: zi/zinit (default)**
```bash
# Add to your ~/.zshrc:
source $(brew --prefix)/opt/shell-settings/init.zsh
```

**Option 2: Sheldon (alternative)**
```bash
# 1. Install Sheldon (if not already installed)
brew install sheldon

# 2. Copy the example Sheldon config
mkdir -p ~/.config/sheldon
cp $(brew --prefix)/share/shell-settings/plugins.toml ~/.config/sheldon/

# 3. Add to your ~/.zshrc:
source $(brew --prefix)/share/shell-settings/init-sheldon.zsh
```

**Switching between configurations:**
Simply edit your `~/.zshrc` and change which init file you source, then run `source ~/.zshrc` to reload.

## Troubleshooting

### Sheldon: Tests Running on Shell Initialization

If you see test output when starting a new shell (e.g., "Test: it should delete a single plugin"), this is caused by accidentally loading test files from Oh My Zsh.

**Problem:**
```toml
# DON'T DO THIS - loads the entire lib directory including tests!
[plugins.ohmyzsh-lib]
github = "ohmyzsh/ohmyzsh"
dir = "lib"
```

**Solution:**
Only load specific lib files you need:
```toml
# Load only specific lib files (excludes tests)
[plugins.ohmyzsh-completion]
github = "ohmyzsh/ohmyzsh"
use = ["lib/completion.zsh"]

[plugins.ohmyzsh-directories]
github = "ohmyzsh/ohmyzsh"
use = ["lib/directories.zsh"]

[plugins.ohmyzsh-history]
github = "ohmyzsh/ohmyzsh"
use = ["lib/history.zsh"]
```

See the example `plugins.toml` at `$(brew --prefix)/share/shell-settings/plugins.toml` for the recommended configuration.

## Development

For formula development and testing:

```bash
# Clone this repository
git clone https://github.com/cajias/homebrew-tools.git
cd homebrew-tools

# Point brew to your local tap
brew tap cajias/homebrew-tools file:///$(pwd)

# Test install locally
brew install --verbose cajias/homebrew-tools/shell-settings
```

### Testing

Run the test suite locally:

```bash
# Run all tests (same as CI)
./test.sh
```

The test suite validates:
- ✓ Ruby syntax for all formulae
- ✓ Shell script syntax (bash)
- ✓ Makefile targets
- ✓ Homebrew integration (if brew is installed)
- ✓ Documentation completeness
- ✓ File permissions
- ✓ Git configuration

**CI/CD:** Tests run automatically on every push and pull request via GitHub Actions on both Ubuntu and macOS.

### Available Make Targets

```bash
make help                    # Show available targets
make install-help            # Show installation instructions
make dev-test               # Show local testing instructions
make lint                   # Lint all formula files
make clean                  # Clean up temporary files
```

## Creating a New Release

Releases are managed via the automated GitHub Actions workflow (`.github/workflows/update-shell-settings.yml`).

### Release Process

1. **Manually trigger the workflow** from GitHub Actions tab:
   - Go to Actions → Update shell-settings formula
   - Click "Run workflow"
   - Provide the release tag (e.g., `v20250309.abc1234`)
   - Provide the version string (e.g., `20250309.abc1234`)

2. **Or trigger via `repository_dispatch`** from another repository:
   - The workflow automatically updates the formula when new releases are published

The workflow will:
1. Download the release tarball from the specified tag
2. Calculate the SHA256 hash
3. Update the formula with the new version, URL, and SHA256
4. Commit and push the changes automatically
