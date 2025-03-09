# homebrew-tools

This repository contains Homebrew formulae for my personal tools and configurations.

## Available Formulae

### shell-settings

My personal ZSH configuration using Sheldon plugin manager, with:
- Syntax highlighting
- Auto-suggestions
- Git integration
- SSH agent setup
- NVM for Node.js
- direnv support
- And more!

### extract-audio

A utility to extract audio from video files, with support for various formats.

## Installation

```bash
# Tap the repository
brew tap cajias/homebrew-tools

# Install the shell settings
brew install cajias/homebrew-tools/shell-settings

# Install the audio extraction utility
brew install cajias/homebrew-tools/extract-audio
```

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
