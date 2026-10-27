#!/usr/bin/env bash
# Function to disable mouse acceleration
disable_mouse_acceleration() {
    local device_id
    device_id=$(xinput list --id-only "$1")
    if [ -n "$device_id" ]; then
        if xinput list-props "$device_id" | grep -q "libinput Accel Profile Enabled"; then
            xinput set-prop "$device_id" "libinput Accel Profile Enabled" 0, 1
        fi
        if xinput list-props "$device_id" | grep -q "libinput Accel Speed"; then
            xinput set-prop "$device_id" "libinput Accel Speed" 0
        fi
    fi
}

# Function to enable tapping and natural scrolling for touchpads
enable_touchpad_settings() {
    local device_id
    device_id=$(xinput list --id-only "$1")
    if [ -n "$device_id" ]; then
        if xinput list-props "$device_id" | grep -q "libinput Tapping Enabled"; then
            xinput set-prop "$device_id" "libinput Tapping Enabled" 1
        fi
        if xinput list-props "$device_id" | grep -q "libinput Natural Scrolling Enabled"; then
            xinput set-prop "$device_id" "libinput Natural Scrolling Enabled" 1
        fi
    fi
}

# Get the list of all input devices
devices=$(xinput list --name-only)

# Loop through each device and apply the appropriate settings
while IFS= read -r device; do
    if [[ "$device" == *"mouse"* || "$device" == *"Mouse"* ]]; then
        disable_mouse_acceleration "$device"
    elif [[ "$device" == *"touchpad"* || "$device" == *"Touchpad"* ]]; then
        enable_touchpad_settings "$device"
    fi
done <<< "$devices"
