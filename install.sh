#!/usr/bin/env bash
# ==============================================================================
# Dotfiles Installer
# Safely links dotfiles and configurations to $HOME with automatic backups.
# ==============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
BACKUP_DIR="$HOME/.dotfiles_backup/$BACKUP_TIMESTAMP"

DRY_RUN=false
FORCE=false

# ------------------------------------------------------------------------------
# Helpers & CLI arguments
# ------------------------------------------------------------------------------
usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -d, --dry-run   Show actions that would be taken without modifying anything
  -f, --force     Skip backup and force-link
  -h, --help      Display this help message
EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--dry-run) DRY_RUN=true; shift ;;
        -f|--force)   FORCE=true; shift ;;
        -h|--help)    usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

# Color output helpers
green() { printf "\033[1;32m%s\033[0m\n" "$*"; }
yellow() { printf "\033[1;33m%s\033[0m\n" "$*"; }
blue() { printf "\033[1;34m%s\033[0m\n" "$*"; }

# ------------------------------------------------------------------------------
# Link function with safe backup
# ------------------------------------------------------------------------------
link_target() {
    local src="$1"
    local dest="$2"

    # Destination parent directory
    local dest_dir
    dest_dir="$(dirname "$dest")"

    # Skip if already correctly linked
    if [ -L "$dest" ]; then
        local current_target
        current_target="$(readlink "$dest")"
        if [ "$current_target" = "$src" ] || [ "$(readlink -f "$dest" 2>/dev/null || true)" = "$(readlink -f "$src" 2>/dev/null || true)" ]; then
            return 0
        fi
    fi

    if [ "$DRY_RUN" = true ]; then
        if [ -e "$dest" ] || [ -L "$dest" ]; then
            echo "  [would backup] $dest -> $BACKUP_DIR/${dest#$HOME/}"
        fi
        echo "  [would link]   $dest -> $src"
        return 0
    fi

    # Create destination parent directory if missing
    mkdir -p "$dest_dir"

    # Backup existing file / directory / wrong symlink
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ "$FORCE" = false ]; then
            mkdir -p "$BACKUP_DIR/$(dirname "${dest#$HOME/}")"
            mv "$dest" "$BACKUP_DIR/${dest#$HOME/}"
            yellow "  [backup] $dest -> $BACKUP_DIR/${dest#$HOME/}"
        else
            rm -rf "$dest"
        fi
    fi

    ln -s "$src" "$dest"
    green "  [linked] $dest -> $src"
}

# ------------------------------------------------------------------------------
# Distribution-specific setup
# ------------------------------------------------------------------------------
if [ -r /etc/os-release ]; then
    source /etc/os-release

    if [[ "${ID:-}" =~ ^[Ss]teaven[Ll]inux$ ]]; then
        blue "==> SteavenLinux detected."

        STEAVEN_PACKAGES=(
            # Adwaita
            adwaita-icon-theme
            adwaita-icon-theme-legacy
            adwaita-fonts

            # Fluent
            fluent-cursor-theme-git
            fluent-gtk-theme-git
            fluent-icon-theme-git

            # Mint
            mint-themes

            # Nordic
            nordic-theme-git
            nordzy-cursors

            # Papirus
            papirus-icon-theme
            papirus-folders

            # WhiteSur
            whitesur-cursor-theme-git

            # Fonts
            ttf-hack
            ttf-liberation
            ttf-ms-win10-auto
            ttf-roboto
            ttf-roboto-mono-nerd
            ttf-ubuntu-font-family

            # Noto
            noto-fonts
            noto-fonts-ar
            noto-fonts-cjk
            noto-fonts-emoji
        )

        if [ "$DRY_RUN" = true ]; then
            yellow "  [would update] paru -Syu --needed --noconfirm"
            yellow "  [would install] ${STEAVEN_PACKAGES[*]}"
        else
            blue "==> Updating package database and installing SteavenLinux packages..."

            paru -Syu --needed --noconfirm "${STEAVEN_PACKAGES[@]}"
        fi
    fi
fi

# ------------------------------------------------------------------------------
# Main installation process
# ------------------------------------------------------------------------------
blue "==> Installing dotfiles from: $DOTFILES_DIR"

if [ "$DRY_RUN" = true ]; then
    yellow "Running in DRY-RUN mode. No changes will be written."
fi

# Ensure base target directories exist
if [ "$DRY_RUN" = false ]; then
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.ssh"
    mkdir -p "$HOME/.local/share"
    mkdir -p "$HOME/.var/app/io.mpv.Mpv/config"
fi

# 1. Compatibility symlink for legacy ~/DotFiles path
blue "--> Setting up ~/DotFiles compatibility symlink..."
link_target "$DOTFILES_DIR" "$HOME/DotFiles"

# 2. Home root dotfiles
blue "--> Linking shell and home configurations..."
HOME_FILES=(
    ".bash-default"
    ".bashrc"
    ".nanorc"
    ".p10k.zsh"
    ".profile"
    ".steavengameryt"
    ".zprofile"
    ".zshenv"
    ".zshrc"
    "theme-bash"
)

for file in "${HOME_FILES[@]}"; do
    if [ -f "$DOTFILES_DIR/$file" ]; then
        link_target "$DOTFILES_DIR/$file" "$HOME/$file"
    fi
done

# 3. SSH Configuration
if [ -f "$DOTFILES_DIR/.ssh/config" ]; then
    blue "--> Linking SSH configuration..."
    link_target "$DOTFILES_DIR/.ssh/config" "$HOME/.ssh/config"
fi

# 4. Applications in .config/
blue "--> Linking .config directories and files..."
for item in "$DOTFILES_DIR/.config"/*; do
    [ -e "$item" ] || continue
    name="$(basename "$item")"
    link_target "$item" "$HOME/.config/$name"
done

# 5. Specialized application links
blue "--> Linking specialized application data..."

# MPV Flatpak override config
if [ -d "$DOTFILES_DIR/.config/mpv" ]; then
    link_target "$DOTFILES_DIR/.config/mpv" "$HOME/.var/app/io.mpv.Mpv/config/mpv"
fi

# Flatpak overrides
if [ -d "$DOTFILES_DIR/.local/share/flatpak/overrides" ]; then
    link_target "$DOTFILES_DIR/.local/share/flatpak/overrides" "$HOME/.local/share/flatpak/overrides"
fi

# Nemo actions & scripts
if [ -d "$DOTFILES_DIR/.local/share/nemo" ]; then
    link_target "$DOTFILES_DIR/.local/share/nemo" "$HOME/.local/share/nemo"
fi

# KDE Color Schemes
if [ -d "$DOTFILES_DIR/.local/share/color-schemes" ]; then
    link_target "$DOTFILES_DIR/.local/share/color-schemes" "$HOME/.local/share/color-schemes"
fi

# Initialize default GTK configurations if missing
if [ "$DRY_RUN" = false ]; then
    mkdir -p "$DOTFILES_DIR/.config/gtk-3.0" "$DOTFILES_DIR/.config/gtk-4.0"
    if [ ! -f "$DOTFILES_DIR/.config/gtk-3.0/settings.ini" ]; then
        cat <<'EOF' > "$DOTFILES_DIR/.config/gtk-3.0/settings.ini"
[Settings]
gtk-theme-name=Nordic
gtk-icon-theme-name=Papirus-Dark
gtk-cursor-theme-name=Nordzy-cursors
gtk-cursor-theme-size=24
gtk-font-name=Roboto Regular 12
gtk-application-prefer-dark-theme=1
gtk-enable-animations=true
gtk-decoration-layout=icon:minimize,maximize,close
EOF
    fi
    if [ ! -f "$DOTFILES_DIR/.config/gtk-4.0/settings.ini" ]; then
        cp -f "$DOTFILES_DIR/.config/gtk-3.0/settings.ini" "$DOTFILES_DIR/.config/gtk-4.0/settings.ini"
    fi
    if [ ! -f "$DOTFILES_DIR/.config/gtk-3.0/gtk.css" ]; then
        echo "@import 'colors.css';" > "$DOTFILES_DIR/.config/gtk-3.0/gtk.css"
    fi
    if [ ! -e "$DOTFILES_DIR/.config/gtk-4.0/gtk.css" ] && [ -f "$DOTFILES_DIR/.config/gtk-4.0/gtk-nordic.css" ]; then
        ln -sfn gtk-nordic.css "$DOTFILES_DIR/.config/gtk-4.0/gtk.css"
        ln -sfn gtk-nordic.css "$DOTFILES_DIR/.config/gtk-4.0/gtk-dark.css"
    fi
fi

# Make scripts executable
if [ "$DRY_RUN" = false ]; then
    find "$DOTFILES_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} + 2>/dev/null || true
    [ -f "$DOTFILES_DIR/theme.sh" ] && chmod +x "$DOTFILES_DIR/theme.sh"
    [ -f "$DOTFILES_DIR/theme2.sh" ] && chmod +x "$DOTFILES_DIR/theme2.sh"
    [ -f "$DOTFILES_DIR/theme3.sh" ] && chmod +x "$DOTFILES_DIR/theme3.sh"
fi

echo ""
if [ -d "$BACKUP_DIR" ]; then
    yellow "Existing files were backed up to: $BACKUP_DIR"
fi
green "==> Dotfiles setup completed successfully!"