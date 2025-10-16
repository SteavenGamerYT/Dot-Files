#!/usr/bin/env bash

# Get current hostname
HOSTNAME=$(hostname)

# Check if hostname is valid
if [ "$HOSTNAME" != "Omar-PC" ] && [ "$HOSTNAME" != "Omar-GamingLaptop" ] && [ "$HOSTNAME" != "Omar-Laptop" ] && [ "$HOSTNAME" != "Hany-Laptop" ]; then
    echo "Invalid hostname: $HOSTNAME"
    echo "This script only supports Omar-PC, Omar-GamingLaptop, Omar-Laptop, and Hany-Laptop"
    exit 1
fi

echo "Detected hostname: $HOSTNAME"

if [[ $HOSTNAME == "Omar-PC" ]]; then
    xrandr --output DP-1 --primary
    input-remapper-control --command start --device "SINOWEALTH Wired Gaming Mouse" --preset "mouse extra buttons"
    systemctl --user restart audio
elif [[ $HOSTNAME == "Omar-GamingLaptop" ]]; then
    input-remapper-control --command start --device "Asus Keyboard" --preset "right arrow key is broken so i remapped keys"
fi

sleep 2
kill $(pidof wlsunset)

sleep 2
wlsunset -l 30.0444 -L 31.2357
