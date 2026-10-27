#!/usr/bin/env bash
# ==============================================================================
# Unified Desktop Theme Switcher
# Supports 3 Complete Themes:
#   1) Nordic         - Full Blue (Frost cyan/blue, Nordic GTK/Kvantum, Nordic folders)
#   2) Nordic Red     - Full Red (Burgundy/Red, Mint-Y-Dark-Red, Red folders & accents)
#   3) Fluent Dark    - Dark Adwaita (Adwaita-dark GTK, Fluent-dark icons, GNOME blue accents)
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
    cat <<EOF
Usage: $(basename "$0") [nordic | red | fluent]

Available themes:
  nordic, nord, 1
      Full Blue Nordic theme (Frost cyan/blue, Nordic GTK/Kvantum, Papirus-Nordic folders)
  red, nordic-red, adwaita-red, 2
      Full Red Nordic Red theme (Mint-Y-Dark-Red GTK, style-red Waybar, Papirus-Red folders)
  fluent, adwaita, adwaita-dark, 3
      Dark Adwaita / Fluent Dark theme (Adwaita-dark GTK, Fluent icons, dark styling)
EOF
    exit 1
}

THEME="${1:-}"

# Interactive selection if no argument is supplied
if [ -z "$THEME" ]; then
    if [ -t 0 ]; then
        echo "=================================================="
        echo " Select Desktop Theme:"
        echo "=================================================="
        echo " 1) Nordic       (Full Blue / Frost Cyan)"
        echo " 2) Nordic Red   (Full Red / Adwaita Red)"
        echo " 3) Fluent Dark  (Adwaita Dark / Fluent)"
        read -r -p "Enter choice [1-3]: " choice
        case "$choice" in
            1) THEME="nordic" ;;
            2) THEME="nordic-red" ;;
            3) THEME="fluent" ;;
            *) echo "Invalid choice"; exit 1 ;;
        esac
    elif command -v rofi >/dev/null 2>&1; then
        THEME=$(printf "1. Nordic (Full Blue)\n2. Nordic Red (Full Red)\n3. Fluent Dark (Adwaita Dark)" | rofi -dmenu -p "Select Theme" || true)
        case "$THEME" in
            *Red*|*2*)    THEME="nordic-red" ;;
            *Nordic*|*1*) THEME="nordic" ;;
            *Fluent*|*3*) THEME="fluent" ;;
            *) exit 0 ;;
        esac
    else
        usage
    fi
fi

THEME=$(echo "$THEME" | tr '[:upper:]' '[:lower:]')

# ------------------------------------------------------------------------------
# Ensure Nordic GTK Theme directory is linked
# ------------------------------------------------------------------------------
if [ -d "$HOME/Git/Nordic" ]; then
    mkdir -p "$HOME/.themes" "$HOME/.local/share/themes"
    [ ! -e "$HOME/.themes/Nordic" ] && ln -sfn "$HOME/Git/Nordic" "$HOME/.themes/Nordic" 2>/dev/null || true
    [ ! -e "$HOME/.local/share/themes/Nordic" ] && ln -sfn "$HOME/Git/Nordic" "$HOME/.local/share/themes/Nordic" 2>/dev/null || true
fi

case "$THEME" in
    nordic|nord|blue|1)
        DISPLAY_NAME="Pure Nordic (Full Blue)"
        GTK_THEME="Nordic"
        ICON_THEME="Papirus-Dark"
        CURSOR_THEME="Nordzy-cursors"
        KVANTUM_THEME="Nordic-solid"
        KVANTUM_CONF="Nordic-Solid"
        KDE_COLOR="Nordic"
        HYPR_THEME="theme-Nordic.conf"
        SWAY_THEME="theme-Nordic"
        I3_THEME="theme-Nordic"
        BSPWM_BORDER="#88c0d0"
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
        DISPLAY_NAME="Nordic Red (Full Red / Adwaita Red)"
        # Prefer Mint-Y-Dark-Red, fallback to WhiteSur-Dark-red
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
        KDE_COLOR="Nordic-Red"
        HYPR_THEME="theme-Nordic-red.conf"
        SWAY_THEME="theme-Nordic-red"
        I3_THEME="theme-Nordic-red"
        BSPWM_BORDER="#bf616a"
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
    fluent|fluent-dark|adwaita|adwaita-dark|dark|3)
        DISPLAY_NAME="Fluent Dark (Adwaita Dark)"
        if [ -d "/usr/share/themes/Fluent-Dark" ] || [ -d "$HOME/.local/share/themes/Fluent-Dark" ] || [ -d "$HOME/.themes/Fluent-Dark" ]; then
            GTK_THEME="Fluent-Dark"
        else
            GTK_THEME="Adwaita-dark"
        fi
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
        BSPWM_BORDER="#3584e4"
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
        if [ -e "$dest" ] && [ "$src" -ef "$dest" ]; then
            return 0
        fi
        cp -f "$src" "$dest"
    fi
}

# ------------------------------------------------------------------------------
# 1. Shell Profiles (~/.profile & repo .profile)
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
        safe_sed "s/^\(\s*\)export KDE_COLOR_SCHEME=.*/\1export KDE_COLOR_SCHEME=\"$KDE_COLOR\"/" "$prof"
    fi
done

# ------------------------------------------------------------------------------
# 1b. Systemd User Environment (~/.config/environment.d/10-user.conf)
# ------------------------------------------------------------------------------
for env_file in "$DOTFILES_DIR/.config/environment.d/10-user.conf" "$HOME/.config/environment.d/10-user.conf"; do
    if [ -f "$env_file" ]; then
        safe_sed "s|^GTK_THEME=.*|GTK_THEME=$GTK_THEME|" "$env_file"
        safe_sed "s|^ICON_THEME=.*|ICON_THEME=$ICON_THEME|" "$env_file"
        safe_sed "s|^QT_QPA_ICONTHEME=.*|QT_QPA_ICONTHEME=$ICON_THEME|" "$env_file"
        safe_sed "s|^CURSOR_THEME=.*|CURSOR_THEME=$CURSOR_THEME|" "$env_file"
        safe_sed "s|^QT_QT_CURSORTHEME=.*|QT_QT_CURSORTHEME=$CURSOR_THEME|" "$env_file"
        safe_sed "s|^QT_QT5_CURSORTHEME=.*|QT_QT5_CURSORTHEME=$CURSOR_THEME|" "$env_file"
        safe_sed "s|^QT_QT6_CURSORTHEME=.*|QT_QT6_CURSORTHEME=$CURSOR_THEME|" "$env_file"
        safe_sed "s|^XCURSOR_THEME=.*|XCURSOR_THEME=$CURSOR_THEME|" "$env_file"
        safe_sed "s|^KVANTUM_THEME=.*|KVANTUM_THEME=$KVANTUM_THEME|" "$env_file"
        safe_sed "s|^KDE_COLOR_SCHEME=.*|KDE_COLOR_SCHEME=\"$KDE_COLOR\"|" "$env_file"
    fi
done

if command -v systemctl >/dev/null 2>&1; then
    systemctl --user import-environment GTK_THEME ICON_THEME QT_QPA_ICONTHEME CURSOR_THEME XCURSOR_THEME KVANTUM_THEME KDE_COLOR_SCHEME 2>/dev/null || true
fi

# ------------------------------------------------------------------------------
# 2. GTK 2, 3, 4 Configurations
# ------------------------------------------------------------------------------
for prefix in "$DOTFILES_DIR/.config" "$HOME/.config"; do
    [ -d "$prefix" ] || continue

    # GTK 2
    safe_sed "s|\(gtk-theme-name=\"\)[^\"]*|\1$GTK_THEME|" "$prefix/gtk-2.0/gtkrc"
    safe_sed "s|\(gtk-cursor-theme-name=\"\)[^\"]*|\1$CURSOR_THEME|" "$prefix/gtk-2.0/gtkrc"
    safe_sed "s|\(gtk-icon-theme-name=\"\)[^\"]*|\1$ICON_THEME|" "$prefix/gtk-2.0/gtkrc"

    # GTK 3
    safe_sed "s|\(gtk-theme-name=\).*|\1$GTK_THEME|" "$prefix/gtk-3.0/settings.ini"
    safe_sed "s|\(gtk-cursor-theme-name=\).*|\1$CURSOR_THEME|" "$prefix/gtk-3.0/settings.ini"
    safe_sed "s|\(gtk-icon-theme-name=\).*|\1$ICON_THEME|" "$prefix/gtk-3.0/settings.ini"

    # GTK 4 settings.ini
    safe_sed "s|\(gtk-theme-name=\).*|\1$GTK_THEME|" "$prefix/gtk-4.0/settings.ini"
    safe_sed "s|\(gtk-cursor-theme-name=\).*|\1$CURSOR_THEME|" "$prefix/gtk-4.0/settings.ini"
    safe_sed "s|\(gtk-icon-theme-name=\).*|\1$ICON_THEME|" "$prefix/gtk-4.0/settings.ini"

    # GTK 4 Stylesheets (Overriding Libadwaita colors & row selection)
    if [ -f "$DOTFILES_DIR/.config/gtk-4.0/$GTK4_CSS" ]; then
        if [ "$prefix" != "$DOTFILES_DIR/.config" ]; then
            safe_copy "$DOTFILES_DIR/.config/gtk-4.0/gtk-nordic.css" "$prefix/gtk-4.0/gtk-nordic.css"
            safe_copy "$DOTFILES_DIR/.config/gtk-4.0/gtk-red.css" "$prefix/gtk-4.0/gtk-red.css"
            safe_copy "$DOTFILES_DIR/.config/gtk-4.0/gtk-adwaita.css" "$prefix/gtk-4.0/gtk-adwaita.css"
        fi
        (cd "$prefix/gtk-4.0" && ln -sfn "$GTK4_CSS" gtk.css && ln -sfn "$GTK4_CSS" gtk-dark.css) 2>/dev/null || true
    fi

    # Kvantum
    safe_sed "s/^\(\s*\)theme=.*/\1theme=$KVANTUM_CONF/" "$prefix/Kvantum/kvantum.kvconfig"

    # Hyprland (Match only theme-*.conf, preserving all other source directives)
    safe_sed "s|^\s*source[[:space:]=]*.*hypr/config/theme-[^[:space:]]*|source = ~/.config/hypr/config/$HYPR_THEME|" "$prefix/hypr/hyprland.conf"

    # Sway (Match 'include ...sway/configs/theme-*' with or without '=')
    safe_sed "s|^include[[:space:]=]*.*sway/configs/theme-[^[:space:]]*|include ~/.config/sway/configs/$SWAY_THEME|" "$prefix/sway/config"

    # i3 (Match 'include = ...i3/configs/theme-*')
    safe_sed "s|^include[[:space:]=]*.*i3/configs/theme-[^[:space:]]*|include = ~/.config/i3/configs/$I3_THEME|" "$prefix/i3/config"

    # BSPWM startup persistence
    safe_sed "s|\(gsettings set org.gnome.desktop.interface gtk-theme '\)[^']*|\1$GTK_THEME|" "$prefix/bspwm/bspwmrc"
    safe_sed "s|\(gsettings set org.gnome.desktop.interface icon-theme '\)[^']*|\1$ICON_THEME|" "$prefix/bspwm/bspwmrc"
    safe_sed "s|\(gsettings set org.gnome.desktop.interface cursor-theme '\)[^']*|\1$CURSOR_THEME|" "$prefix/bspwm/bspwmrc"

    # Rofi
    safe_sed "s/^\(\s*\)icon-theme: \".*/\1icon-theme: \"$ROFI_ICON\";/" "$prefix/rofi/config.rasi"
    safe_sed "s|@import[[:space:]]*\"~/.config/rofi/colors/.*|@import \"~/.config/rofi/colors/$ROFI_COLORS\"|" "$prefix/rofi/launcher/shared/colors.rasi"
    safe_sed "s|@import[[:space:]]*\"~/.config/rofi/colors/.*|@import \"~/.config/rofi/colors/$ROFI_COLORS\"|" "$prefix/rofi/powermenu/shared/colors.rasi"
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
# 3. KDE Plasma & Xsettingsd
# ------------------------------------------------------------------------------
# Detect KDE configuration tool (Plasma 6 / Plasma 5)
KWRITECONFIG=""
if command -v kwriteconfig6 >/dev/null 2>&1; then
    KWRITECONFIG="kwriteconfig6"
elif command -v kwriteconfig5 >/dev/null 2>&1; then
    KWRITECONFIG="kwriteconfig5"
fi

PLASMA_DESKTOP_THEME="breeze-dark"

if [ -n "$KWRITECONFIG" ]; then
    # 1. Update active KDE globals
    $KWRITECONFIG --file kdeglobals --group General --key ColorScheme "$KDE_COLOR"
    $KWRITECONFIG --file kdeglobals --group KDE --key widgetStyle "kvantum"
    $KWRITECONFIG --file kdeglobals --group Icons --key Theme "$ICON_THEME"
    $KWRITECONFIG --file kdeglobals --group KDE --key LookAndFeelPackage "org.kde.breezedark.desktop"

    # 2. Update Mouse Cursor
    $KWRITECONFIG --file kcminputrc --group Mouse --key cursorTheme "$CURSOR_THEME"

    # 3. Plasma Desktop Style (panel, taskbar, kickoff menu - MUST be a valid desktop theme, NOT gtk theme)
    $KWRITECONFIG --file plasmarc --group Theme --key name "$PLASMA_DESKTOP_THEME"

    # 4. Sync kdedefaults so session defaults never revert or fallback to Breeze Light
    for kdedef in "$HOME/.config/kdedefaults" "$DOTFILES_DIR/.config/kdedefaults"; do
        if [ -d "$kdedef" ]; then
            $KWRITECONFIG --file "$kdedef/kdeglobals" --group General --key ColorScheme "$KDE_COLOR"
            $KWRITECONFIG --file "$kdedef/kdeglobals" --group KDE --key widgetStyle "kvantum"
            $KWRITECONFIG --file "$kdedef/kdeglobals" --group Icons --key Theme "$ICON_THEME"
            $KWRITECONFIG --file "$kdedef/kcminputrc" --group Mouse --key cursorTheme "$CURSOR_THEME"
            $KWRITECONFIG --file "$kdedef/plasmarc" --group Theme --key name "$PLASMA_DESKTOP_THEME"
            echo "org.kde.breezedark.desktop" > "$kdedef/package" 2>/dev/null || true
        fi
    done
else
    # Fallback sed if kwriteconfig is not installed
    for kde_dir in "$HOME/.config" "$DOTFILES_DIR/.config"; do
        [ -d "$kde_dir" ] || continue
        safe_sed "s|\(cursorTheme=\).*|\1$CURSOR_THEME|" "$kde_dir/kcminputrc" 2>/dev/null || true
        safe_sed "s|\(cursorTheme=\).*|\1$CURSOR_THEME|" "$kde_dir/kdedefaults/kcminputrc" 2>/dev/null || true
        safe_sed "s|\(widgetStyle=\).*|\1kvantum|" "$kde_dir/kdedefaults/kdeglobals" 2>/dev/null || true
        safe_sed "s|\(ColorScheme=\).*|\1$KDE_COLOR|" "$kde_dir/kdedefaults/kdeglobals" 2>/dev/null || true
        safe_sed "s|\(Theme=\).*|\1$ICON_THEME|" "$kde_dir/kdedefaults/kdeglobals" 2>/dev/null || true
        safe_sed "s|\(widgetStyle=\).*|\1kvantum|" "$kde_dir/kdeglobals" 2>/dev/null || true
        safe_sed "s|\(ColorScheme=\).*|\1$KDE_COLOR|" "$kde_dir/kdeglobals" 2>/dev/null || true
        safe_sed "s|\(Theme=\).*|\1$ICON_THEME|" "$kde_dir/kdeglobals" 2>/dev/null || true
        safe_sed "s|\(name=\).*|\1$PLASMA_DESKTOP_THEME|" "$kde_dir/kdedefaults/plasmarc" 2>/dev/null || true
        safe_sed "s|\(name=\).*|\1$PLASMA_DESKTOP_THEME|" "$kde_dir/plasmarc" 2>/dev/null || true
    done
fi

safe_sed "s|\(Net/ThemeName \"\)[^\"]*|\1$GTK_THEME\"|" "$HOME/.config/xsettingsd/xsettingsd.conf" 2>/dev/null || true
safe_sed "s|\(Gtk/CursorThemeName \"\)[^\"]*|\1$CURSOR_THEME\"|" "$HOME/.config/xsettingsd/xsettingsd.conf" 2>/dev/null || true
safe_sed "s|\(Net/IconThemeName \"\)[^\"]*|\1$ICON_THEME\"|" "$HOME/.config/xsettingsd/xsettingsd.conf" 2>/dev/null || true

# Apply KDE color scheme live via plasma-apply-colorscheme
if command -v plasma-apply-colorscheme >/dev/null 2>&1; then
    plasma-apply-colorscheme "$KDE_COLOR" >/dev/null 2>&1 || true
fi

# Apply KDE desktop theme live (keeps panels and app launcher dark)
if command -v plasma-apply-desktoptheme >/dev/null 2>&1; then
    plasma-apply-desktoptheme "$PLASMA_DESKTOP_THEME" >/dev/null 2>&1 || true
fi

# Apply KDE cursor theme live
if command -v plasma-apply-cursortheme >/dev/null 2>&1; then
    plasma-apply-cursortheme "$CURSOR_THEME" >/dev/null 2>&1 || true
fi

# Notify kde-gtk-config via DBus to accept the GTK theme so KDE doesn't fight it
if command -v busctl >/dev/null 2>&1; then
    busctl --user call org.kde.GtkConfig /GtkConfig org.kde.GtkConfig setGtkTheme s "$GTK_THEME" >/dev/null 2>&1 || true
elif command -v qdbus6 >/dev/null 2>&1; then
    qdbus6 org.kde.GtkConfig /GtkConfig org.kde.GtkConfig.setGtkTheme "$GTK_THEME" >/dev/null 2>&1 || true
elif command -v dbus-send >/dev/null 2>&1; then
    dbus-send --session --dest=org.kde.GtkConfig --type=method_call /GtkConfig org.kde.GtkConfig.setGtkTheme "string:$GTK_THEME" >/dev/null 2>&1 || true
fi

# Reload KWin window decorations live
if command -v qdbus6 >/dev/null 2>&1; then
    qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
elif command -v qdbus >/dev/null 2>&1; then
    qdbus org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
fi

# ------------------------------------------------------------------------------
# 4. Papirus Folder Icons
# ------------------------------------------------------------------------------
if command -v papirus-folders >/dev/null 2>&1; then
    if [ -w "/usr/share/icons/Papirus-Dark" ] || [ -d "$HOME/.local/share/icons/Papirus-Dark" ] || [ -d "$HOME/.icons/Papirus-Dark" ] || sudo -n true 2>/dev/null; then
        echo "  [icons] Setting Papirus folder color to: $PAPIRUS_FOLDER_COLOR..."
        papirus-folders -C "$PAPIRUS_FOLDER_COLOR" --theme Papirus-Dark 2>/dev/null || true
    fi
fi


# ------------------------------------------------------------------------------
# 5. GNOME Desktop Interface via gsettings
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
# 6. Live WMs & Desktop Shell Reloads
# ------------------------------------------------------------------------------
# Hyprland
if command -v hyprctl >/dev/null 2>&1; then
    hyprctl setcursor "$CURSOR_THEME" 24 2>/dev/null || true
    hyprctl reload 2>/dev/null || true
fi

# Sway
if command -v swaymsg >/dev/null 2>&1; then
    swaymsg reload 2>/dev/null || true
fi

# i3
if command -v i3-msg >/dev/null 2>&1; then
    i3-msg reload 2>/dev/null || true
fi

# BSPWM border color live update
if command -v bspc >/dev/null 2>&1; then
    bspc config focused_border_color "$BSPWM_BORDER" 2>/dev/null || true
fi

# Waybar reload
pkill -USR2 waybar 2>/dev/null || true

# SwayNC reload
if command -v swaync-client >/dev/null 2>&1; then
    swaync-client -R 2>/dev/null || true
    swaync-client -rs 2>/dev/null || true
fi

# xsettingsd live reload (signals GTK apps on X11 / XWayland)
killall -HUP xsettingsd 2>/dev/null || pkill -HUP xsettingsd 2>/dev/null || true

echo "==> Successfully switched to $DISPLAY_NAME!"
