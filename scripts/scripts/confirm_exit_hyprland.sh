#!/bin/bash
choice=$(printf "No\nYes" | wofi --dmenu --prompt "Exit Hyprland?")
[ "$choice" = "Yes" ] && hyprctl dispatch exit
