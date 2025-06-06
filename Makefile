# =============================================================================
# DOTFILES MAKEFILE
# =============================================================================
# Common tasks for managing dotfiles
# Usage: make [target]
# =============================================================================

.PHONY: install backup restore clean status help

# Default target
.DEFAULT_GOAL := help

# Colors
GREEN  := \033[32m
YELLOW := \033[33m
BLUE   := \033[34m
RESET  := \033[0m

## Install dotfiles and dependencies
install:
	@echo "$(BLUE)Installing dotfiles...$(RESET)"
	./install.sh

## Install with force (overwrite existing files)
install-force:
	@echo "$(BLUE)Installing dotfiles (force mode)...$(RESET)"
	./install.sh --force

## Install with backup
install-backup:
	@echo "$(BLUE)Installing dotfiles (with backup)...$(RESET)"
	./install.sh --backup --force

## Create backup of current dotfiles
backup:
	@echo "$(BLUE)Creating backup...$(RESET)"
	./backup.sh

## Create compressed backup
backup-compress:
	@echo "$(BLUE)Creating compressed backup...$(RESET)"
	./backup.sh --compress

## Clean up repository (dry run)
clean-dry:
	@echo "$(BLUE)Cleaning repository (dry run)...$(RESET)"
	./cleanup.sh --dry-run

## Clean up repository
clean:
	@echo "$(BLUE)Cleaning repository...$(RESET)"
	./cleanup.sh

## Clean up repository (force)
clean-force:
	@echo "$(BLUE)Cleaning repository (force)...$(RESET)"
	./cleanup.sh --force

## Show git status
status:
	@echo "$(BLUE)Repository status:$(RESET)"
	@git status --short

## Install homebrew packages from Brewfile
brew:
	@echo "$(BLUE)Installing Homebrew packages...$(RESET)"
	@brew bundle install

## Update homebrew packages
brew-update:
	@echo "$(BLUE)Updating Homebrew packages...$(RESET)"
	@brew update && brew upgrade

## Generate new Brewfile from installed packages
brew-dump:
	@echo "$(BLUE)Generating Brewfile...$(RESET)"
	@brew bundle dump --force

## Set up development environment
setup: install brew
	@echo "$(GREEN)Development environment setup complete!$(RESET)"

## Update everything
update:
	@echo "$(BLUE)Updating dotfiles...$(RESET)"
	@git pull
	@echo "$(BLUE)Updating Homebrew packages...$(RESET)"
	@brew update && brew upgrade
	@echo "$(GREEN)Update complete!$(RESET)"

## Show help
help:
	@echo "$(GREEN)Available targets:$(RESET)"
	@echo ""
	@echo "$(YELLOW)Installation:$(RESET)"
	@echo "  install        - Install dotfiles and dependencies"
	@echo "  install-force  - Install with force (overwrite existing)"
	@echo "  install-backup - Install with backup"
	@echo "  setup          - Complete setup (install + brew)"
	@echo ""
	@echo "$(YELLOW)Backup & Restore:$(RESET)"
	@echo "  backup         - Create backup of current dotfiles"
	@echo "  backup-compress - Create compressed backup"
	@echo ""
	@echo "$(YELLOW)Maintenance:$(RESET)"
	@echo "  clean-dry      - Preview cleanup (dry run)"
	@echo "  clean          - Clean up repository"
	@echo "  clean-force    - Clean up repository (force)"
	@echo "  status         - Show git status"
	@echo "  update         - Update dotfiles and packages"
	@echo ""
	@echo "$(YELLOW)Package Management:$(RESET)"
	@echo "  brew           - Install packages from Brewfile"
	@echo "  brew-update    - Update Homebrew packages"
	@echo "  brew-dump      - Generate new Brewfile"
	@echo ""
	@echo "$(YELLOW)Help:$(RESET)"
	@echo "  help           - Show this help message" 