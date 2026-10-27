#!/usr/bin/env bash
sed -i 's/^\(\s*\)export ICON_THEME=.*/\1export ICON_THEME=Fluent-dark/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)export QT_QPA_ICONTHEME=.*/\1export QT_QPA_ICONTHEME=Fluent-dark/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)export CURSOR_THEME=.*/\1export CURSOR_THEME=Fluent-cursors/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)export QT_QT_CURSORTHEME=.*/\1export QT_QT_CURSORTHEME=Fluent-cursors/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)export QT_QT5_CURSORTHEME=.*/\1export QT_QT5_CURSORTHEME=Fluent-cursors/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)export QT_QT6_CURSORTHEME=.*/\1export QT_QT6_CURSORTHEME=Fluent-cursors/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)export XCURSOR_THEME=.*/\1export XCURSOR_THEME=Fluent-cursors/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)export CURSOR_THEME=.*/\1export CURSOR_THEME=Fluent-cursors/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)export GTK_THEME=.*/\1export GTK_THEME=Fluent-Dark/' ~/DotFiles/.profile
sed -i 's|\(gtk-theme-name="\)[^"]*|\1Fluent-Dark|' ~/DotFiles/.config/gtk-2.0/gtkrc
sed -i 's|\(gtk-cursor-theme-name="\)[^"]*|\1Fluent-cursors|' ~/DotFiles/.config/gtk-2.0/gtkrc
sed -i 's|\(gtk-icon-theme-name="\)[^"]*|\1Fluent-dark|' ~/DotFiles/.config/gtk-2.0/gtkrc
sed -i 's|\(gtk-theme-name=\).*|\1Fluent-Dark|' ~/DotFiles/.config/gtk-3.0/settings.ini
sed -i 's|\(gtk-cursor-theme-name=\).*|\1Fluent-cursors|' ~/DotFiles/.config/gtk-3.0/settings.ini
sed -i 's|\(gtk-icon-theme-name=\).*|\1Fluent-dark|' ~/DotFiles/.config/gtk-3.0/settings.ini
sed -i 's|\(gtk-theme-name=\).*|\1Fluent-Dark|' ~/DotFiles/.config/gtk-4.0/settings.ini
sed -i 's|\(gtk-cursor-theme-name=\).*|\1Fluent-cursors|' ~/DotFiles/.config/gtk-4.0/settings.ini
sed -i 's|\(gtk-icon-theme-name=\).*|\1Fluent-dark|' ~/DotFiles/.config/gtk-4.0/settings.ini
sed -i 's/^\(\s*\)export KVANTUM_THEME=.*/\1export KVANTUM_THEME=FluentDark/' ~/DotFiles/.profile
sed -i 's/^\(\s*\)theme=.*/\1theme=FluentDark/' ~/DotFiles/.config/Kvantum/kvantum.kvconfig
sed -i 's|\(^\s*source = ~/.config/hypr/config/theme-\)[^/]*|\1Fluent-dark.conf|' ~/DotFiles/.config/hypr/hyprland.conf
sed -i 's|\(cursorTheme=\).*|\1Fluent-cursors|' ~/.config/kcminputrc
sed -i 's|\(cursorTheme=\).*|\1Fluent-cursors|' ~/.config/kdedefaults/kcminputrc
sed -i 's|\(widgetStyle=\).*|\1kvantum|' ~/.config/kdedefaults/kdeglobals
sed -i 's|\(ColorScheme=\).*|\1FluentDark|' ~/.config/kdedefaults/kdeglobals
sed -i 's|\(Theme=\).*|\1Fluent-dark|' ~/.config/kdedefaults/kdeglobals
sed -i 's|\(widgetStyle=\).*|\1kvantum|' ~/.config/kdeglobals
sed -i 's|\(ColorScheme=\).*|\1FluentDark|' ~/.config/kdeglobals
sed -i 's|\(Theme=\).*|\1Fluent-dark|' ~/.config/kdeglobals
sed -i 's|\(Net/ThemeName "\)[^"]*|\1Fluent-Dark|' ~/.config/xsettingsd/xsettingsd.conf
sed -i 's|\(Gtk/CursorThemeName "\)[^"]*|\1Fluent-cursors|' ~/.config/xsettingsd/xsettingsd.conf
sed -i 's|\(Net/IconThemeName "\)[^"]*|\1Fluent-dark|' ~/.config/xsettingsd/xsettingsd.conf
sed -i 's|\(name=\).*|\1Fluent-dark|' ~/.config/kdedefaults/plasmarc
sed -i 's|^include *= *~/.config/sway/configs/theme-[^[:space:]]*|include = ~/.config/sway/configs/theme-Fluent-dark|' ~/.config/sway/config
sed -i 's/^\(\s*\)icon-theme: ".*/\1icon-theme: "Fluent-dark";/' ~/DotFiles/.config/rofi/config.rasi
sed -i 's|\(@import "~/.config/rofi/colors/\)[^"]*|\1adwaita-dark.rasi|' ~/DotFiles/.config/rofi/launcher/shared/colors.rasi
sed -i 's|\(@import "~/.config/rofi/colors/\)[^"]*|\1adwaita-dark.rasi|' ~/DotFiles/.config/rofi/powermenu/shared/colors.rasi
sed -i 's|\(include ./\)[^ ]*|\1dark-theme.conf|' ~/DotFiles/.config/kitty/kitty.conf
cp ~/DotFiles/.config/waybar/style-adwaita-dark.css ~/DotFiles/.config/waybar/style.css
cp ~/DotFiles/.config/swaync/style-adwaita-dark.css ~/DotFiles/.config/swaync/style.css
cp ~/DotFiles/.config/rofi/clipboard-adwaita-dark.rasi ~/DotFiles/.config/rofi/clipboard.rasi
cp ~/DotFiles/.config/hypr/scripts/lockscreen-adwaita-dark.sh ~/DotFiles/.config/hypr/scripts/lockscreen.sh
cp ~/DotFiles/.config/sway/scripts/lockscreen-adwaita-dark.sh ~/DotFiles/.config/sway/scripts/lockscreen.sh
hyprctl setcursor Fluent-cursors 24
gsettings set org.gnome.desktop.interface gtk-theme 'Fluent-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Fluent-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Fluent-cursors'
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface font-name 'Roboto Regular 12'
hyprctl reload
swaymsg reload