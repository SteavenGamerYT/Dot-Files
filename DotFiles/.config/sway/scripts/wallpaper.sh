#!/usr/bin/env bash

# Create an array of image paths safely
mapfile -t img < <(find "/home/omarhanykasban/Pictures/Pikachu" -type f -exec file --mime-type {} + | awk -F: '$2 ~ /image\// {print $1}')

while true; do
  # Pick a random image
  selected_image="${img[RANDOM % ${#img[@]}]}"

  # Save the wallpaper path
  echo "WALLPAPER_PATH=$selected_image" > ~/.config/sway/wallpaper.conf

  # Get the current swaybg PID (if any)
  swaybg_pid=$(pgrep -x swaybg)

  # If swaybg is not running, start it
  if [[ -z "$swaybg_pid" ]]; then
    swaybg -m fill -i "$selected_image" &
  else
    # If it's running, restart with the new image
    kill "$swaybg_pid"
    swaybg -m fill -i "$selected_image" &
  fi

  # Wait 10 minutes
  sleep 600
done
