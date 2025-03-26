if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Add the homebrew installs to the path
export PATH=/opt/homebrew/bin:$PATH
# Path to your Oh My Zsh installation.
export ZSH="$HOME/dotfiles/.oh-my-zsh"

export PATH="$HOME/.cargo/bin:$PATH"

alias cargrep='tmux attach -t cargrep'
alias dotfiles='tmux attach -t dotfiles'
alias lg='lazygit'

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

alias dotfiles='tmux attach -t dotfiles'
alias cargrep='tmux attach -t cargrep'

source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
