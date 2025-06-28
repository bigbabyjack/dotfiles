#!/bin/bash

# Nerd Font icons
ICON_PLAY=$'\uf144'   # 
ICON_PAUSE=$'\uf04c'  # 
ICON_STOP=$'\uf6a9'   # 

# Priority list (first = highest priority)
PRIORITY_PLAYERS=(spotify_player chromium.instance16929)

# Track the best candidate
selected_player=""
selected_status=""

# First, look for Playing
for player in "${PRIORITY_PLAYERS[@]}"; do
  status=$(playerctl --player="$player" status 2>/dev/null)
  if [[ "$status" == "Playing" ]]; then
    selected_player="$player"
    selected_status="Playing"
    break
  fi
done

# If none Playing, look for Paused
if [[ -z "$selected_player" ]]; then
  for player in "${PRIORITY_PLAYERS[@]}"; do
    status=$(playerctl --player="$player" status 2>/dev/null)
    if [[ "$status" == "Paused" ]]; then
      selected_player="$player"
      selected_status="Paused"
      break
    fi
  done
fi

# Output
if [[ -n "$selected_player" ]]; then
  song=$(playerctl --player="$selected_player" metadata --format '{{ artist }} - {{ title }}' 2>/dev/null | cut -c -40)
  case "$selected_status" in
    Playing)
      echo "$ICON_PLAY $song"
      ;;
    Paused)
      echo "$ICON_PAUSE $song"
      ;;
  esac
else
  echo ""
fi
