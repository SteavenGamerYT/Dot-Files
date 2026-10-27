#!/usr/bin/env bash
FAN_SPEED=$(sensors -u it8665-isa-0290 2>/dev/null | awk '/fan1_input:/ {print int($2)}')
if [ -n "$FAN_SPEED" ]; then
    echo "${FAN_SPEED} RPM"
else
    echo "N/A"
fi