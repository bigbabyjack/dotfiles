# # Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
# ls commands
alias ls='lsd'
alias lt='lsd --tree'
alias lat='lsd -A --tree'
alias ll='lsd -alF'
alias la='lsd -A'
alias l='lsd -CF'

# dotfile commands
alias dotfiles='cd ~/dotfiles'
alias zshrc='cd ~/dotfiles/zsh && nvim .zshrc'
alias zshaliases='cd ~/dotfiles/zsh &&  nvim .aliases.zsh'
alias zshconfig='cd ~/dotfiles/zsh'
alias gitconfig='cd ~/dotfiles/git && nvim .gitconfig'
alias weztermconfig='cd ~/dotfiles/wezterm && nvim wezterm.lua'
alias nvimconfig='cd ~/dotfiles/nvim && nvim init.lua'

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# shortcut commands
alias workspace='cd ~/workspace'

# Utility aliases
alias c='clear'
alias h='history'
alias j='jobs'
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias ping='ping -c 5'
alias ports='sudo lsof -iTCP -sTCP:LISTEN -P'
alias update='sudo softwareupdate -i -a'

# Git
alias lg='lazygit'

# Python
alias python='python3'
alias activate='source env/bin/activate'
alias mkvenv='python -m venv env'
