# # Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
# Core “ls” replacements (with color)
alias l='eza --icons --group-directories-first --header --color=always'
alias ls='eza'
alias la='eza -a --icons --group-directories-first --header --color=always'
alias ll='eza -l --long --icons --group-directories-first --header --color=always'
alias lh='eza -lh --icons --group-directories-first --header --color=always'

# Trees & depth control
alias lt='eza --tree --level=2 --icons --group-directories-first --color=always'
alias ltt='eza --tree --level=3 --icons --group-directories-first --color=always'
alias ltree='eza --tree --icons --group-directories-first --color=always'

# Git & sorting magic
alias lgit='eza --git --icons --group-directories-first --header --color=always'
alias lS='eza -l --sort=size --reverse --icons --group-directories-first --color=always'
alias lX='eza -l --sort=extension --icons --group-directories-first --color=always'
alias lm='eza -l --sort=modified --reverse --icons --group-directories-first --color=always'

# Narrow & focus
alias ldir='eza --only-dirs --icons --group-directories-first --header --color=always'
alias lfile='eza --only-files --icons --group-directories-first --header --color=always'
alias lhidden='eza -a --ignore-glob="*" --icons --group-directories-first --color=always'

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

alias v="nvim"

alias repeatkeyon="defaults write -g ApplePressAndHoldEnabled -bool false"
alias repeatkeyoff="defaults write -g ApplePressAndHoldEnabled -bool true"

source $HOME/.aliases.$DEV_ENV.zsh
