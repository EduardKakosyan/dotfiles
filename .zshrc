# ======================
# Base PATH & Homebrew
# ======================
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

typeset -U path PATH

# ======================
# Oh My Zsh location
# ======================
export ZSH="$HOME/dotfiles/.oh-my-zsh"

# ======================
# Local overrides
# ======================
[ -f ~/.env.local ] && source ~/.env.local

# ======================
# NVM (Homebrew-managed)
# ======================
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # Loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # nvm completion

# ======================
# Aliases
# ======================
alias cargrep='tmux attach -t cargrep'
alias dotfiles='tmux attach -t dotfiles'
alias lg='lazygit'
alias st="$HOME/bin/.local/scripts/session-tokenizer.sh"

# ======================
# Oh My Zsh plugins & theme
# ======================
plugins=(
    npm
    git
    z
    web-search
    pip
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-autocomplete
)
ZSH_THEME="powerlevel10k/powerlevel10k"

# ======================
# Keybindings
# ======================
bindkey -e                      # Emacs keybindings
bindkey "^[[A" up-line-or-history
bindkey "^[[B" down-line-or-history

# ======================
# Oh My Zsh core
# ======================
source "$ZSH/oh-my-zsh.sh"

# ======================
# FZF
# ======================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ======================
# Powerlevel10k
# ======================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ======================
# pyenv
# ======================
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# ======================
# pnpm
# ======================
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# ======================
# Misc env
# ======================
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

# ======================
# LM Studio CLI
# ======================
export PATH="$PATH:$HOME/.lmstudio/bin"

# ======================
# Extra NVM bash completion (if present)
# ======================
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # nvm completion

# ======================
# Local bin (user scripts, tools)
# ======================
export PATH="$HOME/.local/bin:$PATH"

# ======================
# Rust / Rustup / Cargo (KEEP THIS LAST)
# ======================
# Where rustup stores toolchains
export RUSTUP_HOME="$HOME/.rustup"
# Where cargo binaries live
export CARGO_HOME="$HOME/.cargo"

# Add both Cargo shims (if any) AND the concrete toolchain bin rustup told you about
export PATH="$CARGO_HOME/bin:$RUSTUP_HOME/toolchains/stable-aarch64-apple-darwin/bin:$PATH"

