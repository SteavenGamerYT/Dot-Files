#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
keyboard_lang=$(bash "$SCRIPT_DIR/get-lang.sh")

if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    if [ "$keyboard_lang" = "en" ] || [ "$keyboard_lang" = "us" ]; then
        hyprctl keyword input:kb_layout ara,us
        hyprctl keyword input:kb_options grp:alt_shift_toggle
    elif [ "$keyboard_lang" = "ar" ] || [ "$keyboard_lang" = "eg" ]; then
        hyprctl keyword input:kb_layout us,ara
        hyprctl keyword input:kb_options grp:alt_shift_toggle
    else
        echo "Unknown keyboard language: $keyboard_lang"
    fi
elif [ -n "$SWAYSOCK" ] || command -v swaymsg >/dev/null 2>&1; then
    if [ "$keyboard_lang" = "us" ] || [ "$keyboard_lang" = "en" ]; then
        swaymsg input type:keyboard xkb_layout "eg,us"
        swaymsg input type:keyboard xkb_options "grp:alt_shift_toggle"
        swaymsg input type:keyboard xkb_numlock enabled
    elif [ "$keyboard_lang" = "eg" ] || [ "$keyboard_lang" = "ar" ]; then
        swaymsg input type:keyboard xkb_layout "us,eg"
        swaymsg input type:keyboard xkb_options "grp:alt_shift_toggle"
        swaymsg input type:keyboard xkb_numlock enabled
    else
        echo "Unknown keyboard language: $keyboard_lang"
    fi
fi