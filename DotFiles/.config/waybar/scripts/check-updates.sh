#!/usr/bin/env bash

pacman_updates=""
aur_updates=""
flatpak_updates=""

# 1. Official Arch Pacman updates
if command -v checkupdates >/dev/null 2>&1; then
    pacman_updates=$(checkupdates 2>/dev/null)
fi

# 2. AUR updates (paru or yay)
if command -v paru >/dev/null 2>&1; then
    aur_updates=$(paru -Qua 2>/dev/null)
elif command -v yay >/dev/null 2>&1; then
    aur_updates=$(yay -Qua 2>/dev/null)
fi

# 3. Flatpak updates (system & user)
if command -v flatpak >/dev/null 2>&1; then
    flatpak_updates=$( (flatpak remote-ls --cached --updates --columns=name,version 2>/dev/null; flatpak remote-ls --user --cached --updates --columns=name,version 2>/dev/null) | sed '/^\s*$/d' )
fi

# Counts
pacman_count=0
[ -n "$pacman_updates" ] && pacman_count=$(echo "$pacman_updates" | sed '/^\s*$/d' | wc -l)

aur_count=0
[ -n "$aur_updates" ] && aur_count=$(echo "$aur_updates" | sed '/^\s*$/d' | wc -l)

flatpak_count=0
[ -n "$flatpak_updates" ] && flatpak_count=$(echo "$flatpak_updates" | sed '/^\s*$/d' | wc -l)

total=$(( pacman_count + aur_count + flatpak_count ))

# Build tooltip
tooltip_lines=()

if [ $pacman_count -gt 0 ]; then
    tooltip_lines+=("📦 Pacman ($pacman_count):")
    while IFS= read -r line; do
        [ -n "$line" ] && tooltip_lines+=("  $line")
    done <<< "$pacman_updates"
fi

if [ $aur_count -gt 0 ]; then
    [ ${#tooltip_lines[@]} -gt 0 ] && tooltip_lines+=("")
    tooltip_lines+=("󰣇 AUR ($aur_count):")
    while IFS= read -r line; do
        [ -n "$line" ] && tooltip_lines+=("  $line")
    done <<< "$aur_updates"
fi

if [ $flatpak_count -gt 0 ]; then
    [ ${#tooltip_lines[@]} -gt 0 ] && tooltip_lines+=("")
    tooltip_lines+=("󰏓 Flatpak ($flatpak_count):")
    while IFS= read -r line; do
        [ -n "$line" ] && tooltip_lines+=("  $line")
    done <<< "$flatpak_updates"
fi

if [ $total -eq 0 ]; then
    tooltip="System is up to date\nAll packages, AUR, and Flatpaks are current."
    tooltip_json=$(printf "%b" "$tooltip" | jq -Rs .)
    echo "{\"text\": \"0\", \"tooltip\": $tooltip_json, \"class\": \"up-to-date\"}"
else
    tooltip=$(printf "%s\n" "${tooltip_lines[@]}" | jq -Rs .)
    echo "{\"text\": \"$total\", \"tooltip\": $tooltip, \"class\": \"has-updates\"}"
fi
