export PATH=/opt/homebrew/bin:$PATH
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export ZSH="$HOME/dotfiles/.oh-my-zsh"
export PATH="$HOME/.cargo/bin:$PATH"

[ -f ~/.env.local ] && source ~/.env.local

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


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
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/eduardkakosyan/.lmstudio/bin"
# End of LM Studio CLI section

