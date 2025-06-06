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

# Directories and files to remove
CLEANUP_ITEMS=(
    ".config/raycast/extensions/"
    ".config/zed/prompts/"
    ".config/zed/*.mdb"
    ".config/github-copilot/"
    ".oh-my-zsh/.github/"
    ".oh-my-zsh/.devcontainer/"
    ".oh-my-zsh/README.md"
    ".oh-my-zsh/LICENSE.txt"
    ".oh-my-zsh/CONTRIBUTING.md"
    ".oh-my-zsh/CODE_OF_CONDUCT.md"
    ".oh-my-zsh/SECURITY.md"
    ".oh-my-zsh/lib/"
    ".oh-my-zsh/plugins/"
    ".oh-my-zsh/themes/"
    ".oh-my-zsh/tools/"
    ".oh-my-zsh/custom/plugins/*/.*"
    ".oh-my-zsh/custom/plugins/*/.github/"
    ".oh-my-zsh/custom/plugins/*/.circleci/"
    ".tmux/plugins/*/.*"
    ".tmux/plugins/*/.github/"
    ".config/nvim/lazy-lock.json"
)

# Git clean patterns
GIT_CLEAN_PATTERNS=(
    ".config/raycast/extensions/"
    ".config/zed/prompts/"
    ".config/github-copilot/"
    "**/.github/"
    "**/.devcontainer/"
    "**/node_modules/"
    "**/.git/"
    "*.log"
    ".DS_Store"
)

cleanup_files() {
    print_info "Cleaning up unwanted files and directories..."
    
    for pattern in "${CLEANUP_ITEMS[@]}"; do
        if [[ "$DRY_RUN" == true ]]; then
            if ls $pattern 2>/dev/null | head -5; then
                print_warning "[DRY RUN] Would remove: $pattern"
            fi
        else
            if ls $pattern 2>/dev/null | head -5; then
                print_info "Removing: $pattern"
                rm -rf $pattern
            fi
        fi
    done
}

git_cleanup() {
    print_info "Performing git cleanup..."
    
    if [[ "$DRY_RUN" == true ]]; then
        print_warning "[DRY RUN] Would run git clean commands"
        git status --porcelain | grep "^??" | head -10
        return
    fi
    
    # Remove untracked files that match our patterns
    for pattern in "${GIT_CLEAN_PATTERNS[@]}"; do
        print_info "Cleaning git pattern: $pattern"
        git clean -fd "$pattern" 2>/dev/null || true
    done
    
    # Reset any staged files we don't want
    print_info "Unstaging unwanted files..."
    git reset HEAD -- .config/zed/prompts/ 2>/dev/null || true
    git reset HEAD -- .config/raycast/extensions/ 2>/dev/null || true
    git reset HEAD -- .config/github-copilot/ 2>/dev/null || true
}

update_gitignore_exclusions() {
    print_info "Checking .gitignore exclusions..."
    
    # Ensure .gitignore properly excludes the right things
    local important_exclusions=(
        ".config/raycast/extensions/"
        ".config/zed/prompts/"
        ".config/github-copilot/"
        ".oh-my-zsh/plugins/"
        ".oh-my-zsh/themes/"
        ".oh-my-zsh/.github/"
        ".tmux/plugins/*/"
    )
    
    for exclusion in "${important_exclusions[@]}"; do
        if ! grep -q "$exclusion" .gitignore; then
            print_warning "Consider adding $exclusion to .gitignore"
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

if [[ "$FORCE" != true && "$DRY_RUN" != true ]]; then
    echo -n "This will remove unwanted files from your dotfiles repo. Continue? [y/N]: "
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
    print_info "You may want to review the changes and commit the cleaned repository."
fi 