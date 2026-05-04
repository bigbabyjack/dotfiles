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

# Plugins (zsh-syntax-highlighting must be sourced last)
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# set ctrl space to accept autosuggestions
bindkey '^Y' autosuggest-accept
export PATH="$PATH:$HOME/.spicetify"
source $HOME/.aliases.zsh

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

. "$HOME/.local/bin/env"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
alias open=xdg-open
