# # Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
# ls commands
alias ls='lsd'
alias lt='lsd --tree --ignore-glob ".git" --ignore-glob "$(git ls-files --others --ignored --exclude-standard --directory)"'
alias lat='lsd -A --tree --ignore-glob ".git" --ignore-glob "$(git ls-files --others --ignored --exclude-standard --directory)"'
alias ll='lsd -alF'
alias la='lsd -A'
alias l='lsd -CF'

alias cdcg="cd ~/cg-github/"
alias cdqaws="cd ~/cg-github/core-ml-question-answer-web-service/"
alias cdea="cd ~/cg-github/core-ml-exploratory-analytics/"
alias g="git"
alias activate="source env/bin/activate"

alias lg="lazygit"

# dotfile commands
alias dotfiles='cd ~/dotfiles'
alias zshrc='cd ~/dotfiles/zsh && nvim .zshrc'
alias zshaliases='cd ~/dotfiles/zsh &&  nvim .aliases.zsh'
alias zshconfig='cd ~/dotfiles/zsh'
alias gitconfig='cd ~/dotfiles/git && nvim .gitconfig'
alias weztermconfig='cd ~/dotfiles/wezterm && nvim wezterm.lua'
alias nvimconfig='cd ~/dotfiles/nvim && nvim .'

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# shortcut commands
# alias workspace='cd ~/workspace'

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

# websites
alias draw='open https://excalidraw.com/'
alias google='open https://www.google.com/'
alias github='open https://github.com/'

alias vim="nvim"
alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql

alias repeatkeyon="defaults write -g ApplePressAndHoldEnabled -bool false"
alias repeatkeyoff="defaults write -g ApplePressAndHoldEnabled -bool true"

alias reset-aws-token="okta-aws-cli web --profile core-ml-sdev"
alias reset-qh-token="okta-awscli --okta-profile qh-prod --profile qh-prod"
