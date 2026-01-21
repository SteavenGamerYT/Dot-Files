# Loop to add specified directories to the PATH if they exist
for dir in "$HOME/.bin" "$HOME/.local/bin" "$HOME/Applications" "/var/lib/flatpak/exports/bin" "$HOME/.spicetify" "/home/linuxbrew/.linuxbrew/bin" "/home/linuxbrew/.linuxbrew/sbin"; do
  [ -d "$dir" ] && PATH="$dir:$PATH"
done

# Enable Wayland support in Firefox if the session type is Wayland
 if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  export MOZ_ENABLE_WAYLAND=1
fi

export XDG_SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"  # Directory for storing screenshots
export GRIMSHOT_FILENAME_FORMAT="$(date '+%Y-%m-%d_%H-%M-%S')"
export EDITOR=nano

# Check the hostname and set the MANGOHUD_CONFIG variable accordingly
case "$(hostname)" in
    Omar-PC) export MANGOHUD_CONFIG="preset=5" ;;
    Omar-Laptop) export MANGOHUD_CONFIG="preset=8" ;;
    Omar-GamingLaptop) export MANGOHUD_CONFIG="preset=7" ;;
    dell-gaminglaptop) export MANGOHUD_CONFIG="preset=9" ;;
esac

export ELECTRON_OZONE_PLATFORM_HINT=auto



if [ "$XDG_SESSION_DESKTOP" = "none+i3" ] ||  [ "$XDG_SESSION_DESKTOP" = "i3" ] || [ "$XDG_SESSION_DESKTOP" = "sway" ] || [ "$XDG_SESSION_DESKTOP" = "Hyprland" ]; then
  
  # Set the GTK theme to use for applications
  export GTK_THEME=Mint-Y-Dark-Red

  # Set the Xcursor theme
  export XCURSOR_THEME=WhiteSur-cursors
fi

if [ "$XDG_SESSION_DESKTOP" = "none+i3" ] || [ "$XDG_SESSION_DESKTOP" = "i3" ] || [ "$XDG_SESSION_DESKTOP" = "sway" ] || [ "$XDG_SESSION_DESKTOP" = "Hyprland" ] || [ "$XDG_SESSION_DESKTOP" = "gnome" ] || [ "$XDG_SESSION_DESKTOP" = "gnome-wayland" ]; then
  # Override the default style for QT applications 
  export QT_STYLE_OVERRIDE=kvantum
  # Set Kvantum theme
  export KVANTUM_THEME=Nordic-Solid-Red

  # Set the platform theme for QT applications
  export QT_QPA_PLATFORMTHEME=qt6ct

  # Set the icon theme for the desktop environment
  export ICON_THEME=Papirus-Dark
  export QT_QPA_ICONTHEME=Papirus-Dark

  # Set the cursor theme across various environments
  export CURSOR_THEME=WhiteSur-cursors
  export QT_QT_CURSORTHEME=WhiteSur-cursors
  export QT_QT5_CURSORTHEME=WhiteSur-cursors
  export QT_QT6_CURSORTHEME=WhiteSur-cursors

  # Define the cursor size for different environments
  export CURSOR_SIZE=24
  export XCURSOR_SIZE=24
fi

if [ "$XDG_SESSION_DESKTOP" = "gnome" ] || [ "$XDG_SESSION_DESKTOP" = "gnome-wayland" ]; then
  
  # Set the platform theme for QT applications
  export QT_QPA_PLATFORMTHEME=qt6ct
  
  # Set the GTK theme to use for applications
 # export GTK_THEME=adw-gtk3-dark

  # Set the Xcursor theme
  export XCURSOR_THEME=WhiteSur-cursors
fi

if [ "$XDG_SESSION_DESKTOP" = "KDE" ]; then

  # Set the GTK theme to use for applications
  export GTK_THEME=Nordic

  # Set the Xcursor theme
  export XCURSOR_THEME=WhiteSur-cursors
fi
export KDE_COLOR_SCHEME="Nord Red Dark"