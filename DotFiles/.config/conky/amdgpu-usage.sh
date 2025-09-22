#!/usr/bin/env bash

# Function to detect AMD GPU with gpu_busy_percent
detect_amd_gpu() {
    for drm_path in /sys/class/drm/card*; do
        if [[ -f "$drm_path/device/uevent" ]] && grep -q "DRIVER=amdgpu" "$drm_path/device/uevent"; then
            if [[ -f "$drm_path/device/gpu_busy_percent" ]]; then
                echo "$drm_path"
                return 0
            fi
        fi
    done
    return 1
}

# Detect GPU
GPU_PATH=$(detect_amd_gpu)
if [ -z "$GPU_PATH" ]; then
    echo "?"
    exit 1
fi

GPU_BUSY_FILE="$GPU_PATH/device/gpu_busy_percent"
gpu_usage=$(< "$GPU_BUSY_FILE")

# Parse sensors section for AMDGPU
gpu_section=$(sensors | awk '/^amdgpu/,/^$/')

gpu_edge=$(awk '/edge:/ {gsub(/\+|°C/, "", $2); print $2"°C"}' <<< "$gpu_section")
gpu_power=$(awk '/PPT:/ {print $2$3}' <<< "$gpu_section")   # no space, e.g. 9.00W
gpu_fan=$(awk '/fan1:/ {print int($2)$3}' <<< "$gpu_section") # e.g. 0RPM

# Subcommand handling
case "$1" in
    -usage)
        echo "${gpu_usage}%"
        ;;
    -temp)
        echo "${gpu_edge}"
        ;;
    -power)
        echo "${gpu_power}"
        ;;
    -fan)
        echo "${gpu_fan}"
        ;;
    -all|"")
        echo "${gpu_usage}% ${gpu_edge} ${gpu_power} ${gpu_fan}"
        ;;
    *)
        echo "Usage: $0 {-usage|-temp|-power|-fan|-all}"
        exit 1
        ;;
esac
