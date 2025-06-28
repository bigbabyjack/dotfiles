#!/usr/bin/env bash

# Ensure fzf is available
command -v fzf >/dev/null || paru -S --needed --noconfirm fzf

# Collect tmux sessions (quietly ignore 'no server running')
sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)

# Pick one or many
chosen=$(printf '%s\n' "$sessions" |
         fzf --prompt 'tmux session(s): ' --multi --height 20 --border --ansi)

# Abort if nothing was selected
[[ -z $chosen ]] && exit 0

# Kill the selected sessions
printf '%s\n' "$chosen" | xargs -r -n1 tmux kill-session -t
