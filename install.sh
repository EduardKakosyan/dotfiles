#!/bin/bash

# =============================================================================
# DOTFILES INSTALLATION SCRIPT
# =============================================================================
# This script sets up a complete development environment from your dotfiles
# Usage: ./install.sh [--force] [--backup] [--help]
# =============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
FORCE_INSTALL=false
CREATE_BACKUP=false

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

print_header() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                              DOTFILES SETUP                                 ║"
    echo "║                       Making your environment awesome                       ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_section() {
    echo -e "\n${CYAN}▶ $1${NC}"
    echo "─────────────────────────────────────────────────────────────────────────────"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Backup existing file/directory
backup_item() {
    local item="$1"
    if [[ -e "$item" && ! -L "$item" ]]; then
        if [[ "$CREATE_BACKUP" == true ]]; then
            mkdir -p "$BACKUP_DIR"
            cp -r "$item" "$BACKUP_DIR/"
            print_info "Backed up $(basename "$item") to $BACKUP_DIR"
        fi
        if [[ "$FORCE_INSTALL" == true ]]; then
            rm -rf "$item"
        else
            print_warning "$(basename "$item") exists. Use --force to overwrite or --backup to save."
            return 1
        fi
    elif [[ -L "$item" ]]; then
        print_info "Removing existing symlink: $(basename "$item")"
        rm "$item"
    fi
    return 0
}

# Create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ ! -e "$source" ]]; then
        print_warning "Source file $source doesn't exist, skipping"
        return
    fi
    
    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Backup and remove existing file
    if ! backup_item "$target"; then
        return
    fi
    
    # Create symlink
    ln -sf "$source" "$target"
    print_success "Linked $(basename "$source")"
}

# =============================================================================
# INSTALLATION STEPS
# =============================================================================

install_homebrew() {
    print_section "Installing Homebrew"
    
    if command_exists brew; then
        print_success "Homebrew is already installed"
        brew update
    else
        print_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        print_success "Homebrew installed successfully"
    fi
}

install_packages() {
    print_section "Installing Essential Packages"
    
    # Core development tools
    local packages=(
        "git"
        "curl"
        "wget"
        "tmux"
        "neovim"
        "ripgrep"
        "fd"
        "bat"
        "exa"
        "fzf"
        "lazygit"
        "stow"
        "tree"
        "jq"
        "htop"
        "pyenv"
        "nvm"
        "pnpm"
        "aerospace"
        "raycast"
    )
    
    print_info "Installing core packages..."
    for package in "${packages[@]}"; do
        if brew list "$package" &>/dev/null; then
            print_success "$package is already installed"
        else
            print_info "Installing $package..."
            brew install "$package" || print_warning "Failed to install $package"
        fi
    done
}

setup_shell() {
    print_section "Setting up Shell Environment"
    
    # Install Oh My Zsh if not present
    if [[ ! -d "$HOME/.oh-my-zsh" && ! -d "$DOTFILES_DIR/.oh-my-zsh" ]]; then
        print_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        
        # Move to dotfiles directory
        if [[ -d "$HOME/.oh-my-zsh" ]]; then
            mv "$HOME/.oh-my-zsh" "$DOTFILES_DIR/.oh-my-zsh"
        fi
    fi
    
    # Install Powerlevel10k theme
    local p10k_dir="$DOTFILES_DIR/.oh-my-zsh/custom/themes/powerlevel10k"
    if [[ ! -d "$p10k_dir" ]]; then
        print_info "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
    fi
    
    # Install useful plugins
    local plugins_dir="$DOTFILES_DIR/.oh-my-zsh/custom/plugins"
    
    # zsh-autosuggestions
    if [[ ! -d "$plugins_dir/zsh-autosuggestions" ]]; then
        print_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$plugins_dir/zsh-autosuggestions"
    fi
    
    # zsh-syntax-highlighting
    if [[ ! -d "$plugins_dir/zsh-syntax-highlighting" ]]; then
        print_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugins_dir/zsh-syntax-highlighting"
    fi
    
    # zsh-autocomplete
    if [[ ! -d "$plugins_dir/zsh-autocomplete" ]]; then
        print_info "Installing zsh-autocomplete..."
        git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git "$plugins_dir/zsh-autocomplete"
    fi
    
    print_success "Shell environment setup complete"
}

setup_tmux() {
    print_section "Setting up Tmux"
    
    # Install TPM (Tmux Plugin Manager)
    local tpm_dir="$DOTFILES_DIR/.tmux/plugins/tpm"
    if [[ ! -d "$tpm_dir" ]]; then
        print_info "Installing Tmux Plugin Manager..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    fi
    
    print_success "Tmux setup complete"
}

setup_neovim() {
    print_section "Setting up Neovim"
    
    # Create neovim config directory
    mkdir -p "$HOME/.config"
    
    print_success "Neovim setup complete"
}

create_symlinks() {
    print_section "Creating Symlinks"
    
    # Main dotfiles
    create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
    create_symlink "$DOTFILES_DIR/.aerospace.toml" "$HOME/.aerospace.toml"
    create_symlink "$DOTFILES_DIR/.skhdrc" "$HOME/.skhdrc"
    
    # Directories
    create_symlink "$DOTFILES_DIR/.tmux" "$HOME/.tmux"
    create_symlink "$DOTFILES_DIR/.oh-my-zsh" "$HOME/.oh-my-zsh"
    create_symlink "$DOTFILES_DIR/.config" "$HOME/.config"
    create_symlink "$DOTFILES_DIR/bin" "$HOME/bin"
    
    print_success "Symlinks created successfully"
}

setup_env_file() {
    print_section "Setting up Environment Variables"
    
    if [[ ! -f "$HOME/.env.local" ]]; then
        print_info "Creating .env.local template..."
        cat > "$HOME/.env.local" << 'EOF'
# Local environment variables (not committed to git)
# Add your API keys, tokens, and other secrets here

# Example:
# export REFACT_API_KEY="your_api_key_here"
# export OPENAI_API_KEY="your_openai_key_here"
# export ANTHROPIC_API_KEY="your_anthropic_key_here"
EOF
        print_warning "Please edit ~/.env.local to add your API keys and secrets"
    else
        print_success ".env.local already exists"
    fi
}

setup_git() {
    print_section "Git Configuration"
    
    # Check if git is configured
    if ! git config --global user.name &>/dev/null; then
        print_info "Git user name not set. Please configure:"
        echo -n "Enter your full name: "
        read -r user_name
        git config --global user.name "$user_name"
    fi
    
    if ! git config --global user.email &>/dev/null; then
        print_info "Git email not set. Please configure:"
        echo -n "Enter your email: "
        read -r user_email
        git config --global user.email "$user_email"
    fi
    
    # Set some useful git defaults
    git config --global init.defaultBranch main
    git config --global pull.rebase true
    git config --global core.autocrlf input
    
    print_success "Git configuration complete"
}

final_setup() {
    print_section "Final Setup"
    
    # Make sure fzf is properly configured
    if command_exists fzf; then
        "$(brew --prefix)"/opt/fzf/install --all --no-bash --no-fish
    fi
    
    # Source the new shell configuration
    print_info "Reloading shell configuration..."
    
    print_success "Installation complete!"
    echo ""
    print_info "Next steps:"
    echo "  1. Edit ~/.env.local to add your API keys"
    echo "  2. Run 'tmux' and press prefix + I to install tmux plugins"
    echo "  3. Open Neovim and let lazy.nvim install plugins"
    echo "  4. Restart your terminal or run 'source ~/.zshrc'"
    echo ""
    print_warning "You may need to restart your terminal for all changes to take effect."
}

# =============================================================================
# ARGUMENT PARSING
# =============================================================================

show_help() {
    echo "Dotfiles Installation Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --force     Force overwrite existing files"
    echo "  --backup    Backup existing files before overwriting"
    echo "  --help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                    # Interactive installation"
    echo "  $0 --force           # Force overwrite everything"
    echo "  $0 --backup --force  # Backup then overwrite"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --force)
            FORCE_INSTALL=true
            shift
            ;;
        --backup)
            CREATE_BACKUP=true
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

# =============================================================================
# MAIN EXECUTION
# =============================================================================

main() {
    print_header
    
    # Check if we're in the dotfiles directory
    if [[ ! -f "$PWD/install.sh" ]]; then
        print_error "Please run this script from the dotfiles directory"
        exit 1
    fi
    
    # Update DOTFILES_DIR to current directory
    DOTFILES_DIR="$PWD"
    
    print_info "Dotfiles directory: $DOTFILES_DIR"
    print_info "Backup directory: $BACKUP_DIR"
    print_info "Force install: $FORCE_INSTALL"
    print_info "Create backup: $CREATE_BACKUP"
    echo ""
    
    # Ask for confirmation unless force is specified
    if [[ "$FORCE_INSTALL" != true ]]; then
        echo -n "Continue with installation? [y/N]: "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled"
            exit 0
        fi
    fi
    
    # Run installation steps
    install_homebrew
    install_packages
    setup_shell
    setup_tmux
    setup_neovim
    create_symlinks
    setup_env_file
    setup_git
    final_setup
    
    print_success "🎉 Dotfiles installation completed successfully!"
}

# Run main function
main "$@" 