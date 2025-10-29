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

```bash
# Tap the repository
brew tap cajias/homebrew-tools

# Install the shell settings (default: zi-based)
brew install cajias/homebrew-tools/shell-settings

# Optional: Install Sheldon if you want to try the alternative configuration
brew install sheldon

# Install the audio extraction utility
brew install cajias/homebrew-tools/extract-audio
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

## Creating a new release

To update a formula for a new release:

1. Create a tag and release in the source repository
2. Calculate the SHA256 of the new release tarball
3. Update the formula with the new version and SHA256
4. Commit and push changes to this repository

See the Makefile for detailed instructions:

```bash
make shell-settings
```
