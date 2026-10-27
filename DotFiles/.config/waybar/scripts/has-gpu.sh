#!/usr/bin/env bash

# Check AMD GPU
for drm_path in /sys/class/drm/card[0-9]*; do
    dev_path="$drm_path/device"
    if [[ -f "$dev_path/uevent" ]] && grep -q "DRIVER=amdgpu" "$dev_path/uevent"; then
        if [[ -f "$dev_path/mem_info_vram_total" ]]; then
            vram_bytes=$(cat "$dev_path/mem_info_vram_total" 2>/dev/null || echo 0)
            if (( vram_bytes > 2147483648 )); then
                exit 0
            fi
        else
            exit 0
        fi
    fi
done

# Check Nvidia GPU
if command -v nvidia-smi >/dev/null 2>&1 && nvidia-smi >/dev/null 2>&1; then
    exit 0
fi

exit 1
