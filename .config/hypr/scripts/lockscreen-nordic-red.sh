#!/usr/bin/env bash
swaylock -i "$(grep '^WALLPAPER_PATH=' ~/.config/hypr/wallpaper.conf | cut -d'=' -f2)" \
  --effect-blur 7x5 \
  --line-color 5A3F42 \
  --ring-color 5A3F42 \
  --text-color F5F5F5 \
  --key-hl-color C06C84 \
  --indicator-radius 50 \
  --grace 2 \
  --fade-in 0.2
