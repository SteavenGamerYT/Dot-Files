#!/usr/bin/env bash

# Get current hostname
HOSTNAME=$(hostname)

# Check if hostname is valid
if [ "$HOSTNAME" != "Omar-PC" ] && [ "$HOSTNAME" != "Omar-GamingLaptop" ]; then
    echo "Invalid hostname: $HOSTNAME"
    echo "This script only supports Omar-PC, Omar-GamingLaptop"
    exit 1
fi

echo "Detected hostname: $HOSTNAME"

if [[ $HOSTNAME == "Omar-PC" ]]; then
    xrandr \
        --output HDMI-1 --mode 1920x1080 --pos 0x768 --rotate normal --primary --rate 60
    xrandr \
        --output HDMI-2 --mode 1366x768 --pos 0x0 --rotate normal --rate 60 \
        --output HDMI-1 --mode 1920x1080 --pos 0x768 --rotate normal --primary --rate 60

    input-remapper-control --command start --device "SINOWEALTH Wired Gaming Mouse" --preset "mouse extra buttons"
    systemctl --user restart audio
elif [[ $HOSTNAME == "Omar-GamingLaptop" ]]; then
    input-remapper-control --command start --device "Asus Keyboard" --preset "right arrow key is broken so i remapped keys"
fi

sleep 2
kill $(pidof redshift)

sleep 2
redshift -l 30.0444:31.2357
