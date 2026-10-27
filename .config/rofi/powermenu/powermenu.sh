#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5
## style-6   style-7   style-8   style-9   style-10

# Current Theme
dir="$HOME/.config/rofi/powermenu"
theme='style-1'

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"
host="hostname"

# Options
shutdown=''
reboot='󰜉'
lock=''
suspend=''
logout=''
yes='󰄴'
no=''

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "Uptime: $uptime" \
		-mesg "Uptime: $uptime" \
		-theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${dir}/${theme}.rasi
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			~/.config/rofi/powermenu/shutdown-sound.sh && systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			~/.config/rofi/powermenu/shutdown-sound.sh && systemctl reboot
		elif [[ $1 == '--suspend' ]]; then
			mpc -q pause
			amixer set Master mute
			~/.config/rofi/powermenu/shutdown-sound.sh && systemctl suspend
		elif [[ $1 == '--logout' ]]; then
			if [[ "$XDG_SESSION_DESKTOP" == "Openbox" ]]; then
				~/.config/rofi/powermenu/shutdown-sound.sh && openbox --exit
			elif [[ "$XDG_SESSION_DESKTOP" == "bspwm" ]]; then
				~/.config/rofi/powermenu/shutdown-sound.sh && bspc quit
			elif [[ "$XDG_SESSION_DESKTOP" == "i3" ]]; then
				~/.config/rofi/powermenu/shutdown-sound.sh && i3-msg exit
			elif [[ "$XDG_SESSION_DESKTOP" == "sway" ]]; then
				~/.config/rofi/powermenu/shutdown-sound.sh && swaymsg exit
			elif [[ "$XDG_SESSION_DESKTOP" == "Hyprland" ]]; then
				~/.config/rofi/powermenu/shutdown-sound.sh && hyprctl dispatch exit
			elif [[ "$XDG_SESSION_DESKTOP" == 'plasma' ]]; then
				~/.config/rofi/powermenu/shutdown-sound.sh && qdbus org.kde.ksmserver /KSMServer logout 0 0 0
			fi
		elif [[ $1 == '--lock' ]]; then
			if [[ "$XDG_SESSION_DESKTOP" == "i3" ]]; then
				~/.config/i3/scripts/lockscreen.sh
			elif [[ "$XDG_SESSION_DESKTOP" == "sway" ]]; then
				~/.config/sway/scripts/lockscreen.sh
			elif [[ "$XDG_SESSION_DESKTOP" == "Hyprland" ]]; then
				~/.config/hypr/scripts/lockscreen.sh
			fi
		else
			echo "Invalid option: $1"
			exit 1
		fi
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $lock)
		run_cmd --lock
        ;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac
