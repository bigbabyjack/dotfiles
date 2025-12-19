#!/bin/bash

# Parse GRUB menu entries and display in wofi for reboot selection
# Usage: ./grub-reboot-menu.sh

GRUB_CFG="/boot/grub/grub.cfg"

# Try to read GRUB config with pkexec if needed
if [[ ! -r "$GRUB_CFG" ]]; then
    menu_entries=$(pkexec cat "$GRUB_CFG" 2>/dev/null | grep -n "^menuentry" | \
        sed -E "s/^([0-9]+):.*menuentry '([^']+)'.*/\2/" | \
        nl -v0 -nln | \
        sed 's/^\([0-9]\+\)\t\(.*\)/\1: \2/')
else
    menu_entries=$(grep -n "^menuentry" "$GRUB_CFG" | \
        sed -E "s/^([0-9]+):.*menuentry '([^']+)'.*/\2/" | \
        nl -v0 -nln | \
        sed 's/^\([0-9]\+\)\t\(.*\)/\1: \2/')
fi

if [[ -z "$menu_entries" ]]; then
    notify-send "Error" "No menu entries found or unable to read GRUB config"
    exit 1
fi

# Display options in wofi
selected=$(echo "$menu_entries" | wofi --dmenu --prompt "Select boot option:" --height 400 --width 600)

if [[ -n "$selected" ]]; then
    # Extract the index number
    index=$(echo "$selected" | cut -d':' -f1)
    entry_name=$(echo "$selected" | cut -d':' -f2- | sed 's/^ *//')
    
    # Confirm the selection
    confirm=$(echo -e "Yes\nNo" | wofi --dmenu --prompt "Reboot to: $entry_name?")
    
    if [[ "$confirm" == "Yes" ]]; then
        # Set GRUB to boot the selected entry on next reboot
        pkexec grub-reboot "$index"
        if [[ $? -eq 0 ]]; then
            notify-send "Reboot Scheduled" "Next boot: $entry_name"
            # Reboot the system
            systemctl reboot
        else
            notify-send "Error" "Failed to set GRUB boot entry"
        fi
    fi
fi