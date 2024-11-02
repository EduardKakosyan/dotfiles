if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Add the homebrew installs to the path
export PATH=/opt/homebrew/bin:$PATH
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  docker
  sudo
  web-search
)

source $ZSH/oh-my-zsh.sh



[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
