#!/usr/bin/env bash
swaylock -i "$(grep '^WALLPAPER_PATH=' ~/.config/hypr/wallpaper.conf | cut -d'=' -f2)" \
  --effect-blur 7x5 \
  --line-color 4C566A \
  --ring-color 4C566A \
  --text-color ECEFF4 \
  --key-hl-color A3BE8C \
  --indicator-radius 50 \
#  --indicator-thickness 7 \
  --grace 2 \
  --fade-in 0.2