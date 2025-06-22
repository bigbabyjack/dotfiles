#!/usr/bin/env bash

# System Menu Script for Waybar
# This script creates a menu with system controls using wofi

# Define menu options
options="🔊 Volume Control
🔔 Toggle Notifications
📋 Clipboard History
📶 Network Manager
🔵 Bluetooth Manager
⚡ Power Profile: Balanced
⚡ Power Profile: Performance
⚡ Power Profile: Power Saver"

# Show the menu and capture selection
selected=$(echo "$options" | wofi --dmenu --prompt "System Controls" --width 300 --height 250)

# Execute based on selection
case "$selected" in
    "🔊 Volume Control")
        pavucontrol &
        ;;
    "🔔 Toggle Notifications")
        dunstctl set-paused toggle
        # Show notification status
        if dunstctl is-paused | grep -q "true"; then
            notify-send "Notifications" "Paused" -t 2000
        else
            notify-send "Notifications" "Enabled" -t 2000
        fi
        ;;
    "📋 Clipboard History")
        cliphist list | wofi --dmenu --prompt "Clipboard" | cliphist decode | wl-copy
        ;;
    "📶 Network Manager")
        nm-connection-editor &
        ;;
    "🔵 Bluetooth Manager")
        blueman-manager &
        ;;
    "⚡ Power Profile: Balanced")
        powerprofilesctl set balanced
        notify-send "Power Profile" "Set to Balanced" -t 2000
        ;;
    "⚡ Power Profile: Performance")
        powerprofilesctl set performance
        notify-send "Power Profile" "Set to Performance" -t 2000
        ;;
    "⚡ Power Profile: Power Saver")
        powerprofilesctl set power-saver
        notify-send "Power Profile" "Set to Power Saver" -t 2000
        ;;
esac
