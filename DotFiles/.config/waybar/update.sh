#!/usr/bin/env bash

# Run topgrade inside kitty terminal
kitty --title "System Update - Topgrade" bash -c "
    echo '=== Running System Update (Topgrade) ==='
    topgrade
    exit_code=\$?
    echo
    if [ \$exit_code -eq 0 ]; then
        echo '=== System updated successfully! ==='
    else
        echo '=== Topgrade completed with code '\$exit_code' ==='
    fi
    pkill -RTMIN+8 waybar 2>/dev/null
    echo
    echo 'Press any key to close...'
    read -n 1 -s -r
"