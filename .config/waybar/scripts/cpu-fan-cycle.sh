#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
STATE_FILE="$HOME/.cache/waybar_cpu_fan_cycle"
CPU_SCRIPT="$SCRIPT_DIR/cpu-usage.sh"
FAN_SCRIPT="$SCRIPT_DIR/fans.sh"
TEMP_SCRIPT="$SCRIPT_DIR/cpu-temp.sh"
WATT_SCRIPT="$SCRIPT_DIR/cpu-watts.sh"
CLOCKS_SCRIPT="$SCRIPT_DIR/cpu-clocks.sh"

# Create state file if missing
[ -f "$STATE_FILE" ] || echo "fan" > "$STATE_FILE"

STATE=$(<"$STATE_FILE")

CPU=$(bash "$CPU_SCRIPT")
FAN=$(bash "$FAN_SCRIPT")
TEMP=$(bash "$TEMP_SCRIPT")
WATT=$(bash "$WATT_SCRIPT")
CLOCKS=$(bash "$CLOCKS_SCRIPT" | grep -v '^$' | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')

case "$STATE" in
  fan)
    TEXT="$FAN"
    TOOLTIP=" $CPU\n$TEMP\n$WATT\n$CLOCKS"
    ;;
  temp)
    TEXT="$TEMP"
    TOOLTIP=" $CPU\n$FAN\n$WATT\n$CLOCKS"
    ;;
  watts)
    TEXT="$WATT"
    TOOLTIP=" $CPU\n$TEMP\n$FAN\n$CLOCKS"
    ;;
  usage|*)
    TEXT=" $CPU"
    TOOLTIP="$TEMP\n$WATT\n$FAN\n$CLOCKS"
    ;;
esac

echo "{\"text\": \"$TEXT\", \"tooltip\": \"$TOOLTIP\"}"
