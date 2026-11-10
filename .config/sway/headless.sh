#!/usr/bin/env bash
set -euo pipefail

OUTPUT="HEADLESS-1"
RESOLUTION="2340x1080@120Hz"

# Check whether the virtual output already exists
if ! swaymsg -t get_outputs -r | jq -e \
    --arg output "$OUTPUT" 'any(.[]; .name == $output)' >/dev/null; then
    swaymsg create_output
fi

# Wait for the virtual output to become available
for i in {1..30}; do
    if swaymsg -t get_outputs -r | jq -e \
        --arg output "$OUTPUT" 'any(.[]; .name == $output)' >/dev/null; then
        break
    fi
    sleep 0.2
done

# Ensure output exists
swaymsg -t get_outputs -r | jq -e \
    --arg output "$OUTPUT" 'any(.[]; .name == $output)' >/dev/null || {
        echo "ERROR: $OUTPUT was not created"
        exit 1
    }

# Configure virtual display
swaymsg "output $OUTPUT mode $RESOLUTION"
#swaymsg "output $OUTPUT position 3840 768"

# Move dedicated workspace to virtual display
swaymsg "workspace 9"
swaymsg "move workspace to output $OUTPUT"

echo "HEADLESS-1 ready: $RESOLUTION"
echo "Sunshine should capture: $OUTPUT"

systemctl --user restart app-dev.lizardbyte.app.Sunshine.service