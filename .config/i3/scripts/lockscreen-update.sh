#!/usr/bin/env bash

# Path to your wallpaper configuration file
CONFIG_FILE=~/.config/i3/wallpaper.conf

# Extract the wallpaper path from the config file
WALLPAPER_PATH=$(grep 'WALLPAPER_PATH' $CONFIG_FILE | cut -d '=' -f 2- | xargs)
# Temporary path for the blurred wallpaper
TEMP_WALLPAPER_PATH=~/.config/i3/blurred_wallpaper.jpg

# Check if the wallpaper path exists
if [ -f "$WALLPAPER_PATH" ]; then
    # Apply a blur effect to the wallpaper
    magick "$WALLPAPER_PATH" -blur 0x4 "$TEMP_WALLPAPER_PATH"

    # Update the lock screen wallpaper using betterlockscreen
    betterlockscreen -u "$TEMP_WALLPAPER_PATH"
else
    echo "Wallpaper file not found: $WALLPAPER_PATH"
    exit 1
fi
