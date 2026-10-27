# Add user's custom binaries directory to PATH
[ -d "$HOME/.bin" ] && PATH="$HOME/.bin:$PATH"

# Add user's local binaries directory to PATH
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

# Add custom Applications directory to PATH
[ -d "$HOME/Applications" ] && PATH="$HOME/Applications:$PATH"

# Add Flatpak binaries directory to PATH
[ -d "/var/lib/flatpak/exports/bin/" ] && PATH="/var/lib/flatpak/exports/bin/:$PATH"

# Add Spicetify directory to PATH
SPICETIFY_DIR="$HOME/.spicetify"
[ -d "$SPICETIFY_DIR" ] && PATH="$SPICETIFY_DIR:$PATH"

# Add Linuxbrew binaries directory to PATH
LINUXBREW_DIR="/home/linuxbrew/.linuxbrew/bin"
[ -d "$LINUXBREW_DIR" ] && PATH="$LINUXBREW_DIR:$PATH"

# Run Firefox in Wayland Native if Wayland is detected
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
fi
export __GL_SHADER_DISK_CACHE=1
export __GL_SHADER_DISK_CACHE_SIZE=100000000000 
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
export XDG_SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"
skip_global_compinit=1