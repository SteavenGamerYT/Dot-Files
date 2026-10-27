#!/usr/bin/env bash
# ==============================================================================
# Theme Switcher for Desktop & Terminal Applications
# Supports: Nordic, Fluent (Dark)
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
    echo "Usage: $0 [nordic|fluent]"
    echo ""
    echo "Available themes:"
    echo "  nordic  - Nordic GTK/Kvantum theme with Papirus-Dark & WhiteSur cursors"
    echo "  fluent  - Fluent-Dark theme with Fluent-dark icons & Fluent cursors"
    exit 1
}

THEME="${1:-}"

# If no theme argument provided, check if interactive via terminal or rofi
if [ -z "$THEME" ]; then
    if [ -t 0 ]; then
        echo "Select a theme:"
        echo "1) Nordic"
        echo "2) Fluent"
        read -r -p "Choice [1-2]: " choice
        case "$choice" in
            1) THEME="nordic" ;;
            2) THEME="fluent" ;;
            *) echo "Invalid choice"; exit 1 ;;
        esac
    elif command -v rofi >/dev/null 2>&1; then
        THEME=$(printf "nordic\nfluent" | rofi -dmenu -p "Select Theme" || true)
        [ -z "$THEME" ] && exit 0
    else
        usage
    fi
fi

THEME=$(echo "$THEME" | tr '[:upper:]' '[:lower:]')

case "$THEME" in
    nordic)
        NAME="Nordic"
        ICON_THEME="Papirus-Dark"
        CURSOR_THEME="WhiteSur-cursors"
        GTK_THEME="Nordic"
        KVANTUM_THEME="Nordic-solid"
        KVANTUM_CONF="Nordic-Solid"
        KDE_COLOR="Nordic"
        HYPR_THEME="Nordic.conf"
        SWAY_THEME="theme-Nordic"
        ROFI_ICON="Papirus-Dark"
        ROFI_COLORS="nord.rasi"
        ROFI_CLIP="clipboard-nord.rasi"
        KITTY_CONF="nord.conf"
        WAYBAR_STYLE="style-nordic.css"
        SWAYNC_STYLE="style-nordic.css"
        LOCKSCREEN="lockscreen-nordic.sh"
        ;;
    fluent|fluent-dark)
        NAME="Fluent Dark"
        ICON_THEME="Fluent-dark"
        CURSOR_THEME="Fluent-cursors"
        GTK_THEME="Fluent-Dark"
        KVANTUM_THEME="FluentDark"
        KVANTUM_CONF="FluentDark"
        KDE_COLOR="FluentDark"
        HYPR_THEME="Fluent-dark.conf"
        SWAY_THEME="theme-Fluent-dark"
        ROFI_ICON="Fluent-dark"
        ROFI_COLORS="adwaita-dark.rasi"
        ROFI_CLIP="clipboard-adwaita-dark.rasi"
        KITTY_CONF="dark-theme.conf"
        WAYBAR_STYLE="style-adwaita-dark.css"
        SWAYNC_STYLE="style-adwaita-dark.css"
        LOCKSCREEN="lockscreen-adwaita-dark.sh"
        ;;
    *)
        echo "Unknown theme: $THEME"
        usage
        ;;
esac

echo "Applying $NAME theme..."

# Helper for sed on files that exist
safe_sed() {
    local pattern="$1"
    local file="$2"
    if [ -f "$file" ]; then
        sed -i "$pattern" "$file"
    fi
}

# 1. Update .profile environment variables
for prof in "$DOTFILES_DIR/.profile" "$HOME/.profile"; do
    if [ -f "$prof" ]; then
        safe_sed "s/^\(\s*\)export ICON_THEME=.*/\1export ICON_THEME=$ICON_THEME/" "$prof"
        safe_sed "s/^\(\s*\)export QT_QPA_ICONTHEME=.*/\1export QT_QPA_ICONTHEME=$ICON_THEME/" "$prof"
        safe_sed "s/^\(\s*\)export CURSOR_THEME=.*/\1export CURSOR_THEME=$CURSOR_THEME/" "$prof"
        safe_sed "s/^\(\s*\)export QT_QT_CURSORTHEME=.*/\1export QT_QT_CURSORTHEME=$CURSOR_THEME/" "$prof"
        safe_sed "s/^\(\s*\)export QT_QT5_CURSORTHEME=.*/\1export QT_QT5_CURSORTHEME=$CURSOR_THEME/" "$prof"
        safe_sed "s/^\(\s*\)export QT_QT6_CURSORTHEME=.*/\1export QT_QT6_CURSORTHEME=$CURSOR_THEME/" "$prof"
        safe_sed "s/^\(\s*\)export XCURSOR_THEME=.*/\1export XCURSOR_THEME=$CURSOR_THEME/" "$prof"
        safe_sed "s/^\(\s*\)export GTK_THEME=.*/\1export GTK_THEME=$GTK_THEME/" "$prof"
        safe_sed "s/^\(\s*\)export KVANTUM_THEME=.*/\1export KVANTUM_THEME=$KVANTUM_THEME/" "$prof"
    fi
done

# 2. GTK 2 / 3 / 4 Configs
for prefix in "$DOTFILES_DIR/.config" "$HOME/.config"; do
    safe_sed "s|\(gtk-theme-name=\"\)[^\"]*|\1$GTK_THEME|" "$prefix/gtk-2.0/gtkrc"
    safe_sed "s|\(gtk-cursor-theme-name=\"\)[^\"]*|\1$CURSOR_THEME|" "$prefix/gtk-2.0/gtkrc"
    safe_sed "s|\(gtk-icon-theme-name=\"\)[^\"]*|\1$ICON_THEME|" "$prefix/gtk-2.0/gtkrc"

    safe_sed "s|\(gtk-theme-name=\).*|\1$GTK_THEME|" "$prefix/gtk-3.0/settings.ini"
    safe_sed "s|\(gtk-cursor-theme-name=\).*|\1$CURSOR_THEME|" "$prefix/gtk-3.0/settings.ini"
    safe_sed "s|\(gtk-icon-theme-name=\).*|\1$ICON_THEME|" "$prefix/gtk-3.0/settings.ini"

    safe_sed "s|\(gtk-theme-name=\).*|\1$GTK_THEME|" "$prefix/gtk-4.0/settings.ini"
    safe_sed "s|\(gtk-cursor-theme-name=\).*|\1$CURSOR_THEME|" "$prefix/gtk-4.0/settings.ini"
    safe_sed "s|\(gtk-icon-theme-name=\).*|\1$ICON_THEME|" "$prefix/gtk-4.0/settings.ini"

    # Kvantum
    safe_sed "s/^\(\s*\)theme=.*/\1theme=$KVANTUM_CONF/" "$prefix/Kvantum/kvantum.kvconfig"

    # Hyprland
    safe_sed "s|\(^\s*source = ~/.config/hypr/config/theme-\)[^/]*|\1$HYPR_THEME|" "$prefix/hypr/hyprland.conf"

    # Sway
    safe_sed "s|^include *= *~/.config/sway/configs/theme-[^[:space:]]*|include = ~/.config/sway/configs/$SWAY_THEME|" "$prefix/sway/config"

    # Rofi
    safe_sed "s/^\(\s*\)icon-theme: \".*/\1icon-theme: \"$ROFI_ICON\";/" "$prefix/rofi/config.rasi"
    safe_sed "s|\(@import \"~/.config/rofi/colors/\)[^\"]*|\1$ROFI_COLORS|" "$prefix/rofi/launcher/shared/colors.rasi"
    safe_sed "s|\(@import \"~/.config/rofi/colors/\)[^\"]*|\1$ROFI_COLORS|" "$prefix/rofi/powermenu/shared/colors.rasi"
    [ -f "$prefix/rofi/$ROFI_CLIP" ] && cp "$prefix/rofi/$ROFI_CLIP" "$prefix/rofi/clipboard.rasi"

    # Kitty
    safe_sed "s|\(include ./\)[^ ]*|\1$KITTY_CONF|" "$prefix/kitty/kitty.conf"

    # Waybar & SwayNC
    [ -f "$prefix/waybar/$WAYBAR_STYLE" ] && cp "$prefix/waybar/$WAYBAR_STYLE" "$prefix/waybar/style.css"
    [ -f "$prefix/swaync/$SWAYNC_STYLE" ] && cp "$prefix/swaync/$SWAYNC_STYLE" "$prefix/swaync/style.css"

    # Lockscreen scripts
    [ -f "$prefix/hypr/scripts/$LOCKSCREEN" ] && cp "$prefix/hypr/scripts/$LOCKSCREEN" "$prefix/hypr/scripts/lockscreen.sh"
    [ -f "$prefix/sway/scripts/$LOCKSCREEN" ] && cp "$prefix/sway/scripts/$LOCKSCREEN" "$prefix/sway/scripts/lockscreen.sh"
done

# 3. KDE & Xsettingsd
safe_sed "s|\(cursorTheme=\).*|\1$CURSOR_THEME|" "$HOME/.config/kcminputrc"
safe_sed "s|\(cursorTheme=\).*|\1$CURSOR_THEME|" "$HOME/.config/kdedefaults/kcminputrc"
safe_sed "s|\(widgetStyle=\).*|\1kvantum|" "$HOME/.config/kdedefaults/kdeglobals"
safe_sed "s|\(ColorScheme=\).*|\1$KDE_COLOR|" "$HOME/.config/kdedefaults/kdeglobals"
safe_sed "s|\(Theme=\).*|\1$ICON_THEME|" "$HOME/.config/kdedefaults/kdeglobals"
safe_sed "s|\(widgetStyle=\).*|\1kvantum|" "$HOME/.config/kdeglobals"
safe_sed "s|\(ColorScheme=\).*|\1$KDE_COLOR|" "$HOME/.config/kdeglobals"
safe_sed "s|\(Theme=\).*|\1$ICON_THEME|" "$HOME/.config/kdeglobals"
safe_sed "s|\(name=\).*|\1$GTK_THEME|" "$HOME/.config/kdedefaults/plasmarc"
safe_sed "s|\(Net/ThemeName \"\)[^\"]*|\1$GTK_THEME|" "$HOME/.config/xsettingsd/xsettingsd.conf"
safe_sed "s|\(Gtk/CursorThemeName \"\)[^\"]*|\1$CURSOR_THEME|" "$HOME/.config/xsettingsd/xsettingsd.conf"
safe_sed "s|\(Net/IconThemeName \"\)[^\"]*|\1$ICON_THEME|" "$HOME/.config/xsettingsd/xsettingsd.conf"

# 4. GNOME / GTK live settings via gsettings
if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface cursor-size 24 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface font-name 'Roboto Regular 12' 2>/dev/null || true
fi

# 5. Live window manager reloads
if command -v hyprctl >/dev/null 2>&1; then
    hyprctl setcursor "$CURSOR_THEME" 24 2>/dev/null || true
    hyprctl reload 2>/dev/null || true
fi

if command -v swaymsg >/dev/null 2>&1; then
    swaymsg reload 2>/dev/null || true
fi

echo "Successfully applied $NAME theme!"
