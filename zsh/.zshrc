# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode auto      # update automatically without asking

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$PATH:$HOME/.scripts/"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$HOME/.scripts/dev-setup/"
export PATH="$PATH:$HOME/go/bin"
export PATH="/opt/homebrew/opt/python@3.12/bin:$PATH"
GOPATH=$HOME/go  
PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
export EDITOR="nvim"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
source ~/.aliases.zsh

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jack/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jack/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jack/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jack/google-cloud-sdk/completion.zsh.inc'; fi

bindkey '^ ' autosuggest-accept
export AWS_PROFILE=my-dev-profile
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
