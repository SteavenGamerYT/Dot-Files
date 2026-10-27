#!/usr/bin/env bash

# Script to find AMD GPU and monitor its VRAM usage

# Function to detect AMD GPU
detect_amd_gpu() {
    local drm_path dev_path

    # Only inspect primary card nodes (card0, card1, etc.), skip connector sub-paths
    for drm_path in /sys/class/drm/card[0-9]*; do
        dev_path="$drm_path/device"

        # Check if driver is amdgpu
        if [[ -f "$dev_path/uevent" ]] && grep -q "DRIVER=amdgpu" "$dev_path/uevent"; then
            # Discrete AMD GPUs sit behind an external PCIe slot link and report max_link_width
            # If both report link widths, modern desktop Ryzen iGPUs use internal root buses (often x1/x2 or 0)
            # Alternatively, check if the device has dedicated VRAM (> 2GB / 2048MB):
            if [[ -f "$dev_path/mem_info_vram_total" ]]; then
                local vram_bytes
                vram_bytes=$(cat "$dev_path/mem_info_vram_total" 2>/dev/null || echo 0)

                # 2GB in bytes = 2147483648 (iGPUs typically default to 512MB-2GB dynamic system RAM allocation)
                # Dedicated cards (like RX 7600 XT with 16GB) will report full hardware VRAM
                if (( vram_bytes > 2147483648 )); then
                    echo "$drm_path"
                    return 0
                fi
            fi
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

# Monitor VRAM usage in GiB with decimal points
VRAM_USED=$(awk '{printf "%.2f", $1 / 1073741824}' "$VRAM_USED_FILE")
echo "${VRAM_USED} GiB"