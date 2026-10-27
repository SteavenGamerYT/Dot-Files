#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Try AMD discrete GPU first
for drm_path in /sys/class/drm/card[0-9]*; do
    dev_path="$drm_path/device"
    if [[ -f "$dev_path/uevent" ]] && grep -q "DRIVER=amdgpu" "$dev_path/uevent"; then
        exec bash "$SCRIPT_DIR/amdgpu-vram-usage.sh"
    fi
done

# Try Nvidia GPU
if command -v nvidia-smi >/dev/null 2>&1; then
    exec bash "$SCRIPT_DIR/nvidia-vram-usage.sh"
fi

exit 1
