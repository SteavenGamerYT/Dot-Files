#!/usr/bin/env bash

# Get wallpaper path from config
WALLPAPER="$(grep '^WALLPAPER_PATH=' ~/.config/sway/wallpaper.conf | cut -d'=' -f2)"

# Run swaylock in daemon mode so it doesn't reset swayidle
swaylock --daemonize -f \
  -i "$WALLPAPER" \
  --effect-blur 7x5 \
  --line-color 5A3F42 \
  --ring-color 5A3F42 \
  --text-color F5F5F5 \
  --key-hl-color C06C84 \
  --indicator-radius 50 \
  --grace 2 \
  --fade-in 0.2
