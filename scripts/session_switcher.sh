#!/usr/bin/env bash
if [[ -z $TMUX ]]; then
  echo "This script must be run inside a tmux session."
  exit 1
fi


# -----------------------------------
# Helper functions (session ⭢ files)
# -----------------------------------
list_tmux_sessions() {
  tmux list-sessions | awk -F: '{print "\t" $1}' 2>/dev/null | sort -u \
    | sed 's/^\s*//;s/\s*$//;s/ /_/g'  # trim spaces and replace with underscores
}

list_files() {
  fd ~/dev -maxdepth 2 -type f -printf "\t%P\n" 2>/dev/null
}

# -----------------------------------------------------
# Launch fzf with Ctrl-S/Ctrl-T to toggle between views
# -----------------------------------------------------
selected=$( \
  list_tmux_sessions | fzf \
    --no-multi \
    --height=50% \
    --layout=reverse \
    --border=rounded \
    --prompt 'Items (Tab: select, Ctrl-S: files, Ctrl-T: sessions) > ' \
    --header 'Enter: attach/open' \
    --delimiter=$'\t' \
    --preview-window=right:60% \
    --bind "ctrl-s:reload($(declare -f list_files); list_files)+reload(sync)+change-prompt('Files (Tab: select, Ctrl-T: sessions) > ')" \
    --bind "ctrl-t:reload($(declare -f list_tmux_sessions); list_tmux_sessions)+reload(sync)+change-prompt('Sessions (Tab: select, Ctrl-S: files) > ')" \
)

# exit if nothing chosen
[[ -z $selected ]] && exit 0

# Extract the session name or file path
if [[ $selected == * ]]; then
  session_name=$(echo "$selected" | cut -f2- -d$'\t')
  tmux switch-client -t "$session_name"
else
  file_path=$(echo "$selected" | cut -f2- -d$'\t')
  tmux new-window "nvim ~/dev/$file_path"
fi
