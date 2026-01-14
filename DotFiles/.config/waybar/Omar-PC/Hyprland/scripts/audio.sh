#!/usr/bin/env bash

# Define an array of sinks
sinks=(
    "alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo"
    "alsa_output.usb-XiiSound_Technology_Corporation_H848_USB_Gaming_Headset-00.iec958-stereo"
#    "alsa_output.pci-0000_03_00.1.pro-output-3"
#    "alsa_output.pci-0000_03_00.1.pro-output-7"
    "alsa_output.pci-0000_0a_00.6.analog-stereo"
)

# Get the current default sink
current_sink=$(pactl get-default-sink)

# Filter available sinks
available_sinks=()
for sink in "${sinks[@]}"; do
    if pactl list sinks short | grep -q "$sink"; then
        available_sinks+=("$sink")
    fi
done

# If no available sinks, exit
if [[ ${#available_sinks[@]} -eq 0 ]]; then
    echo "No available sinks found!"
    exit 1
fi

# Find the index of the current sink in the available sinks
index=-1
for i in "${!available_sinks[@]}"; do
    if [[ "${available_sinks[$i]}" == "$current_sink" ]]; then
        index=$i
        break
    fi
done

# Calculate the next sink index (cycling back to 0 if at the end)
next_index=$(( (index + 1) % ${#available_sinks[@]} ))

# Set the next sink as default
pactl set-default-sink "${available_sinks[$next_index]}"
