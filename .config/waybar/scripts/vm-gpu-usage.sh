#!/usr/bin/env bash

# Remote machine details
USER="omarhanykasban"
IP="192.168.1.15"
PASSWORD="omargamer1234"  # Strongly recommend using SSH keys instead

# GPU scripts directory (Windows-style path)
BASE_PS1_PATH='C:\Users\Omar Hany Kasban\Documents\GitHub\Dot-Files-Windows\Scripts\Nvidia'

# Function to run remote PowerShell scripts safely
run_gpu_script() {
    local script_name="$1"
    # Add timeout and proper error handling
    sshpass -p "$PASSWORD" ssh -o ConnectTimeout=5 -x "$USER@$IP" \
        pwsh -NoProfile -Command "\"& '$BASE_PS1_PATH\\$script_name' 2>&1\"" \
        | grep -v "Connection to $IP closed" \
        | tr -d '\r'  # Remove Windows carriage returns
}

# Fetch GPU stats with fallback values
gpu_usage=$(run_gpu_script "nvidia-gpu-usage.ps1" | grep -Eo '[0-9]+' || echo "?")
gpu_temp=$(run_gpu_script "nvidia-gpu-temp.ps1" | grep -Eo '[0-9]+' || echo "?")
gpu_power=$(run_gpu_script "nvidia-gpu-watts.ps1" | grep -Eo '[0-9.]+' || echo "?")
gpu_mem=$(run_gpu_script "nvidia-gpu-vram-usage.ps1" || echo "?")
gpu_fan=$(run_gpu_script "nvidia-gpu-fan.ps1" | grep -Eo '[0-9]+' || echo "N/A")

# Validate GPU usage value
if [[ ! "$gpu_usage" =~ ^[0-9]+$ ]] || (( gpu_usage > 100 )); then
    gpu_usage="?"
fi

# Generate Waybar output
tooltip=$(printf "󰔐 Temp: %s°C\n󰍶 VRAM: %s\n󰚥 Power: %s W\n󰈐 Fan: %s%%" \
    "$gpu_temp" "$gpu_mem" "$gpu_power" "$gpu_fan" | jq -Rs .)

echo "{\"text\": \"󰍹 ${gpu_usage}%\", \"tooltip\": ${tooltip}}"
