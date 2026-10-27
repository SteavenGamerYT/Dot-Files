#!/usr/bin/env bash

# Get wallpaper path from config
WALLPAPER="$(grep '^WALLPAPER_PATH=' ~/.config/sway/wallpaper.conf | cut -d'=' -f2)"

# Run swaylock in daemon mode so it doesn't reset swayidle
swaylock --daemonize -f \
  -i "$WALLPAPER" \
  --effect-blur 7x5 \
  --line-color 4C566A \
  --ring-color 4C566A \
  --text-color ECEFF4 \
  --key-hl-color A3BE8C \
  --indicator-radius 50 \
  --grace 2 \
  --fade-in 0.2
