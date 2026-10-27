#!/usr/bin/env bash

command -v nvidia-smi >/dev/null 2>&1 || exit 1
usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | awk '{print int($1)}' | head -n1)

if [ -z "$usage" ]; then
    exit 1
fi

temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1)
power=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits 2>/dev/null | head -n1)

tooltip="NVIDIA GPU: ${usage}%"
[ -n "$temp" ] && tooltip="${tooltip}\nTemperature: ${temp}°C"
[ -n "$power" ] && tooltip="${tooltip}\nPower Draw: ${power}W"

tooltip_json=$(printf "%b" "$tooltip" | jq -Rs .)

echo "{\"text\": \"󰍹 ${usage}%\", \"tooltip\": $tooltip_json}"