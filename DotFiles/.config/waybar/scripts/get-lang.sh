#!/usr/bin/env bash

# Hyprland detection
if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    lang=$(hyprctl devices -j 2>/dev/null | jq -r '.keyboards[] | .active_keymap' 2>/dev/null | sed -n '6p' | cut -c1-2 | tr 'A-Z' 'a-z')
    if [ -n "$lang" ]; then
        echo "$lang"
        exit 0
    fi
fi

# Sway / wlroots detection
if [ -n "$SWAYSOCK" ] || command -v swaymsg >/dev/null 2>&1; then
    swaymsg -t get_inputs 2>/dev/null | jq -r '.[] | select(.type == "keyboard") | .xkb_active_layout_name' 2>/dev/null | \
    awk '{print tolower($0)}' | \
    grep -oE '[a-z]{2,}' | \
    sort | uniq | head -n 1 | \
    awk '
        BEGIN {
            map["english"] = "us";
            map["arabic"] = "eg";
        }
        {
            lang = tolower($0);
            if (lang in map) {
                print map[lang];
            } else {
                print lang;
            }
        }
    '
    exit 0
fi