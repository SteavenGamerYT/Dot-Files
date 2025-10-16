#!/usr/bin/env bash

# Get wallpaper path from config
WALLPAPER="$(grep '^WALLPAPER_PATH=' ~/.config/sway/wallpaper.conf | cut -d'=' -f2)"

# Run swaylock in daemon mode so it doesn't reset swayidle
swaylock --daemonize -f \
  -i "$WALLPAPER" \
  --effect-blur 7x5 \
  --line-color 181818 \
  --ring-color 222831 \
  --text-color B8C7D1 \
  --key-hl-color 4A80AA \
  --indicator-radius 50 \
  --grace 2 \
  --fade-in 0.2
