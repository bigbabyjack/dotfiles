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

# dotfile commands
alias dotfiles='cd ~/dotfiles'

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
alias grep='rg --color=auto'
alias mkdir='mkdir -pv'
alias ping='ping -c 5'

# Git
alias lg='gitui'

alias v="nvim"
