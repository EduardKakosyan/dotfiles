export PATH=/opt/homebrew/bin:$PATH
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
# Path to your Oh My Zsh installation.
export ZSH="$HOME/dotfiles/.oh-my-zsh"

export PATH="$HOME/.cargo/bin:$PATH"

alias cargrep='tmux attach -t cargrep'
alias dotfiles='tmux attach -t dotfiles'
alias lg='lazygit'
alias st="$HOME/bin/.local/scripts/session-tokenizer.sh"

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

# ZSH_AUTOSUGGESTIONS_DIR="$HOME/dotfiles/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
# source "$ZSH_AUTOSUGGESTIONS_DIR/zsh-autosuggestions.zsh"


bindkey -e  # Use Emacs keybindings
bindkey "^[[A" up-line-or-history  # Up arrow
bindkey "^[[B" down-line-or-history  # Down arrow

source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# pnpm
export PNPM_HOME="/Users/eduardkakosyan/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
