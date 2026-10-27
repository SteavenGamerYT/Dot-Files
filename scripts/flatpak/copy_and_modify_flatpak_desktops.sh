#!/usr/bin/env bash

# Directories to search for .desktop files
desktop_dirs=(
    "/var/lib/flatpak/exports/share/applications/"
    "~/.local/share/flatpak/exports/share/applications/"
)

# Destination directory for copied .desktop files
destination_dir="$HOME/.local/share/applications"

# Environment variables to unset
env_vars=(
    "QT_QPA_PLATFORMTHEME"
    "QT_STYLE_OVERRIDE"
    "KVANTUM_THEME"
    "ICON_THEME"
    "QT_QPA_ICONTHEME"
    "GTK_THEME"
    "CURSOR_THEME"
    "QT_QT_CURSORTHEME"
    "QT_QT5_CURSORTHEME"
    "QT_QT6_CURSORTHEME"
    "XCURSOR_THEME"
    "CURSOR_SIZE"
    "XCURSOR_SIZE"
)

# Create destination directory if it doesn't exist
mkdir -p "$destination_dir"

for dir in "${desktop_dirs[@]}"; do
    # Expand tilde (~) in the directory path
    dir=$(eval echo "$dir")

    # Iterate through .desktop files
    for file in "$dir"/*.desktop; do
        if [ -f "$file" ]; then
            # Copy the .desktop file to the destination directory
            cp "$file" "$destination_dir/"
            
            # Get the file name
            file_name=$(basename "$file")
            
            # Modify the copied .desktop file
            # Extract the original Exec command
            original_exec=$(grep '^Exec=' "$destination_dir/$file_name" | cut -d'=' -f2-)
            
            # Prepend the unset environment variables to the Exec command
            new_exec="Exec=env $(printf '%s ' "${env_vars[@]/#/ -u }") $original_exec"
            
            # Replace the Exec line in the .desktop file
            sed -i "s|^Exec=.*|$new_exec|" "$destination_dir/$file_name"
        fi
    done
done