#!/bin/bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
GITHUB_USER="cajias"
TAP_NAME="homebrew-tools"
TAP_REPO="$GITHUB_USER/$TAP_NAME"

# Helper functions
print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

ask_yes_no() {
    local prompt="$1"
    local default="${2:-n}"

    if [[ "$default" == "y" ]]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi

    read -p "$prompt" -r response
    response=${response:-$default}

    [[ "$response" =~ ^[Yy]$ ]]
}

# Check if Homebrew is installed
check_homebrew() {
    print_header "Checking Prerequisites"

    if ! command -v brew &> /dev/null; then
        print_error "Homebrew is not installed!"
        echo ""
        echo "Install Homebrew first:"
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi

    print_success "Homebrew is installed ($(brew --version | head -1))"
}

# Tap the repository
tap_repository() {
    print_header "Tapping $TAP_REPO"

    if brew tap | grep -q "^$TAP_REPO\$"; then
        print_info "Already tapped: $TAP_REPO"
    else
        print_info "Tapping repository..."
        if brew tap "$TAP_REPO"; then
            print_success "Successfully tapped $TAP_REPO"
        else
            print_error "Failed to tap repository"
            exit 1
        fi
    fi
}

# Install a formula
install_formula() {
    local formula="$1"
    local description="$2"

    echo ""
    if ask_yes_no "Install $formula? ($description)" "y"; then
        print_info "Installing $formula..."
        if brew install "$TAP_REPO/$formula"; then
            print_success "Successfully installed $formula"
            return 0
        else
            print_error "Failed to install $formula"
            return 1
        fi
    else
        print_info "Skipped $formula"
        return 1
    fi
}

# Install optional modern CLI tools
install_modern_tools() {
    print_header "Modern CLI Tools (Optional)"

    echo "These tools greatly enhance your shell experience:"
    echo ""
    echo "  • zoxide   - Smart cd that learns your patterns"
    echo "  • eza      - Modern ls with icons and colors"
    echo "  • bat      - Better cat with syntax highlighting"
    echo "  • fzf      - Fuzzy finder for files and history"
    echo "  • atuin    - Revolutionary shell history with sync"
    echo "  • direnv   - Auto-load environment variables"
    echo "  • ripgrep  - Faster grep alternative"
    echo "  • fd       - Faster find alternative"
    echo ""

    if ask_yes_no "Install recommended modern CLI tools?" "y"; then
        local tools=(zoxide eza bat fzf atuin direnv ripgrep fd)

        for tool in "${tools[@]}"; do
            if command -v "$tool" &> /dev/null; then
                print_success "$tool is already installed"
            else
                print_info "Installing $tool..."
                if brew install "$tool" 2>/dev/null; then
                    print_success "Installed $tool"
                else
                    print_warning "Could not install $tool (may require manual installation)"
                fi
            fi
        done
    else
        print_info "Skipped modern CLI tools"
    fi
}

# Setup shell configuration
setup_shell_config() {
    print_header "Shell Configuration Setup"

    local shell_settings_installed=false
    brew list "$TAP_REPO/dotfiles" &>/dev/null && shell_settings_installed=true

    if ! $shell_settings_installed; then
        print_warning "dotfiles not installed, skipping configuration"
        return
    fi

    echo "Choose your zsh plugin manager:"
    echo ""
    echo "  1) zi/zinit (default) - Feature-rich, powerful"
    echo "  2) Sheldon - Fast, Rust-based, simple"
    echo "  3) Skip configuration"
    echo ""

    read -p "Enter choice [1-3]: " -r choice

    case $choice in
        1)
            setup_zi_config
            ;;
        2)
            setup_sheldon_config
            ;;
        *)
            print_info "Skipped shell configuration"
            ;;
    esac
}

# Setup zi configuration
setup_zi_config() {
    local init_file="$(brew --prefix)/opt/dotfiles/init.zsh"
    local zshrc="$HOME/.zshrc"

    echo ""
    print_info "zi/zinit configuration:"
    echo ""
    echo "Add this to your ~/.zshrc:"
    echo "  source $init_file"
    echo ""

    if [ -f "$zshrc" ]; then
        if ask_yes_no "Automatically add to ~/.zshrc?" "y"; then
            if grep -q "source.*dotfiles" "$zshrc"; then
                print_info "Already configured in ~/.zshrc"
            else
                echo "" >> "$zshrc"
                echo "# Shell settings from $TAP_REPO" >> "$zshrc"
                echo "source $init_file" >> "$zshrc"
                print_success "Added to ~/.zshrc"
                print_info "Run 'source ~/.zshrc' to apply changes"
            fi
        fi
    else
        echo "source $init_file" > "$zshrc"
        print_success "Created ~/.zshrc with dotfiles"
    fi
}

# Setup Sheldon configuration
setup_sheldon_config() {
    echo ""

    # Check if Sheldon is installed
    if ! command -v sheldon &> /dev/null; then
        if ask_yes_no "Sheldon not found. Install it?" "y"; then
            brew install sheldon
        else
            print_error "Sheldon required for this configuration"
            return
        fi
    fi

    print_success "Sheldon is installed"

    # Copy plugins.toml
    local sheldon_dir="$HOME/.config/sheldon"
    local plugins_toml="$sheldon_dir/plugins.toml"
    local example_config="$(brew --prefix)/share/dotfiles/plugins.toml"

    mkdir -p "$sheldon_dir"

    if [ -f "$plugins_toml" ]; then
        if ask_yes_no "Sheldon config exists. Overwrite with optimized version?" "n"; then
            cp "$example_config" "$plugins_toml"
            print_success "Updated $plugins_toml"
        else
            print_info "Kept existing Sheldon configuration"
        fi
    else
        cp "$example_config" "$plugins_toml"
        print_success "Created $plugins_toml"
    fi

    # Update .zshrc
    local init_file="$(brew --prefix)/share/dotfiles/init-sheldon.zsh"
    local zshrc="$HOME/.zshrc"

    echo ""
    if [ -f "$zshrc" ]; then
        if ask_yes_no "Add Sheldon configuration to ~/.zshrc?" "y"; then
            if grep -q "source.*dotfiles" "$zshrc"; then
                print_info "Shell settings already in ~/.zshrc (you may need to update the path)"
            else
                echo "" >> "$zshrc"
                echo "# Shell settings from $TAP_REPO (Sheldon)" >> "$zshrc"
                echo "source $init_file" >> "$zshrc"
                print_success "Added to ~/.zshrc"
                print_info "Run 'source ~/.zshrc' to apply changes"
            fi
        fi
    else
        echo "source $init_file" > "$zshrc"
        print_success "Created ~/.zshrc with Sheldon configuration"
    fi
}

# Main installation flow
main() {
    clear
    print_header "🍺 $TAP_REPO Installer"

    echo "This script will help you install and configure:"
    echo "  • dotfiles - ZSH configuration with dual plugin manager support"
    echo "  • extract-audio  - Audio extraction utility"
    echo "  • v2a            - Video to audio converter"
    echo "  • Modern CLI tools (optional)"
    echo ""

    if ! ask_yes_no "Continue with installation?" "y"; then
        echo "Installation cancelled."
        exit 0
    fi

    # Check prerequisites
    check_homebrew

    # Tap repository
    tap_repository

    # Install formulae
    print_header "Installing Formulae"

    install_formula "dotfiles" "ZSH configuration with plugin managers"
    shell_settings_installed=$?

    install_formula "extract-audio" "Extract audio from video files"
    install_formula "v2a" "Video to audio converter"

    # Install modern tools
    install_modern_tools

    # Setup shell if dotfiles was installed
    if [ $shell_settings_installed -eq 0 ]; then
        setup_shell_config
    fi

    # Final summary
    print_header "🎉 Installation Complete!"

    echo "Next steps:"
    echo ""

    if [ $shell_settings_installed -eq 0 ]; then
        echo "  1. Restart your terminal or run: source ~/.zshrc"
        echo "  2. Enjoy your enhanced shell experience!"
        echo ""
        echo "For more information:"
        echo "  • View installed files: brew list $TAP_REPO/dotfiles"
        echo "  • See configuration: brew info $TAP_REPO/dotfiles"
    else
        echo "  • Install dotfiles: brew install $TAP_REPO/dotfiles"
    fi

    echo ""
    echo "Documentation: https://github.com/$GITHUB_USER/$TAP_NAME"
    echo ""
}

# Run main installation
main
