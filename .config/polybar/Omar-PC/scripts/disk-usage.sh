#!/usr/bin/env bash

# Array of mount points to monitor
mount_points=(
    "/mnt/hdd"
    "/mnt/hdd2"
    "/mnt/hdd3"
    "/mnt/nvme"
    "/home"
    "/"
)

# Initialize total storage variable
total_storage_gb=0

# Loop through each mount point
for mount_point in "${mount_points[@]}"; do
    # Get disk usage in GB for the current mount point
    usage_gb=$(df -BG "$mount_point" | awk 'NR==2 {print $4}' | sed 's/G//')
    
    # Add usage to total storage
    total_storage_gb=$((total_storage_gb + usage_gb))
done

# Print total storage left
echo "$total_storage_gb GB"
