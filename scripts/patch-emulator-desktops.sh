#!/usr/bin/env bash

# List of .desktop files to copy and modify
FILES=(
  "rpcs3.desktop"
  "ryujinx.desktop"
  "duckstation.desktop"
  "info.cemu.Cemu.desktop"
  "pcsx2.desktop"
  "dolphin-emu.desktop"
  "dev.suyu_emu.suyu.desktop"
)

# Source and destination directories
SRC_DIR="/usr/share/applications"
DEST_DIR="$HOME/.local/share/applications"

# Step 1: Copy .desktop files
echo "Copying .desktop files..."
for file in "${FILES[@]}"; do
  src_file="$SRC_DIR/$file"
  dest_file="$DEST_DIR/$file"

  if [ -f "$src_file" ]; then
    cp "$src_file" "$dest_file"
    echo "Copied $src_file to $dest_file"
  else
    echo "Source file $src_file does not exist, skipping..."
  fi
done

# Step 2: Modify the Exec line in each copied .desktop file
echo "Modifying Exec lines..."
for file in "${FILES[@]}"; do
  desktop_file="$DEST_DIR/$file"

  # Check if the file exists
  if [ ! -f "$desktop_file" ]; then
    echo "File $desktop_file does not exist, skipping..."
    continue
  fi

  # Extract the current Exec line
  current_exec=$(grep '^Exec=' "$desktop_file" | sed 's|^Exec=||')

  # Skip files where the Exec line could not be found
  if [ -z "$current_exec" ]; then
    echo "No Exec line found in $desktop_file, skipping..."
    continue
  fi

  # Create the new Exec line
  new_exec="Exec=bash -c 'game-run $current_exec'"

  # Replace the old Exec line with the new one
  sed -i "s|^Exec=.*|$new_exec|" "$desktop_file"

  echo "Updated Exec line in $desktop_file"
done

echo "All tasks completed."