# homebrew-tools

This repository contains Homebrew formulae for my personal tools and configurations.

## Available Formulae

### shell-settings

My personal ZSH configuration with **dual plugin manager support**:

**Default: zi/zinit** (fast, feature-rich, zsh-based)
**Alternative: Sheldon** (blazing fast, Rust-based, simple)

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

### Available Make Targets

```bash
make help                    # Show available targets
make release-shell-settings  # Release a new version of shell-settings
make install-help            # Show installation instructions
make dev-test               # Show local testing instructions
make lint                   # Lint all formula files
make clean                  # Clean up temporary files
```

## Creating a New Release

The repository includes an automated release script:

```bash
# Release a new version (e.g., 2.0.0)
./release-shell-settings.sh 2.0.0

# Or use Make:
make release-shell-settings SHELL_SETTINGS_VERSION=2.0.0
```

This script will:
1. Create and push a git tag in the source repository
2. Create a GitHub release
3. Calculate the SHA256 of the release tarball
4. Update the formula with the new version and SHA256
5. Commit and push the changes
