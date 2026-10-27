#!/usr/bin/env bash

# List of UUIDs for the HDDs
UUIDS=(
  "2f47ccca-365a-4b47-999b-0f9a91dd8c0e"
  "a9a4ea8c-b44b-4126-b450-eadb6cd4efcd"
  "72992caa-c5b6-40f9-b4f6-1679a2510174"
)

declare -A DEFRAG_CANDIDATES

check_fragmentation() {
  local uuid="$1"

  device=$(blkid -U "$uuid")
  if [[ -z "$device" ]]; then
    echo "Device with UUID $uuid not found."
    return
  fi

  fstype=$(blkid -o value -s TYPE "$device")
  if [[ "$fstype" != "ext4" ]]; then
    echo "$device is not ext4. Skipping."
    return
  fi

  echo "Checking fragmentation on $device ..."

  output=$(sudo e4defrag -c "$device" 2>/dev/null)
  score=$(echo "$output" | grep "Fragmentation score" | sed 's/[^0-9]*\([0-9]\+\).*/\1/')

  if [[ "$score" =~ ^[0-9]+$ ]]; then
    if (( score >= 56 )); then
      echo "$device needs defragmentation. (Score: $score)"
      DEFRAG_CANDIDATES["$device"]="$score"
    else
      echo "$device is fine. (Score: $score)"
    fi
  else
    echo "$device: Could not determine fragmentation score. Skipping."
  fi
}

# Phase 1: Check all devices
for uuid in "${UUIDS[@]}"; do
  check_fragmentation "$uuid"
done

# Phase 2: Ask for defragmentation
for device in "${!DEFRAG_CANDIDATES[@]}"; do
  score=${DEFRAG_CANDIDATES["$device"]}
  read -rp "Defragment $device? (Score: $score) [y/N]: " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "Defragmenting $device ..."
    sudo e4defrag -v "$device"
    echo
  else
    echo "Skipped defragmentation for $device."
    echo
  fi
done
