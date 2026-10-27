#!/usr/bin/env bash

# Check if battery directory exists (laptop mode)
if [ -d /sys/class/power_supply/BAT0 ]; then
    # Adjust display scaling for laptop screen
#    swaymsg output eDP-1 scale 1.25
    
    # Enable natural scroll for the touchpad
#    swaymsg input "1267:12410:ELAN1203:00_04F3:307A_Touchpad" natural_scroll enabled
    
    # Start input remapper for the keyboard with the specified preset
    input-remapper-control --command start --device "Asus Keyboard" --preset "right arrow key is broken so i remapped keys"

else
    # External monitor settings (desktop mode)
 #   swaymsg output "HDMI-A-2" mode 1366x768@59.79Hz pos 0 0 transform normal scale 1.0 scale_filter nearest adaptive_sync off dpms on
 #   swaymsg output "HDMI-A-1" mode 1920x1080@60.0Hz pos 0 768 transform normal scale 1.0 scale_filter nearest adaptive_sync off dpms on
 #   swaymsg output "HDMI-A-3" disable
    
    # Set HDMI-A-1 as primary monitor
    xrandr --output HDMI-A-1 --primary
    
    # Start input remapper for the mouse with the specified preset
    input-remapper-control --command start --device "SINOWEALTH Wired Gaming Mouse" --preset "mouse extra buttons"
fi
