#!/bin/bash

# =============================================================================
# DOTFILES CLEANUP SCRIPT
# =============================================================================
# Removes unwanted files and directories from the dotfiles repository
# Usage: ./cleanup.sh [--dry-run] [--force]
# =============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DRY_RUN=false
FORCE=false

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ $1${NC}"; }

# Only target specific unwanted patterns that are safe to remove
CLEANUP_ITEMS=(
    # Zed editor temporary files
    ".config/zed/prompts/"
    ".config/zed/*.mdb"
    ".config/zed/extensions/"
    
    # GitHub Copilot (sensitive data)
    ".config/github-copilot/"
    
    # Raycast extensions (too large and auto-managed)
    ".config/raycast/extensions/"
    
    # Neovim lock files
    ".config/nvim/lazy-lock.json"
    
    # System files
    ".DS_Store"
    "**/.DS_Store"
    "*.log"
    
    # Git repositories in subdirectories (but preserve main .git)
    ".oh-my-zsh/.git"
    ".tmux/plugins/*/.git"
    
    # Documentation and development files in oh-my-zsh
    ".oh-my-zsh/.github/"
    ".oh-my-zsh/.devcontainer/"
    ".oh-my-zsh/README.md"
    ".oh-my-zsh/LICENSE.txt"
    ".oh-my-zsh/CONTRIBUTING.md"
    ".oh-my-zsh/CODE_OF_CONDUCT.md"
    ".oh-my-zsh/SECURITY.md"
    
    # Documentation in plugins (but preserve plugin files)
    ".oh-my-zsh/custom/plugins/*/.github/"
    ".oh-my-zsh/custom/plugins/*/.circleci/"
    ".oh-my-zsh/custom/plugins/*/README.md"
    ".oh-my-zsh/custom/plugins/*/LICENSE"
    ".oh-my-zsh/custom/plugins/*/CHANGELOG.md"
    ".oh-my-zsh/custom/plugins/*/docs/"
    ".oh-my-zsh/custom/plugins/*/tests/"
    ".oh-my-zsh/custom/plugins/*/spec/"
    ".oh-my-zsh/custom/plugins/*/images/"
    
    # Documentation in tmux plugins
    ".tmux/plugins/*/.github/"
    ".tmux/plugins/*/README.md"
    ".tmux/plugins/*/LICENSE"
)

# Git clean patterns (more conservative)
GIT_CLEAN_PATTERNS=(
    ".config/raycast/extensions/"
    ".config/zed/prompts/"
    ".config/github-copilot/"
    "*.log"
    ".DS_Store"
    "**/.DS_Store"
)

cleanup_files() {
    print_info "Cleaning up unwanted files and directories..."
    
    for pattern in "${CLEANUP_ITEMS[@]}"; do
        if [[ "$DRY_RUN" == true ]]; then
            # Check if pattern matches any files
            if compgen -G "$pattern" > /dev/null 2>&1; then
                print_warning "[DRY RUN] Would remove: $pattern"
                ls -la $pattern 2>/dev/null | head -3
            fi
        else
            # Only remove if pattern actually matches files
            if compgen -G "$pattern" > /dev/null 2>&1; then
                print_info "Removing: $pattern"
                rm -rf $pattern 2>/dev/null || print_warning "Could not remove: $pattern"
            fi
        fi
    done
}

git_cleanup() {
    print_info "Performing git cleanup..."
    
    if [[ "$DRY_RUN" == true ]]; then
        print_warning "[DRY RUN] Would run git clean commands"
        print_info "Untracked files that would be cleaned:"
        git status --porcelain | grep "^??" | head -10
        return
    fi
    
    # Remove untracked files that match our patterns
    for pattern in "${GIT_CLEAN_PATTERNS[@]}"; do
        print_info "Cleaning git pattern: $pattern"
        # Use git clean with explicit paths and be more careful
        if [[ -e "$pattern" ]]; then
            git clean -fd "$pattern" 2>/dev/null || true
        fi
    done
    
    # Reset any staged files we don't want (be specific)
    print_info "Unstaging unwanted files..."
    git reset HEAD -- .config/zed/prompts/ 2>/dev/null || true
    git reset HEAD -- .config/raycast/extensions/ 2>/dev/null || true
    git reset HEAD -- .config/github-copilot/ 2>/dev/null || true
    git reset HEAD -- .config/zed/*.mdb 2>/dev/null || true
}

update_gitignore_exclusions() {
    print_info "Checking .gitignore exclusions..."
    
    # Check if .gitignore has the essential exclusions
    local important_exclusions=(
        ".config/raycast/extensions/"
        ".config/zed/prompts/"
        ".config/github-copilot/"
        ".config/nvim/lazy-lock.json"
        "**/.DS_Store"
        ".oh-my-zsh/"
        ".tmux/plugins/*/"
    )
    
    for exclusion in "${important_exclusions[@]}"; do
        if ! grep -q "$exclusion" .gitignore 2>/dev/null; then
            print_warning "Consider adding '$exclusion' to .gitignore"
        fi
    done
}

check_essential_files() {
    print_info "Checking essential dotfiles are preserved..."
    
    local essential_files=(
        ".zshrc"
        ".gitconfig"
        ".tmux.conf"
        "install.sh"
        "Brewfile"
        ".gitignore"
    )
    
    for file in "${essential_files[@]}"; do
        if [[ ! -e "$file" ]]; then
            print_error "Essential file missing: $file"
        else
            print_success "Essential file present: $file"
        fi
    done
}

show_status() {
    print_info "Current repository status:"
    echo ""
    print_info "Untracked files:"
    git status --porcelain | grep "^??" | head -10 || echo "  (none)"
    echo ""
    print_info "Modified files:"
    git status --porcelain | grep "^.M" | head -10 || echo "  (none)"
    echo ""
    print_info "Staged files:"
    git status --porcelain | grep "^M" | head -10 || echo "  (none)"
}

show_help() {
    echo "Dotfiles Cleanup Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --dry-run    Show what would be removed without actually removing"
    echo "  --force      Skip confirmation prompts"
    echo "  --help       Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 --dry-run    # Preview what would be cleaned"
    echo "  $0 --force      # Clean without prompts"
    echo ""
    echo "This script safely removes:"
    echo "  - Zed editor temporary files"
    echo "  - GitHub Copilot cache"
    echo "  - Raycast extensions"
    echo "  - System files (.DS_Store, logs)"
    echo "  - Documentation in oh-my-zsh plugins"
    echo ""
    echo "Essential dotfiles are always preserved."
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Main execution
print_info "Dotfiles Repository Cleanup"
echo "─────────────────────────────────────────"

# Safety check
check_essential_files

if [[ "$FORCE" != true && "$DRY_RUN" != true ]]; then
    echo ""
    print_warning "This will remove unwanted files from your dotfiles repo."
    print_info "Essential dotfiles will be preserved."
    echo -n "Continue? [y/N]: "
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_info "Cleanup cancelled"
        exit 0
    fi
fi

cleanup_files
git_cleanup
update_gitignore_exclusions
show_status

if [[ "$DRY_RUN" == true ]]; then
    print_warning "This was a dry run. Use without --dry-run to actually clean up."
else
    print_success "Cleanup completed!"
    print_info "Your essential dotfiles have been preserved."
    print_info "You may want to review the changes and commit if needed."
fi 