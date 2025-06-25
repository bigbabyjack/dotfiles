#!/bin/bash

# Nerd Font icons
ICON_PLAY=$'\uf144'   # 
ICON_PAUSE=$'\uf04c'  # 
ICON_STOP=$'\uf6a9'   # 

# Check status
status=$(playerctl status 2>/dev/null)

# Song info
song=$(playerctl metadata --format '{{ artist }} - {{ title }}' 2>/dev/null | cut -c -50)

# Output based on status
case "$status" in
  Playing)
    echo "$ICON_PLAY $song"
    ;;
  Paused)
    echo "$ICON_PAUSE $song"
    ;;
  *)
    echo ""
    ;;
esac
