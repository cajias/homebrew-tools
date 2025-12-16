#!/bin/bash
# Local testing script - runs the same checks as CI
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

failed_tests=0

# Test 1: Ruby syntax
print_header "Test 1: Ruby Syntax Validation"
for formula in shell-settings.rb extract-audio.rb v2a.rb; do
    if ruby -c "$formula" > /dev/null 2>&1; then
        print_success "$formula syntax valid"
    else
        print_error "$formula syntax invalid"
        ((failed_tests++))
    fi
done

# Test 2: Shell script syntax
print_header "Test 2: Shell Script Syntax"
for script in install.sh; do
    if bash -n "$script"; then
        print_success "$script syntax valid"
    else
        print_error "$script syntax invalid"
        ((failed_tests++))
    fi
done

# Test 3: Makefile
print_header "Test 3: Makefile Validation"
if make -n help > /dev/null 2>&1; then
    print_success "Makefile syntax valid"
else
    print_error "Makefile has errors"
    ((failed_tests++))
fi

# Test 4: Check if Homebrew is available
print_header "Test 4: Homebrew Integration (Optional)"
if command -v brew &> /dev/null; then
    print_info "Homebrew detected - running integration tests"

    # Check if already tapped
    if brew tap | grep -q "cajias/homebrew-tools"; then
        print_info "Repository already tapped"
    else
        print_info "Tapping local repository..."
        if brew tap cajias/homebrew-tools "$(pwd)"; then
            print_success "Successfully tapped local repository"
            TAPPED=true
        else
            print_error "Failed to tap repository"
            ((failed_tests++))
        fi
    fi

    # Run brew audit
    print_info "Running brew audit (non-fatal)..."
    brew audit --strict cajias/homebrew-tools/shell-settings 2>&1 | head -20 || true

else
    print_info "Homebrew not found - skipping integration tests"
    print_info "Install Homebrew to run full tests: https://brew.sh"
fi

# Test 5: shellcheck (if available)
print_header "Test 5: ShellCheck Analysis (Optional)"
if command -v shellcheck &> /dev/null; then
    print_info "Running shellcheck..."

    for script in install.sh; do
        if shellcheck -e SC2312 "$script" > /dev/null 2>&1; then
            print_success "$script passed shellcheck"
        else
            print_info "$script has shellcheck warnings (non-fatal)"
            shellcheck -e SC2312 "$script" || true
        fi
    done
else
    print_info "shellcheck not found - skipping (install with: brew install shellcheck)"
fi

# Test 6: Documentation
print_header "Test 6: Documentation Validation"
if [ -f README.md ] && grep -q "homebrew-tools" README.md; then
    print_success "README.md exists and contains project name"
else
    print_error "README.md missing or invalid"
    ((failed_tests++))
fi

if grep -q "shell-settings" README.md && grep -q "extract-audio" README.md; then
    print_success "All formulae documented in README"
else
    print_error "Missing formula documentation"
    ((failed_tests++))
fi

# Test 7: File permissions
print_header "Test 7: File Permissions"
for script in install.sh; do
    if [ -x "$script" ]; then
        print_success "$script is executable"
    else
        print_error "$script is not executable"
        ((failed_tests++))
    fi
done

# Test 8: Git configuration
print_header "Test 8: Git Configuration"
if [ -f .gitignore ]; then
    print_success ".gitignore exists"
else
    print_error ".gitignore missing"
    ((failed_tests++))
fi

if [ -d .github/workflows ]; then
    print_success "GitHub Actions workflows configured"
else
    print_error "No GitHub Actions workflows found"
    ((failed_tests++))
fi

# Summary
print_header "Test Summary"
if [ $failed_tests -eq 0 ]; then
    print_success "All tests passed! ✨"
    exit 0
else
    print_error "$failed_tests test(s) failed"
    exit 1
fi
