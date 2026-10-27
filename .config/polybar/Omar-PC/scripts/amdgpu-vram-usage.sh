#!/usr/bin/env bash

# Script to find AMD GPU and monitor its VRAM usage

# Function to detect AMD GPU
detect_amd_gpu() {
    for drm_path in /sys/class/drm/*; do
        if [[ -f "$drm_path/device/uevent" ]] && grep -q "DRIVER=amdgpu" "$drm_path/device/uevent"; then
            echo "$drm_path"
            return 0
        fi
    done
    return 1
}

# Find AMD GPU path dynamically
GPU_PATH=$(detect_amd_gpu)

if [ -z "$GPU_PATH" ]; then
    echo "No AMD GPU detected!"
    exit 1
fi

# Extract VRAM usage paths
VRAM_USED_FILE="$GPU_PATH/device/mem_info_vram_used"

# Check if file exists
if [[ ! -f "$VRAM_USED_FILE" ]]; then
    echo "VRAM usage file not found! Ensure amdgpu driver is loaded."
    exit 1
fi

# Monitor VRAM usage in MB
VRAM_USED=$(($(cat "$VRAM_USED_FILE") / 1048576))   # Convert to MB
echo "${VRAM_USED}MB"