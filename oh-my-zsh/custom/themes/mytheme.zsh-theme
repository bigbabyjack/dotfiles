my_prompt_env() {
  if [[ -n $DEV_ENV ]]; then 
    if [[ $DEV_ENV == "personal" ]]; then
      echo "🏠"
    elif [[ $DEV_ENV == "work" ]]; then
      echo "🏢"
    else
      echo "$DEV_ENV"
    fi
  else
    echo "❌"
  fi
}
PROMPT="%{$fg_bold[green]%}$(my_prompt_env)%{$reset_color%} %{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'


ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
