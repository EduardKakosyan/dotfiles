if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Add the homebrew installs to the path
export PATH=/opt/homebrew/bin:$PATH
# Path to your Oh My Zsh installation.
export ZSH="$HOME/dotfiles/.oh-my-zsh"

plugins=(
    npm
    git
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
