# 🏠 Dotfiles

> _"Your development environment, perfected and portable"_

A comprehensive, automated dotfiles setup for macOS that gets you from zero to a fully configured development environment in minutes.

## ✨ Features

- 🚀 **One-command setup** - Clone and run, that's it
- 🔐 **Security-first** - API keys and secrets in `.env.local` (never committed)
- 🎨 **Beautiful terminal** - Powerlevel10k + Oh My Zsh + modern tools
- ⚡ **Fast workflow** - tmux, Neovim, aerospace window management
- 🛡️ **Backup & restore** - Never lose your configurations
- 🔄 **Symlink management** - Easy updates and maintenance
- 📦 **Package management** - Automated Homebrew setup

## 🎯 What's Included

### Core Tools

- **Shell**: Zsh with Oh My Zsh + Powerlevel10k theme
- **Editor**: Neovim with modern plugins (lazy.nvim)
- **Multiplexer**: tmux with TPM (Tmux Plugin Manager)
- **Window Manager**: Aerospace for tiling window management
- **Git**: Enhanced configuration with useful aliases
- **Terminal**: Modern CLI tools (ripgrep, fd, bat, exa, fzf, lazygit)

### Applications

- **Development**: Git, Node.js (via nvm), Python (via pyenv), pnpm
- **Productivity**: Raycast, Aerospace
- **Terminal Tools**: htop, tree, jq, stow

### Configurations

- Zsh with intelligent completions and syntax highlighting
- Tmux with sensible defaults and plugins
- Neovim with LSP, treesitter, and modern editing experience
- Git with helpful aliases and modern defaults
- Aerospace for efficient window management

## 🚀 Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run the installation script
./install.sh

# Or with options
./install.sh --backup --force
```

### First Run Setup

1. **Edit your environment variables**:

   ```bash
   nano ~/.env.local
   ```

   Add your API keys:

   ```bash
   export REFACT_API_KEY="your_key_here"
   export OPENAI_API_KEY="your_key_here"
   # Add other API keys as needed
   ```

2. **Install tmux plugins**:

   ```bash
   tmux
   # Press prefix + I (default: Ctrl-b + I)
   ```

3. **Setup Neovim**:

   ```bash
   nvim
   # Lazy.nvim will automatically install plugins
   ```

4. **Configure Git** (if not already done):
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

## 📁 Structure

```
dotfiles/
├── .config/                 # Application configurations
│   ├── nvim/               # Neovim configuration
│   ├── alacritty/          # Alacritty terminal config
│   └── raycast/            # Raycast scripts and config
├── .oh-my-zsh/             # Oh My Zsh framework
├── .tmux/                  # Tmux plugins and config
├── bin/                    # Custom scripts and binaries
├── .zshrc                  # Zsh configuration
├── .tmux.conf              # Tmux configuration
├── .aerospace.toml         # Aerospace window manager
├── .skhdrc                 # Hotkey daemon config
├── .gitignore              # What not to commit
├── install.sh              # Main installation script
├── backup.sh               # Backup and restore script
└── README.md               # This file
```

## 🛠️ Scripts

### Installation Script (`install.sh`)

The main installation script that sets up everything:

```bash
./install.sh [OPTIONS]

Options:
  --force     Force overwrite existing files
  --backup    Backup existing files before overwriting
  --help      Show help message

Examples:
  ./install.sh                    # Interactive installation
  ./install.sh --force           # Force overwrite everything
  ./install.sh --backup --force  # Backup then overwrite
```

**What it does:**

- Installs Homebrew and essential packages
- Sets up shell environment (Oh My Zsh + plugins)
- Configures tmux with TPM
- Creates symlinks for all configurations
- Sets up environment variables template
- Configures Git with sensible defaults

### Backup Script (`backup.sh`)

Create backups of your current dotfiles:

```bash
./backup.sh [OPTIONS]

Options:
  --compress           Compress backup to tar.gz
  --restore <dir>      Restore from backup directory
  --help               Show help

Examples:
  ./backup.sh                   # Create backup
  ./backup.sh --compress        # Create compressed backup
  ./backup.sh --restore ~/.dotfiles-backup-20231205-143022
```

## 🔐 Security & Privacy

### Environment Variables

All sensitive information (API keys, tokens, etc.) should be stored in `~/.env.local`:

```bash
# ~/.env.local (never committed to git)
export REFACT_API_KEY="your_refact_key"
export OPENAI_API_KEY="your_openai_key"
export ANTHROPIC_API_KEY="your_anthropic_key"
export GITHUB_TOKEN="your_github_token"
```

### What's Not Committed

The `.gitignore` is configured to exclude:

- All API keys and tokens
- Cache directories and logs
- Package manager lock files
- Application data that changes frequently
- Sensitive system configurations

## 🔄 Managing Your Dotfiles

### Adding New Configurations

1. Add your config file to the appropriate location in the dotfiles directory
2. Update the symlinks section in `install.sh` if needed
3. Add the file pattern to `.gitignore` allowlist if necessary

### Updating Configurations

Since everything is symlinked, just edit the files in your dotfiles directory and changes take effect immediately.

### Syncing Across Machines

```bash
# On machine 1: commit your changes
cd ~/dotfiles
git add .
git commit -m "Update configurations"
git push

# On machine 2: pull and re-run install if needed
cd ~/dotfiles
git pull
./install.sh --force  # If you want to overwrite local changes
```

## 🎨 Customization

### Shell Theme

The setup uses Powerlevel10k. To reconfigure:

```bash
p10k configure
```

### Tmux Plugins

Edit `.tmux.conf` and add plugins to the plugins list, then:

```bash
tmux
# Press prefix + I to install new plugins
# Press prefix + U to update plugins
```

### Neovim Plugins

Edit `.config/nvim/lua/plugins/` files. Lazy.nvim will automatically manage plugins.

## 🐛 Troubleshooting

### Common Issues

**Script fails with permission error:**

```bash
chmod +x install.sh backup.sh
```

**Environment variables not loading:**

```bash
# Make sure .env.local exists and is sourced
source ~/.env.local
echo $REFACT_API_KEY  # Should show your key
```

**Symlinks not working:**

```bash
# Re-run the symlink creation
./install.sh --force
```

**Tmux plugins not loading:**

```bash
# Reload tmux config
tmux source-file ~/.tmux.conf
# Install plugins: prefix + I
```

### Getting Help

1. Check the script output for specific error messages
2. Ensure you're running on macOS (the scripts are macOS-specific)
3. Make sure you have internet connection for package downloads
4. Try running with `--backup --force` to start fresh

## 🤝 Contributing

Feel free to fork this repository and customize it for your needs! If you have improvements that might benefit others, pull requests are welcome.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**Happy coding!** 🚀

_Made with ❤️ for developers who appreciate a well-crafted environment_
