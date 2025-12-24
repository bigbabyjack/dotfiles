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
append_path "$HOME/.local/opt/go/bin"
append_path "$HOME/go/bin"
# switch on macOS vs arch linux
if [[ "$(uname -s)" == "Darwin" ]]; then
    append_path "/opt/homebrew/bin"
fi


export EDITOR=nvim

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_PICTURES_HOME="$HOME/Pictures"


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


# starship
eval "$(starship init zsh)"
if [[ "$(uname -s)" == "Darwin" ]]; then
    eval "$(brew shellenv)"
fi
eval "$(uv generate-shell-completion zsh)"
eval "$(zoxide init zsh)"

# set ctrl space to accept autosuggestions
source $HOME/.aliases.zsh

if [[ -f $HOME/.api_keys ]]; then
    source $HOME/.api_keys
fi

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey '^Y' autosuggest-accept
source $HOME/.config/.env
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
