#!/bin/bash

# =============================================================================
# DOTFILES BACKUP SCRIPT
# =============================================================================
# This script backs up your current dotfiles before installation
# Usage: ./backup.sh [--compress] [--restore <backup_dir>]
# =============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
COMPRESS=false
RESTORE_MODE=false
RESTORE_DIR=""

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ $1${NC}"; }

# Files and directories to backup
BACKUP_ITEMS=(
    ".zshrc"
    ".bashrc"
    ".bash_profile"
    ".tmux.conf"
    ".vimrc"
    ".gitconfig"
    ".aerospace.toml"
    ".skhdrc"
    ".config/nvim"
    ".config/alacritty"
    ".config/kitty"
    ".config/raycast"
    ".config/aerospace"
    ".config/yabai"
    ".config/skhd"
    ".tmux"
    ".oh-my-zsh"
    "bin"
)

backup_dotfiles() {
    print_info "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    for item in "${BACKUP_ITEMS[@]}"; do
        source_path="$HOME/$item"
        if [[ -e "$source_path" ]]; then
            print_info "Backing up $item..."
            cp -r "$source_path" "$BACKUP_DIR/"
        fi
    done
    
    # Create backup manifest
    cat > "$BACKUP_DIR/backup-info.txt" << EOF
Backup created: $(date)
Hostname: $(hostname)
User: $(whoami)
Shell: $SHELL
Items backed up:
$(for item in "${BACKUP_ITEMS[@]}"; do
    if [[ -e "$HOME/$item" ]]; then
        echo "  ✓ $item"
    else
        echo "  ✗ $item (not found)"
    fi
done)
EOF
    
    if [[ "$COMPRESS" == true ]]; then
        print_info "Compressing backup..."
        tar -czf "${BACKUP_DIR}.tar.gz" -C "$(dirname "$BACKUP_DIR")" "$(basename "$BACKUP_DIR")"
        rm -rf "$BACKUP_DIR"
        print_success "Backup compressed to ${BACKUP_DIR}.tar.gz"
    else
        print_success "Backup created at $BACKUP_DIR"
    fi
}

restore_dotfiles() {
    if [[ ! -d "$RESTORE_DIR" ]]; then
        print_error "Restore directory $RESTORE_DIR does not exist"
        exit 1
    fi
    
    print_warning "This will overwrite your current dotfiles!"
    echo -n "Continue? [y/N]: "
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_info "Restore cancelled"
        exit 0
    fi
    
    print_info "Restoring from $RESTORE_DIR..."
    
    for item in "${BACKUP_ITEMS[@]}"; do
        backup_path="$RESTORE_DIR/$item"
        target_path="$HOME/$item"
        
        if [[ -e "$backup_path" ]]; then
            print_info "Restoring $item..."
            # Remove existing symlink or file
            [[ -e "$target_path" ]] && rm -rf "$target_path"
            # Create parent directory if needed
            mkdir -p "$(dirname "$target_path")"
            # Copy from backup
            cp -r "$backup_path" "$target_path"
        fi
    done
    
    print_success "Restore completed!"
}

show_help() {
    echo "Dotfiles Backup Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --compress           Compress backup to tar.gz"
    echo "  --restore <dir>      Restore from backup directory"
    echo "  --help               Show this help"
    echo ""
    echo "Examples:"
    echo "  $0                   # Create backup"
    echo "  $0 --compress        # Create compressed backup"
    echo "  $0 --restore ~/.dotfiles-backup-20231205-143022"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --compress)
            COMPRESS=true
            shift
            ;;
        --restore)
            RESTORE_MODE=true
            RESTORE_DIR="$2"
            shift 2
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
if [[ "$RESTORE_MODE" == true ]]; then
    restore_dotfiles
else
    backup_dotfiles
fi 