#!/usr/bin/env bash
# ==============================================================================
# Unified Desktop Theme Switcher
# Supports:
#   1) Nordic         - Pure Cool Nordic (Frost, Polar Night, Blue GTK & Folders)
#   2) Nordic Red     - Nordic Red / Adwaita Red (Burgundy, Red Accents, Mint-Y-Dark-Red)
#   3) Fluent Dark    - Fluent / Adwaita Dark
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
    echo "Usage: $(basename "$0") [nordic | red | fluent]"
    echo ""
    echo "Available themes:"
    echo "  nordic      - Pure Nordic theme (Frost cyan/blue, Nordic GTK/Kvantum, Papirus-Nordic)"
    echo "  red | nordic-red | adwaita-red"
    echo "              - Nordic Red (Mint-Y-Dark-Red / WhiteSur-Dark-red, style-red, Papirus-Red)"
    echo "  fluent | adwaita"
    echo "              - Fluent Dark / Adwaita Dark"
    exit 1
}

THEME="${1:-}"

# Interactive selection if no argument is supplied
if [ -z "$THEME" ]; then
    if [ -t 0 ]; then
        echo "=================================="
        echo " Select Desktop Theme:"
        echo "=================================="
        echo " 1) Nordic (Pure Cool Frost)"
        echo " 2) Nordic Red (Adwaita Red / Mint-Y-Dark-Red)"
        echo " 3) Fluent Dark (Adwaita Dark)"
        read -r -p "Enter choice [1-3]: " choice
        case "$choice" in
            1) THEME="nordic" ;;
            2) THEME="nordic-red" ;;
            3) THEME="fluent" ;;
            *) echo "Invalid choice"; exit 1 ;;
        esac
    elif command -v rofi >/dev/null 2>&1; then
        THEME=$(printf "1. Nordic\n2. Nordic Red (Adwaita Red)\n3. Fluent Dark" | rofi -dmenu -p "Select Theme" || true)
        case "$THEME" in
            *Nordic\ Red*|*2*) THEME="nordic-red" ;;
            *Nordic*|*1*)     THEME="nordic" ;;
            *Fluent*|*3*)     THEME="fluent" ;;
            *) exit 0 ;;
        esac
    else
        usage
    fi
fi

THEME=$(echo "$THEME" | tr '[:upper:]' '[:lower:]')

case "$THEME" in
    nordic|nord|1)
        DISPLAY_NAME="Pure Nordic"
        GTK_THEME="Nordic"
        ICON_THEME="Papirus-Dark"
        CURSOR_THEME="WhiteSur-cursors"
        KVANTUM_THEME="Nordic-solid"
        KVANTUM_CONF="Nordic-Solid"
        KDE_COLOR="Nordic"
        HYPR_THEME="Nordic.conf"
        SWAY_THEME="theme-Nordic"
        I3_THEME="theme-Nordic"
        ROFI_ICON="Papirus-Dark"
        ROFI_COLORS="nord.rasi"
        ROFI_CLIP="clipboard-nord.rasi"
        KITTY_CONF="nord.conf"
        ALACRITTY_THEME="nordic.toml"
        WAYBAR_STYLE="style-nordic.css"
        SWAYNC_STYLE="style-nordic.css"
        LOCKSCREEN_SCRIPT="lockscreen-nordic.sh"
        STARSHIP_THEME="starship-nordic.toml"
        GTK4_CSS="gtk-nordic.css"
        PAPIRUS_FOLDER_COLOR="nordic"
        ;;
    red|nordic-red|nord-red|adwaita-red|2)
        DISPLAY_NAME="Nordic Red (Adwaita Red)"
        # Use Mint-Y-Dark-Red if installed, otherwise WhiteSur-Dark-red
        if [ -d "/usr/share/themes/Mint-Y-Dark-Red" ] || [ -d "$HOME/.local/share/themes/Mint-Y-Dark-Red" ]; then
            GTK_THEME="Mint-Y-Dark-Red"
        elif [ -d "$HOME/.themes/WhiteSur-Dark-red" ]; then
            GTK_THEME="WhiteSur-Dark-red"
        else
            GTK_THEME="Mint-Y-Dark-Red"
        fi
        ICON_THEME="Papirus-Dark"
        CURSOR_THEME="WhiteSur-cursors"
        KVANTUM_THEME="Nordic-Solid-Red"
        KVANTUM_CONF="Nordic-Solid-Red"
        KDE_COLOR="Nordic"
        HYPR_THEME="theme-Nordic-red.conf"
        SWAY_THEME="theme-Nordic-red"
        I3_THEME="theme-Nordic-red"
        ROFI_ICON="Papirus-Dark"
        ROFI_COLORS="nord-red.rasi"
        ROFI_CLIP="clipboard-nord-red.rasi"
        KITTY_CONF="nord-red.conf"
        ALACRITTY_THEME="nord-red.toml"
        WAYBAR_STYLE="style-red.css"
        SWAYNC_STYLE="style-nordic-red.css"
        LOCKSCREEN_SCRIPT="lockscreen-nordic-red.sh"
        STARSHIP_THEME="starship-nordic-red.toml"
        GTK4_CSS="gtk-red.css"
        PAPIRUS_FOLDER_COLOR="red"
        ;;
    fluent|fluent-dark|adwaita|adwaita-dark|3)
        DISPLAY_NAME="Fluent Dark (Adwaita Dark)"
        GTK_THEME="Fluent-Dark"
        # Check if Fluent-dark icons exist, fallback to Papirus-Dark
        if [ -d "/usr/share/icons/Fluent-dark" ] || [ -d "$HOME/.local/share/icons/Fluent-dark" ] || [ -d "$HOME/.icons/Fluent-dark" ]; then
            ICON_THEME="Fluent-dark"
        else
            ICON_THEME="Papirus-Dark"
        fi
        if [ -d "/usr/share/icons/Fluent-cursors" ] || [ -d "$HOME/.local/share/icons/Fluent-cursors" ] || [ -d "$HOME/.icons/Fluent-cursors" ]; then
            CURSOR_THEME="Fluent-cursors"
        else
            CURSOR_THEME="WhiteSur-cursors"
        fi
        KVANTUM_THEME="FluentDark"
        KVANTUM_CONF="FluentDark"
        KDE_COLOR="FluentDark"
        HYPR_THEME="theme-Fluent-dark.conf"
        SWAY_THEME="theme-Fluent-dark"
        I3_THEME="theme-Fluent-dark"
        ROFI_ICON="$ICON_THEME"
        ROFI_COLORS="adwaita-dark.rasi"
        ROFI_CLIP="clipboard-adwaita-dark.rasi"
        KITTY_CONF="dark-theme.conf"
        ALACRITTY_THEME="adwaita-dark.toml"
        WAYBAR_STYLE="style-adwaita-dark.css"
        SWAYNC_STYLE="style-adwaita-dark.css"
        LOCKSCREEN_SCRIPT="lockscreen-adwaita-dark.sh"
        STARSHIP_THEME="starship-adwaita.toml"
        GTK4_CSS="gtk-adwaita.css"
        PAPIRUS_FOLDER_COLOR="adwaita"
        ;;
    *)
        echo "Unknown theme: $THEME"
        usage
        ;;
esac

echo "==> Applying theme: $DISPLAY_NAME..."

safe_sed() {
    local pattern="$1"
    local file="$2"
    if [ -f "$file" ]; then
        sed -i "$pattern" "$file"
    fi
}

safe_copy() {
    local src="$1"
    local dest="$2"
    if [ -f "$src" ]; then
        cp "$src" "$dest"
    fi
}

# ------------------------------------------------------------------------------
# 1. Shell Environment & Profiles
# ------------------------------------------------------------------------------
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

# ------------------------------------------------------------------------------
# 2. GTK 2, 3, 4 Configs
# ------------------------------------------------------------------------------
for prefix in "$DOTFILES_DIR/.config" "$HOME/.config"; do
    # GTK 2
    safe_sed "s|\(gtk-theme-name=\"\)[^\"]*|\1$GTK_THEME|" "$prefix/gtk-2.0/gtkrc"
    safe_sed "s|\(gtk-cursor-theme-name=\"\)[^\"]*|\1$CURSOR_THEME|" "$prefix/gtk-2.0/gtkrc"
    safe_sed "s|\(gtk-icon-theme-name=\"\)[^\"]*|\1$ICON_THEME|" "$prefix/gtk-2.0/gtkrc"

    # GTK 3
    safe_sed "s|\(gtk-theme-name=\).*|\1$GTK_THEME|" "$prefix/gtk-3.0/settings.ini"
    safe_sed "s|\(gtk-cursor-theme-name=\).*|\1$CURSOR_THEME|" "$prefix/gtk-3.0/settings.ini"
    safe_sed "s|\(gtk-icon-theme-name=\).*|\1$ICON_THEME|" "$prefix/gtk-3.0/settings.ini"

    # GTK 4 Settings
    safe_sed "s|\(gtk-theme-name=\).*|\1$GTK_THEME|" "$prefix/gtk-4.0/settings.ini"
    safe_sed "s|\(gtk-cursor-theme-name=\).*|\1$CURSOR_THEME|" "$prefix/gtk-4.0/settings.ini"
    safe_sed "s|\(gtk-icon-theme-name=\).*|\1$ICON_THEME|" "$prefix/gtk-4.0/settings.ini"

    # GTK 4 Stylesheets (Overriding Libadwaita colors)
    if [ -f "$DOTFILES_DIR/.config/gtk-4.0/$GTK4_CSS" ]; then
        cp "$DOTFILES_DIR/.config/gtk-4.0/$GTK4_CSS" "$prefix/gtk-4.0/gtk.css" 2>/dev/null || true
        cp "$DOTFILES_DIR/.config/gtk-4.0/$GTK4_CSS" "$prefix/gtk-4.0/gtk-dark.css" 2>/dev/null || true
    fi

    # Kvantum
    safe_sed "s/^\(\s*\)theme=.*/\1theme=$KVANTUM_CONF/" "$prefix/Kvantum/kvantum.kvconfig"

    # Hyprland
    safe_sed "s|\(^\s*source = ~/.config/hypr/config/\)[^/]*|\1$HYPR_THEME|" "$prefix/hypr/hyprland.conf"

    # Sway
    safe_sed "s|^include *= *~/.config/sway/configs/theme-[^[:space:]]*|include = ~/.config/sway/configs/$SWAY_THEME|" "$prefix/sway/config"

    # i3
    safe_sed "s|^include *= *~/.config/i3/configs/theme-[^[:space:]]*|include = ~/.config/i3/configs/$I3_THEME|" "$prefix/i3/config"

    # Rofi
    safe_sed "s/^\(\s*\)icon-theme: \".*/\1icon-theme: \"$ROFI_ICON\";/" "$prefix/rofi/config.rasi"
    safe_sed "s|\(@import \"~/.config/rofi/colors/\)[^\"]*|\1$ROFI_COLORS|" "$prefix/rofi/launcher/shared/colors.rasi"
    safe_sed "s|\(@import \"~/.config/rofi/colors/\)[^\"]*|\1$ROFI_COLORS|" "$prefix/rofi/powermenu/shared/colors.rasi"
    safe_copy "$DOTFILES_DIR/.config/rofi/$ROFI_CLIP" "$prefix/rofi/clipboard.rasi"

    # Kitty
    safe_sed "s|\(include ./\)[^ ]*|\1$KITTY_CONF|" "$prefix/kitty/kitty.conf"

    # Alacritty
    safe_sed "s|\(~/.config/alacritty/\)[^\"]*\(\.toml\)|\1$ALACRITTY_THEME|" "$prefix/alacritty/alacritty.toml"

    # Waybar
    safe_copy "$DOTFILES_DIR/.config/waybar/$WAYBAR_STYLE" "$prefix/waybar/style.css"

    # SwayNC
    safe_copy "$DOTFILES_DIR/.config/swaync/$SWAYNC_STYLE" "$prefix/swaync/style.css"

    # Lockscreen scripts (Hyprland & Sway)
    safe_copy "$DOTFILES_DIR/.config/hypr/scripts/$LOCKSCREEN_SCRIPT" "$prefix/hypr/scripts/lockscreen.sh"
    safe_copy "$DOTFILES_DIR/.config/sway/scripts/$LOCKSCREEN_SCRIPT" "$prefix/sway/scripts/lockscreen.sh"

    # Starship Prompt
    if [ -f "$DOTFILES_DIR/.config/starship/$STARSHIP_THEME" ]; then
        safe_copy "$DOTFILES_DIR/.config/starship/$STARSHIP_THEME" "$prefix/starship/starship.toml"
    fi
done

# ------------------------------------------------------------------------------
# 3. KDE & Xsettingsd Configurations
# ------------------------------------------------------------------------------
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

# ------------------------------------------------------------------------------
# 4. Papirus Folder Icons (Matching Theme)
# ------------------------------------------------------------------------------
if command -v papirus-folders >/dev/null 2>&1; then
    echo "  [icons] Setting Papirus folder color to: $PAPIRUS_FOLDER_COLOR..."
    papirus-folders -C "$PAPIRUS_FOLDER_COLOR" --theme Papirus-Dark 2>/dev/null || true
fi

# ------------------------------------------------------------------------------
# 5. GNOME / Live GTK settings via gsettings
# ------------------------------------------------------------------------------
if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface cursor-size 24 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface font-name 'Roboto Regular 12' 2>/dev/null || true
fi

# ------------------------------------------------------------------------------
# 6. Live Window Manager & Bar Reloads
# ------------------------------------------------------------------------------
if command -v hyprctl >/dev/null 2>&1; then
    hyprctl setcursor "$CURSOR_THEME" 24 2>/dev/null || true
    hyprctl reload 2>/dev/null || true
fi

if command -v swaymsg >/dev/null 2>&1; then
    swaymsg reload 2>/dev/null || true
fi

# Signal Waybar to reload styles
pkill -USR2 waybar 2>/dev/null || true

# Signal SwayNC to reload styles
if command -v swaync-client >/dev/null 2>&1; then
    swaync-client -R 2>/dev/null || true
    swaync-client -rs 2>/dev/null || true
fi

echo "==> Successfully switched to $DISPLAY_NAME!"
