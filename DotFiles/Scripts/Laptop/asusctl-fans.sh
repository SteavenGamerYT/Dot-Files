#!/bin/bash

# Define your quiet 8-point fan curve
FAN_CURVE="0c:10%,35c:15%,45c:25%,55c:40%,65c:60%,75c:85%,90c:100%,95c:100%"

# List of profiles to apply the curve
PROFILES=("LowPower" "Balanced" "Performance")

# List of fans
FANS=("cpu" "gpu")

# Apply the fan curve to all profiles and fans
for profile in "${PROFILES[@]}"; do
    echo "Applying fan curve to profile: $profile"
    for fan in "${FANS[@]}"; do
        # Set fan curve
        asusctl fan-curve --mod-profile "$profile" -f "$fan" -D "$FAN_CURVE"
    done
    # Enable fan curves for the profile
    asusctl fan-curve --mod-profile "$profile" --enable-fan-curves true
done

echo "All profiles updated with quiet fan curve."
