if [[ -f $HOME/dotfiles/.env ]]; then
    source $HOME/dotfiles/.env
fi

export ZSH="$HOME/.oh-my-zsh"

if [[ "$DEV_ENV" == "work" ]]; then
    echo "Setting up work environment"
    ln -sf "$HOME/dotfiles/git/.gitconfig-work" "$HOME/dotfiles/git/.gitconfig-env"
elif [[ "$DEV_ENV" == "personal" ]]; then
    echo "Setting up personal environment"
    ln -sf "$HOME/dotfiles/git/.gitconfig-personal" "$HOME/dotfiles/git/.gitconfig-env"
fi

ZSH_THEME="mytheme"

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
