#!/usr/bin/env bash

# Define UUIDs and labels
declare -A DRIVES=(
  ["a9a4ea8c-b44b-4126-b450-eadb6cd4efcd"]="2TB HDD"
  ["72992caa-c5b6-40f9-b4f6-1679a2510174"]="4TB HDD"
  ["2f47ccca-365a-4b47-999b-0f9a91dd8c0e"]="1TB HDD1"
)

for uuid in "${!DRIVES[@]}"; do
    label="${DRIVES[$uuid]}"
    partition_path=$(blkid -U "$uuid")

    if [[ -b "$partition_path" ]]; then
        # Remove partition number to get disk path (e.g., /dev/sdf1 → /dev/sdf)
        disk_path="/dev/$(basename "$partition_path" | sed 's/[0-9]*$//')"

        temp=$(sudo smartctl -A "$disk_path" | awk '/Temperature_Celsius|Temperature_Internal|Temperature/ {print $10; exit}')
        
        if [[ -n "$temp" ]]; then
            echo "$label ($disk_path): ${temp}°C"
        else
            echo "$label ($disk_path): Temperature not found"
        fi
    else
        echo "$label: Device not found for UUID $uuid"
    fi
done
