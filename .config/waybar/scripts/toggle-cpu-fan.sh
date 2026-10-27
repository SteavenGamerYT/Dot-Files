#!/usr/bin/env bash

STATE_FILE="$HOME/.cache/waybar_cpu_fan_toggle"
[ -f "$STATE_FILE" ] || echo "cpu" > "$STATE_FILE"

CURRENT=$(<"$STATE_FILE")

if [ "$CURRENT" = "cpu" ]; then
    echo "fan" > "$STATE_FILE"
else
    echo "cpu" > "$STATE_FILE"
fi