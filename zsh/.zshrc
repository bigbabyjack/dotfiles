function append_path() {
  if [[ -d $1 ]]; then
    export PATH="$PATH:$1"
  else
    echo "Directory $1 does not exist."
  fi
}

# PATH
append_path "/usr/local/go/bin"
append_path "$HOME/.local/bin"

export EDITOR=nvim

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_PICTURES_HOME="$HOME/Pictures"

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Basic zsh options
setopt AUTO_CD CORRECT CORRECT_ALL HIST_VERIFY SHARE_HISTORY
setopt HIST_IGNORE_SPACE HIST_IGNORE_DUPS HIST_EXPIRE_DUPS_FIRST EXTENDED_HISTORY

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Completion
autoload -U compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select

# Load plugins (these should be at the end)
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# set ctrl space to accept autosuggestions
bindkey '^Y' autosuggest-accept
export PATH=$PATH:/home/jack/.spicetify
source $HOME/.aliases.zsh

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
