#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

dir="~/.config/polybar/scripts/rofi"

rofi_command="rofi -no-config -theme $dir/settings.rasi"

# Options
settings="󰌢 System"

# Confirmation
confirm_exit() {
	rofi -dmenu\
        -no-config\
		-i\
		-no-fixed-num-lines\
		-p "Are You Sure? : "\
		-theme $dir/confirm.rasi
}

confirm_mirror_audio() {
	rofi -dmenu\
        -no-config\
		-i\
		-no-fixed-num-lines\
		-p "Are You Sure? This will close easy effects : "\
		-theme $dir/confirm2.rasi
}

confirm_normal_audio() {
	rofi -dmenu\
        -no-config\
		-i\
		-no-fixed-num-lines\
		-p "Are You Sure? This will start easy effects : "\
		-theme $dir/confirm2.rasi
}

# Message
msg() {
	rofi -no-config -theme "$dir/message.rasi" -e "Available Options  -  yes / y / no / n"
}

# Variable passed to rofi
options="$settings"

chosen="$(echo -e "$options" | $rofi_command -p "Select Setting" -dmenu -selected-row 0)"
case $chosen in
    $settings)
        chosen_setting="$(echo -e "󰍹 Display Settings\n Audio Settings" | $rofi_command -p "Select Setting" -dmenu -selected-row 0)"
        case $chosen_setting in
            "󰍹 Display Settings")
                display_option="$(echo -e "Display Settings (App)\nMirror Displays\nExtend Displays" | $rofi_command -p "Display Options" -dmenu -selected-row 0)"
                case $display_option in
                    "Display Settings (App)")
                        if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
                            wdisplays
                        elif [[ $XDG_SESSION_TYPE == "x11" ]]; then
                            arandr
                        fi
                        ;;
                    "Mirror Displays")
                        if [[ $DESKTOP_SESSION == "hyprland" ]]; then
                            hyprctl keyword monitor "DP-1,1920x1080@60,0x0,1" && hyprctl keyword monitor "HDMI-A-1,1920x1080@60,0x0,1,mirror,DP-1"
                        elif [[ $DESKTOP_SESSION == "i3" ]]; then
                            xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-0 --off --output DP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal && ~/.config/polybar/launch.sh
                        elif [[ $XDG_SESSION_TYPE == "x11" ]]; then
                            xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-0 --off --output DP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
                        fi
                        ;;
                    "Extend Displays")
                        if [[ $DESKTOP_SESSION == "hyprland" ]]; then
                            hyprctl keyword monitor "DP-1,1920x1080@60,0x768,1" && hyprctl keyword monitor "HDMI-A-1,1366x768@60,0x0,1"
                        elif [[ $DESKTOP_SESSION == "i3" ]]; then
                            xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1366x768 --pos 0x0 --rotate normal --output DP-0 --off --output DP-1 --primary --mode 1920x1080 --pos 0x768 --rotate normal  && ~/.config/polybar/launch.sh
                        elif [[ $XDG_SESSION_TYPE == "x11" ]]; then
                            xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1366x768 --pos 0x0 --rotate normal --output DP-0 --off --output DP-1 --primary --mode 1920x1080 --pos 0x768 --rotate normal
                        fi
                        ;;
                esac
                ;;
            " Audio Settings")
                display_option="$(echo -e "Audio Settings (App)\nMirror Audio\nNormal Audio" | $rofi_command -p "Audio Options" -dmenu -selected-row 0)"
                case $display_option in
                    "Audio Settings (App)"):
                        pavucontrol
                        ;;
                    "Mirror Audio"):
                        ans=$(confirm_mirror_audio &)
                        if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
                            flatpak run com.github.wwmm.easyeffects -q
                            pactl load-module module-combine-sink
                        fi
                        ;;
                    "Normal Audio"):
                        ans=$(confirm_normal_audio &)
                        if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
                            pactl unload-module module-combine-sink
                            flatpak run com.github.wwmm.easyeffects --gapplication-service &
                        fi
                        ;;
                esac
                ;;
        esac
        exit 0
        ;;
esac