#!/usr/bin/env bash

# Find all image files in the specified directory
img=($(find ~/Pictures/SteavenGamerYT/ -type f -exec file {} \; | grep -oP '^.+: \w+ image' | cut -d':' -f1))

while true; do
  # Randomly select an image from the array
  selected_image="${img[RANDOM % ${#img[@]}]}"

  # Save the path of the current wallpaper to the configuration file
  echo "WALLPAPER_PATH=$selected_image" > ~/.config/hypr/wallpaper.conf

  # Set the selected image as the wallpaper using swaybg
  swaybg -m fill -i "$selected_image"

  # Wait for 10 minutes before changing the wallpaper
  sleep 10m
done
