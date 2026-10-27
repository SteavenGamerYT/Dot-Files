#!/usr/bin/env bash
sed -i 's/^\(\s*\)export ICON_THEME=.*/\1export ICON_THEME=Papirus-Dark/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)export QT_QPA_ICONTHEME=.*/\1export QT_QPA_ICONTHEME=Papirus-Dark/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)export CURSOR_THEME=.*/\1export CURSOR_THEME=WhiteSur-cursors/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)export QT_QT_CURSORTHEME=.*/\1export QT_QT_CURSORTHEME=WhiteSur-cursors/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)export QT_QT5_CURSORTHEME=.*/\1export QT_QT5_CURSORTHEME=WhiteSur-cursors/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)export QT_QT6_CURSORTHEME=.*/\1export QT_QT6_CURSORTHEME=WhiteSur-cursors/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)export XCURSOR_THEME=.*/\1export XCURSOR_THEME=WhiteSur-cursors/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)export CURSOR_THEME=.*/\1export CURSOR_THEME=WhiteSur-cursors/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)export GTK_THEME=.*/\1export GTK_THEME=Nordic/' ~/DotFiles/.profile
sed -i 's|\(gtk-theme-name="\)[^"]*|\1Nordic|' ~/DotFiles/.config/gtk-2.0/gtkrc
sed -i 's|\(gtk-cursor-theme-name="\)[^"]*|\1WhiteSur-cursors|' ~/DotFiles/.config/gtk-2.0/gtkrc
sed -i 's|\(gtk-icon-theme-name="\)[^"]*|\1Papirus-Dark|' ~/DotFiles/.config/gtk-2.0/gtkrc
sed -i 's|\(gtk-theme-name=\).*|\1Nordic|' ~/DotFiles/.config/gtk-3.0/settings.ini
sed -i 's|\(gtk-cursor-theme-name=\).*|\1WhiteSur-cursors|' ~/DotFiles/.config/gtk-3.0/settings.ini
sed -i 's|\(gtk-icon-theme-name=\).*|\1Papirus-Dark|' ~/DotFiles/.config/gtk-3.0/settings.ini
sed -i 's|\(gtk-theme-name=\).*|\1Nordic|' ~/DotFiles/.config/gtk-4.0/settings.ini
sed -i 's|\(gtk-cursor-theme-name=\).*|\1WhiteSur-cursors|' ~/DotFiles/.config/gtk-4.0/settings.ini
sed -i 's|\(gtk-icon-theme-name=\).*|\1Papirus-Dark|' ~/DotFiles/.config/gtk-4.0/settings.ini
sed -i 's/^\(\s*\)export KVANTUM_THEME=.*/\1export KVANTUM_THEME=Nordic-solid/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)theme=.*/\1theme=Nordic-Solid/' ~/DotFiles/.config/Kvantum/kvantum.kvconfig
sed -i 's|\(cursorTheme=\).*|\1WhiteSur-cursors|' ~/.config/kcminputrc
sed -i 's|\(cursorTheme=\).*|\1WhiteSur-cursors|' ~/.config/kdedefaults/kcminputrc
sed -i 's|\(widgetStyle=\).*|\1kvantum|' ~/.config/kdedefaults/kdeglobals
sed -i 's|\(ColorScheme=\).*|\1Nordic|' ~/.config/kdedefaults/kdeglobals
sed -i 's|\(Theme=\).*|\1Papirus-Dark|' ~/.config/kdedefaults/kdeglobals
sed -i 's|\(widgetStyle=\).*|\1kvantum|' ~/.config/kdeglobals
sed -i 's|\(ColorScheme=\).*|\1Nordic|' ~/.config/kdeglobals
sed -i 's|\(Theme=\).*|\1Papirus-Dark|' ~/.config/kdeglobals
sed -i 's|\(Net/ThemeName "\)[^"]*|\1Nordic|' ~/.config/xsettingsd/xsettingsd.conf
sed -i 's|\(Gtk/CursorThemeName "\)[^"]*|\1WhiteSur-cursors|' ~/.config/xsettingsd/xsettingsd.conf
sed -i 's|\(Net/IconThemeName "\)[^"]*|\1Papirus-Dark|' ~/.config/xsettingsd/xsettingsd.conf
sed -i 's|\(name=\).*|\1Nordic|' ~/.config/kdedefaults/plasmarc
sed -i 's|\(^\s*source = ~/.config/hypr/config/theme-\)[^/]*|\1Nordic.conf|' ~/DotFiles/.config/hypr/hyprland.conf
sed -i 's|^include *= *~/.config/sway/configs/theme-[^[:space:]]*|include = ~/.config/sway/configs/theme-Nordic|' ~/.config/sway/config
sed -i 's/^\(\s*\)icon-theme: ".*/\1icon-theme: "Papirus-Dark";/' ~/DotFiles/.config/rofi/config.rasi
sed -i 's|\(@import "~/.config/rofi/colors/\)[^"]*|\1nord.rasi|' ~/DotFiles/.config/rofi/launcher/shared/colors.rasi
sed -i 's|\(@import "~/.config/rofi/colors/\)[^"]*|\1nord.rasi|' ~/DotFiles/.config/rofi/powermenu/shared/colors.rasi
sed -i 's|\(include ./\)[^ ]*|\1nord.conf|' ~/DotFiles/.config/kitty/kitty.conf
cp ~/DotFiles/.config/waybar/style-nordic.css ~/DotFiles/.config/waybar/style.css
cp ~/DotFiles/.config/swaync/style-nordic.css ~/DotFiles/.config/swaync/style.css
cp ~/DotFiles/.config/rofi/clipboard-nord.rasi ~/DotFiles/.config/rofi/clipboard.rasi
cp ~/DotFiles/.config/hypr/scripts/lockscreen-nordic.sh ~/DotFiles/.config/hypr/scripts/lockscreen.sh
cp ~/DotFiles/.config/sway/scripts/lockscreen-nordic.sh ~/DotFiles/.config/sway/scripts/lockscreen.sh
hyprctl setcursor WhiteSur-cursors 24
gsettings set org.gnome.desktop.interface gtk-theme 'Nordic'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'WhiteSur-cursors'
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface font-name 'Roboto Regular 12'
hyprctl reload
swaymsg reload