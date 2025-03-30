if [[ -n $HOME/dotfiles/.env ]]; then
    source $HOME/dotfiles/.env
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

zstyle ':omz:update' mode auto
ENABLE_CORRECTION="true"

plugins=(git aliases z zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
source ~/.aliases.zsh

export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:"$HOME/bin"

export PATH="$PATH:/opt/homebrew/bin:/opt/homebrew/bin/npm"
eval "$(brew shellenv)"

# Custom widget to accept autosuggestion or perform tab completion
bindkey '^ ' autosuggest-accept
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
