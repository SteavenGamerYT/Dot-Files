#!/usr/bin/env bash

# Script to find AMD GPU and monitor its usage

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

# Extract GPU busy percent path
GPU_BUSY_FILE="$GPU_PATH/device/gpu_busy_percent"

if [ ! -f "$GPU_BUSY_FILE" ]; then
    echo "gpu_busy_percent file not found!"
    exit 1
fi

# Show GPU busy percent and only display the value
command cat "$GPU_BUSY_FILE"
