#!/usr/bin/env bash
# Pending pacman + AUR update count for waybar custom module (JSON).
# Hides when zero.

repo=$(checkupdates 2>/dev/null | wc -l)
aur=$(paru -Qua 2>/dev/null | wc -l)
total=$((repo + aur))

if [ "$total" -eq 0 ]; then
  echo '{"text":"","tooltip":"All up to date"}'
  exit 0
fi

tooltip="$repo repo, $aur AUR"
printf '{"text":"󰚰 %s","tooltip":"%s"}\n' "$total" "$tooltip"
