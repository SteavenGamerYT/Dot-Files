#!/usr/bin/env bash

TEMP=$(sensors 2>/dev/null | awk '/Tctl:/ { gsub(/\+|°C/, "", $2); print int($2); exit }')
if [ -z "$TEMP" ]; then
    TEMP=$(sensors 2>/dev/null | awk '/Package id 0:/ { gsub(/\+|°C/, "", $4); print int($4); exit }')
fi
if [ -z "$TEMP" ]; then
    TEMP=$(sensors 2>/dev/null | awk '/Core 0:/ { gsub(/\+|°C/, "", $3); print int($3); exit }')
fi
if [ -z "$TEMP" ]; then
    TEMP=$(sensors 2>/dev/null | awk '/temp1:/ { gsub(/\+|°C/, "", $2); print int($2); exit }')
fi

if [ -z "$TEMP" ]; then
    echo " N/A"
    exit 0
fi

if [ "$TEMP" -le 55 ]; then
    ICON=""
elif [ "$TEMP" -le 74 ]; then
    ICON=""
else
    ICON=""
fi

echo "$ICON ${TEMP}°C"