#!/usr/bin/env bash
# Logitech HID++ peripheral battery for waybar custom module (JSON).
# Hides itself when no device is connected (mouse asleep / unifying off).

shopt -s nullglob
caps=(/sys/class/power_supply/hidpp_battery_*/capacity)
if [ ${#caps[@]} -eq 0 ]; then
  echo '{"text":"","tooltip":""}'
  exit 0
fi

cap=$(<"${caps[0]}")
dir=$(dirname "${caps[0]}")
status=$(<"$dir/status" 2>/dev/null)
model=$(<"$dir/model_name" 2>/dev/null)

icon="󰍽"
class="ok"
[ "$cap" -le 20 ] && class="low"
[ "$cap" -le 10 ] && class="critical"

printf '{"text":"%s %s%%","tooltip":"%s: %s%% (%s)","class":"%s"}\n' \
  "$icon" "$cap" "${model:-Logitech}" "$cap" "${status:-Unknown}" "$class"
