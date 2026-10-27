#!/usr/bin/env bash

# Get the laptop battery status
status=$(cat /sys/class/power_supply/BAT0/status)
percentage=$(cat /sys/class/power_supply/BAT0/capacity)

# Check the battery status and change the CPU frequency accordingly
if [[ $status == "Discharging" ]]; then
    echo 2200000 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
elif [[ $status == "Charging" ]]; then
    echo 3000000 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
elif [[ $status == "Full" ]]; then
    echo 3000000 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
else
    if [[ $percentage -lt 20 ]]; then
        echo 800 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
    fi
fi