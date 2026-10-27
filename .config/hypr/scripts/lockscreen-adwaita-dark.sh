#!/usr/bin/env bash
swaylock -i "$(grep '^WALLPAPER_PATH=' ~/.config/hypr/wallpaper.conf | cut -d'=' -f2)" \
  --effect-blur 7x5 \
  --line-color 181818 \
  --ring-color 222831 \
  --text-color B8C7D1 \
  --key-hl-color 4A80AA \
  --indicator-radius 50 \
#  --indicator-thickness 7 \
  --grace 2 \
  --fade-in 0.2