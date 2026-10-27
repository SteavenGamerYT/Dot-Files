#!/usr/bin/env bash

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

# Detect GPU
GPU_PATH=$(detect_amd_gpu)
if [ -z "$GPU_PATH" ]; then
    echo '{"text": "󰍹 ?", "tooltip": "󰍹 No AMD GPU found"}'
    exit 0
fi

# GPU usage
GPU_BUSY_FILE="$GPU_PATH/device/gpu_busy_percent"
[ ! -f "$GPU_BUSY_FILE" ] && echo '{"text": "󰍹 ?", "tooltip": "󰍹 gpu_busy_percent missing"}' && exit 0
gpu_usage=$(< "$GPU_BUSY_FILE")

# Detect discrete AMDGPU block (the one with junction temp, excluding iGPU)
gpu_section=$(sensors | awk -v RS= '/^amdgpu/ && /junction:/')

# Extract data
gpu_edge=$(awk '/edge:/ {gsub(/[^0-9.]/, "", $2); print int($2)}' <<< "$gpu_section")
gpu_junction=$(awk '/junction:/ {gsub(/[^0-9.]/, "", $2); print int($2)}' <<< "$gpu_section")
gpu_mem=$(awk '/mem:/ {gsub(/[^0-9.]/, "", $2); print int($2)}' <<< "$gpu_section")
gpu_power=$(awk '/PPT:/ {print int($2) " W"}' <<< "$gpu_section")
gpu_fan=$(awk '/fan1:/ {print int($2) " " $3}' <<< "$gpu_section")

# Fallbacks
gpu_edge=${gpu_edge:-"?"}
gpu_junction=${gpu_junction:-"?"}
gpu_mem=${gpu_mem:-"?"}
gpu_power=${gpu_power:-"?"}
gpu_fan=${gpu_fan:-"N/A"}

# Tooltip with icons:
# 󰔐 temp • 󰍶 mem • 󰚥 power • 󰈐 fan
tooltip=$(printf "󰔐 Edge: %s°C\n󰔐 Junction: %s°C\n󰍶 VRAM: %s°C\n󰚥 Power: %s\n󰈐 Fan: %s" \
  "$gpu_edge" "$gpu_junction" "$gpu_mem" "$gpu_power" "$gpu_fan" | jq -Rs .)

# Final output
echo "{\"text\": \"󰍹 ${gpu_usage}%\", \"tooltip\": ${tooltip}}"
