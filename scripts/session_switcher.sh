#!/bin/bash

# Get a list of existing tmux sessions
sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)

# Prompt with wofi and suppress GTK warnings
chosen=$(echo "$sessions" | wofi --dmenu --prompt "tmux session:" 2>/dev/null)

# Exit if nothing selected
[ -z "$chosen" ] && exit

# Inside a tmux session?
inside_tmux=$TMUX

if echo "$sessions" | grep -q "^$chosen$"; then
  # Existing session
  if [ -n "$inside_tmux" ]; then
    tmux switch-client -t "$chosen"
  else
    tmux attach-session -t "$chosen"
  fi
else
  # New session
  if [ -n "$inside_tmux" ]; then
    tmux new-session -ds "$chosen"
    tmux switch-client -t "$chosen"
  else
    tmux new-session -s "$chosen"
  fi
fi
