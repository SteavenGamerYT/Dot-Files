#!/usr/bin/env bash

# Terminate existing Waybar instances
killall -q waybar
while pgrep -u "$UID" -x waybar >/dev/null; do sleep 0.2; done

# Start Waybar with universal configuration
waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css & disown

# Wait for tray initialization
sleep 3

# Start syncthingtray if available
if command -v syncthingtray >/dev/null 2>&1; then
    syncthingtray --replace & disown
fi