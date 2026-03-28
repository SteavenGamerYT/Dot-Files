# ==============================
# PATH — Add custom directories
# ==============================
for dir in \
  "$HOME/.bin" \
  "$HOME/.local/bin" \
  "$HOME/Applications" \
  "/var/lib/flatpak/exports/bin" \
  "/home/linuxbrew/.linuxbrew/bin" \
  "/home/linuxbrew/.linuxbrew/sbin"
do
  [ -d "$dir" ] && PATH="$dir:$PATH"
done
export PATH


# ==============================
# General Environment
# ==============================
export EDITOR=nano
export XDG_SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"
export GRIMSHOT_FILENAME_FORMAT="%Y-%m-%d_%H-%M-%S"


# ==============================
# Wayland Support
# ==============================
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  export MOZ_ENABLE_WAYLAND=1
  export ELECTRON_OZONE_PLATFORM_HINT=auto
fi


# ==============================
# MangoHud per machine
# ==============================
case "$(hostname -s)" in
  Omar-PC)           export MANGOHUD_CONFIG="preset=5" ;;
  Omar-PC2)           export MANGOHUD_CONFIG="preset=6" ;;
  Omar-Laptop)       export MANGOHUD_CONFIG="preset=8" ;;
  Omar-GamingLaptop) export MANGOHUD_CONFIG="preset=7" ;;
  Hany-GamingLaptop) export MANGOHUD_CONFIG="preset=9" ;;
esac


# ==============================
# Desktop Detection
# ==============================
DE="$(printf "%s" "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]')"

case "$DE" in

  # ----------------------------
  # i3 / sway / Hyprland
  # ----------------------------
  *i3*|*sway*|*hyprland*)
    export GTK_THEME="Mint-Y-Dark-Red"
    export XCURSOR_THEME="WhiteSur-cursors"
    export XCURSOR_SIZE=24

    export QT_STYLE_OVERRIDE=kvantum
    export QT_QPA_PLATFORMTHEME=qt6ct
    export KVANTUM_THEME="Nordic-Solid-Red"
    export QT_QPA_ICONTHEME="Papirus-Dark"
    export KDE_COLOR_SCHEME="Nord Red Dark"
    ;;

  # ----------------------------
  # GNOME
  # ----------------------------
  *gnome*)
    export XCURSOR_THEME="WhiteSur-cursors"

    # Only force Qt styling (GNOME has no native Qt integration)
    export QT_STYLE_OVERRIDE=kvantum
    export QT_QPA_PLATFORMTHEME=qt6ct
    export KVANTUM_THEME="Nordic-Solid-Red"
    export QT_QPA_ICONTHEME="Papirus-Dark"
    export KDE_COLOR_SCHEME="Nord Red Dark"
    ;;

  # ----------------------------
  # KDE Plasma
  # ----------------------------
  *kde*|*plasma*)
    export GTK_THEME="Mint-Y-Dark-Red"
    export XCURSOR_THEME="WhiteSur-cursors"
    export KDE_COLOR_SCHEME="Nord Red Dark"
    # DO NOT override QT in KDE
    ;;

esac