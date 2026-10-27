#!/usr/bin/env bash

# Get current hostname
HOSTNAME=$(hostname)

# Kill all instances of polybar (if any)
kill $(pidof polybar)

if pgrep -x polybar > /dev/null; then
    syncthingtray --replace & disown
    exit
fi

# Check if hostname is valid
if [ "$HOSTNAME" != "Omar-PC" ] && [ "$HOSTNAME" != "Omar-GamingLaptop" ]; then
    echo "Invalid hostname: $HOSTNAME"
    echo "This script only supports Omar-PC, Omar-GamingLaptop"
    exit 1
fi

echo "Detected hostname: $HOSTNAME"

# Start polybar
polybar -c=~/.config/polybar/$HOSTNAME/config.ini steaven 2>&1 | tee -a /tmp/polybar.log & disown

# Wait a bit before starting other applications
sleep 5

# Start syncthingtray and ensure it runs in the background
syncthingtray --replace & disown