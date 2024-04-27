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
alias zshrc='cd ~/dotfiles/zsh/.zshrc && nvim .'
alias zshaliases='cd ~/dotfiles/zsh/.aliases.zsh &&  nvim .'
alias zshconfig='cd ~/dotfiles/zsh'
alias gitconfig='cd ~/dotfiles/git/.gitconfig'
alias weztermconfig='cd ~/dotfiles/wezterm/wezterm.lua && nvim .'
alias nvimconfig='cd ~/dotfiles/nvim/init.lua && nvim .'

# Utility aliases
alias c='clear'
alias h='history'
alias j='jobs'
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias ping='ping -c 5'
alias ports='sudo lsof -iTCP -sTCP:LISTEN -P'
alias update='sudo softwareupdate -i -a'

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'
