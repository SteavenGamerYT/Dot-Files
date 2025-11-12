#!/usr/bin/env bash

mount_points=(
    "/mnt/hdd"
    "/mnt/hdd2"
    "/mnt/hdd3"
    "/mnt/hdd4"
    "/mnt/nvme"
    "/home"
    "/"
)

total_storage_gb=0
tooltip_lines=()

for mount_point in "${mount_points[@]}"; do
    [ -e "$mount_point" ] || continue

    usage_line=$(df -h "$mount_point" 2>/dev/null | awk 'NR==2')
    [ -n "$usage_line" ] || continue

    free=$(echo "$usage_line" | awk '{print $4}')
    point=$(echo "$usage_line" | awk '{print $6}')
    free_num=$(df -BG "$mount_point" 2>/dev/null | awk 'NR==2 {gsub("G","",$4); print $4}')

    [[ "$free_num" =~ ^[0-9]+$ ]] || continue

    total_storage_gb=$((total_storage_gb + free_num))
    tooltip_lines+=("$point → $free")
done

# Get fan RPM
#fan_rpm=$(sensors -u it8665-isa-0290 2>/dev/null | awk '/fan3_input:/ {print int($2) " RPM"}')
#if [ -n "$fan_rpm" ]; then
#    tooltip_lines+=("Samsung SSD 990 PRO 4TB Fan → $fan_rpm")
#fi

# Format tooltip as single string for JSON
tooltip=$(printf "%s\n" "${tooltip_lines[@]}" | jq -Rs .)
text="${total_storage_gb} GB"

echo "{\"text\": \"$text\", \"tooltip\": $tooltip}"
