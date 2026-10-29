#!/usr/bin/env bash
set -euo pipefail

# ==============================================================
# Universal System & Package Manager Cleanup Script
# Cleans up unused packages, old caches, build artifacts, logs,
# containers, and disabled revisions across Linux distros & macOS.
# ==============================================================

# ------------- Terminal Title Handling -------------
DEFAULT_TITLE="${USER}@${HOSTNAME:-$(hostname 2>/dev/null || echo "localhost")}: ${PWD}"

set_title() {
    printf '\033]0;%s\007' "$1"
}

restore_title() {
    printf '\033]0;%s\007' "$DEFAULT_TITLE"
}

# ------------- Sudo Credential Management -------------
SUDO=""
SUDO_PID=""

init_sudo() {
    # If already running as root, no sudo prefix is needed
    if [[ $EUID -eq 0 ]]; then
        SUDO=""
        return 0
    fi

    if command -v sudo &>/dev/null; then
        echo ">>> Requesting administrative privileges (sudo) upfront..."
        if sudo -v; then
            SUDO="sudo"
            # Background loop to refresh sudo timestamp every 50 seconds.
            # Automatically terminates when the parent script process ($$) exits.
            (
                while true; do
                    sudo -n true 2>/dev/null || exit
                    sleep 50
                    kill -0 "$$" 2>/dev/null || exit
                done
            ) &
            SUDO_PID=$!
        else
            echo ">>> Warning: Sudo authentication failed. Tasks requiring root may fail or prompt."
            SUDO="sudo"
        fi
    else
        SUDO=""
    fi
}

cleanup_exit() {
    restore_title
    if [[ -n "${SUDO_PID:-}" ]]; then
        kill "$SUDO_PID" 2>/dev/null || true
    fi
}

# Always restore title and kill background sudo keepalive on exit/interrupt
trap cleanup_exit EXIT INT TERM

# ------------- Notifications -------------
send_notification() {
    local title="${1:-Cleanup Script}"
    local message="${2:-All cleanup tasks completed successfully!}"
    
    if command -v notify-send &>/dev/null; then
        notify-send -i "system-software-update" "$title" "$message" 2>/dev/null || notify-send "$title" "$message" 2>/dev/null || true
    else
        echo ">>> $title: $message"
    fi
}

# ------------- Disk Usage Measurement Helpers -------------
get_free_kb() {
    df -Pk "${1:-/}" 2>/dev/null | awk 'NR==2 {print $4}'
}

format_kb() {
    local kb=${1:-0}
    if (( kb >= 1048576 )); then
        awk -v k="$kb" 'BEGIN {printf "%.2f GB", k/1048576}'
    elif (( kb >= 1024 )); then
        awk -v k="$kb" 'BEGIN {printf "%.2f MB", k/1024}'
    else
        echo "${kb} KB"
    fi
}

# ==============================================================
# Cleanup Tasks: Package Managers
# ==============================================================

# ------------- Pacman (Arch Linux) -------------
cleanup_pacman() {
    set_title "Cleaning Pacman"
    echo ">>> Running cleanup for Pacman..."
    local orphans
    orphans=$(pacman -Qtdq 2>/dev/null || true)
    if [[ -n "$orphans" ]]; then
        echo "Removing unneeded orphan packages..."
        $SUDO pacman -Rns --noconfirm $orphans 2>/dev/null || true
    else
        echo "No unused packages found for Pacman."
    fi
    echo
}

cleanup_pacman_cache() {
    set_title "Cleaning Pacman Cache"
    echo ">>> Running cleanup for Pacman cache..."
    if command -v paccache &>/dev/null; then
        echo "Using paccache (keeping 2 most recent versions and cleaning uninstalled)..."
        $SUDO paccache -r -k 2 2>/dev/null || true
        $SUDO paccache -ruk0 2>/dev/null || true
    else
        echo "Cleaning uninstalled and old packages from pacman cache..."
        $SUDO pacman -Sc --noconfirm 2>/dev/null || true
    fi
    echo
}

# ------------- Paru (AUR Helper) -------------
cleanup_paru() {
    set_title "Cleaning Paru"
    echo ">>> Running cleanup for Paru..."
    local orphans
    orphans=$(paru -Qtdq 2>/dev/null || true)
    if [[ -n "$orphans" ]]; then
        echo "Removing unneeded packages via Paru..."
        paru -Rns --noconfirm $orphans 2>/dev/null || true
    else
        echo "No unused packages found for Paru."
    fi
    echo
}

cleanup_paru_cache() {
    set_title "Cleaning Paru Cache"
    echo ">>> Running cleanup for Paru cache and build artifacts..."
    paru -Sc --noconfirm 2>/dev/null || true
    
    local paru_clone="${XDG_CACHE_HOME:-$HOME/.cache}/paru/clone"
    if [[ -d "$paru_clone" ]]; then
        echo "Removing built packages and source directories in $paru_clone..."
        find "$paru_clone" -type f -name "*.pkg.tar.*" -delete 2>/dev/null || true
        find "$paru_clone" -mindepth 2 -maxdepth 2 -type d \( -name "src" -o -name "pkg" \) -exec rm -rf {} + 2>/dev/null || true
    fi
    echo
}

# ------------- Yay (AUR Helper) -------------
cleanup_yay() {
    set_title "Cleaning Yay"
    echo ">>> Running cleanup for Yay..."
    local orphans
    orphans=$(yay -Qtdq 2>/dev/null || true)
    if [[ -n "$orphans" ]]; then
        echo "Removing unneeded packages via Yay..."
        yay -Rns --noconfirm $orphans 2>/dev/null || true
    else
        echo "No unused packages found for Yay."
    fi
    echo
}

cleanup_yay_cache() {
    set_title "Cleaning Yay Cache"
    echo ">>> Running cleanup for Yay cache and build artifacts..."
    yay -Sc --noconfirm 2>/dev/null || true

    local yay_cache="${XDG_CACHE_HOME:-$HOME/.cache}/yay"
    if [[ -d "$yay_cache" ]]; then
        echo "Removing built packages and source directories in $yay_cache..."
        find "$yay_cache" -type f -name "*.pkg.tar.*" -delete 2>/dev/null || true
        find "$yay_cache" -mindepth 2 -maxdepth 2 -type d \( -name "src" -o -name "pkg" \) -exec rm -rf {} + 2>/dev/null || true
    fi
    echo
}

# ------------- APT (Debian / Ubuntu / Mint) -------------
cleanup_apt() {
    set_title "Cleaning APT"
    echo ">>> Running cleanup for APT..."
    $SUDO apt-get autoremove --purge -y 2>/dev/null || true
    $SUDO apt-get autoclean -y 2>/dev/null || true
    $SUDO apt-get clean 2>/dev/null || true
    echo
}

# ------------- DNF (Fedora / RHEL) -------------
cleanup_dnf() {
    set_title "Cleaning DNF"
    echo ">>> Running cleanup for DNF..."
    $SUDO dnf autoremove -y 2>/dev/null || true
    $SUDO dnf clean all 2>/dev/null || true
    echo
}

# ------------- Zypper (openSUSE) -------------
cleanup_zypper() {
    set_title "Cleaning Zypper"
    echo ">>> Running cleanup for Zypper..."
    $SUDO zypper clean --all 2>/dev/null || true
    echo
}

# ------------- Flatpak -------------
cleanup_flatpak_user() {
    set_title "Cleaning Flatpak (User)"
    echo ">>> Running user-level Flatpak cleanup..."
    flatpak uninstall --unused -y 2>/dev/null || true
    echo
}

cleanup_flatpak_system() {
    set_title "Cleaning Flatpak (System)"
    echo ">>> Running system-level Flatpak cleanup..."
    $SUDO flatpak uninstall --unused -y 2>/dev/null || true
    echo
}

# ------------- Snap -------------
cleanup_snap() {
    set_title "Cleaning Snap"
    echo ">>> Running cleanup for Snap (disabled revisions)..."
    local disabled_snaps
    disabled_snaps=$(snap list --all 2>/dev/null | awk '/disabled/{print $1, $3}' || true)
    if [[ -n "$disabled_snaps" ]]; then
        while read -r name rev; do
            echo "Removing disabled snap: $name (revision $rev)..."
            $SUDO snap remove "$name" --revision="$rev" 2>/dev/null || true
        done <<< "$disabled_snaps"
    else
        echo "No disabled snap revisions found."
    fi
    echo
}

# ------------- NixOS / Nix -------------
cleanup_nixos() {
    set_title "Cleaning Nix"
    echo ">>> Running cleanup for Nix..."
    if [[ $EUID -eq 0 ]] || [[ -n "$SUDO" ]]; then
        $SUDO nix-collect-garbage -d 2>/dev/null || true
    fi
    if [[ $EUID -ne 0 ]]; then
        nix-collect-garbage -d 2>/dev/null || true
    fi
    echo "Nix garbage collection finished."
    echo
}

# ------------- Homebrew (macOS / Linux) -------------
cleanup_brew() {
    set_title "Cleaning Homebrew"
    echo ">>> Running cleanup for Homebrew..."
    brew autoremove -q 2>/dev/null || true
    brew cleanup --prune=all -s -q 2>/dev/null || true
    local brew_cache
    brew_cache=$(brew --cache 2>/dev/null || true)
    if [[ -n "$brew_cache" && -d "$brew_cache" ]]; then
        rm -rf "$brew_cache"/* 2>/dev/null || true
    fi
    echo
}

# ==============================================================
# Cleanup Tasks: Containers & Virtualization
# ==============================================================

# ------------- Docker -------------
cleanup_docker() {
    set_title "Cleaning Docker"
    echo ">>> Checking Docker daemon status..."
    if docker info &>/dev/null || $SUDO docker info &>/dev/null; then
        echo ">>> Running cleanup for Docker (unused images, containers, networks, volumes)..."
        $SUDO docker system prune -a --volumes --force 2>/dev/null || true
        echo ">>> Pruning Docker build cache..."
        $SUDO docker builder prune -a --force 2>/dev/null || true
    else
        echo "Docker daemon is not running. Skipping Docker cleanup."
    fi
    echo
}

# ------------- Podman -------------
cleanup_podman() {
    set_title "Cleaning Podman"
    echo ">>> Running cleanup for Podman..."
    podman system prune -a --volumes --force 2>/dev/null || true
    echo
}

# ==============================================================
# Cleanup Tasks: System Logs & Temporary Files
# ==============================================================

# ------------- systemd Journal Logs -------------
cleanup_journal() {
    set_title "Vacuuming System Journals"
    echo ">>> Vacuuming systemd journals (retaining 7 days, max 100M)..."
    $SUDO journalctl --vacuum-time=7d --vacuum-size=100M 2>/dev/null || true
    echo
}

# ------------- Coredumps & Crash Reports -------------
cleanup_coredumps() {
    set_title "Cleaning Coredumps"
    echo ">>> Running cleanup for system coredumps..."
    if command -v coredumpctl &>/dev/null; then
        $SUDO coredumpctl vacuum 2>/dev/null || true
    fi
    if [[ -d "/var/lib/systemd/coredump" ]]; then
        $SUDO find /var/lib/systemd/coredump -type f -mtime +7 -delete 2>/dev/null || true
    fi
    echo
}

# ------------- systemd Tempfiles -------------
cleanup_system_tmp() {
    set_title "Cleaning System Tempfiles"
    echo ">>> Running systemd-tmpfiles cleanup..."
    $SUDO systemd-tmpfiles --clean 2>/dev/null || true
    echo
}

# ==============================================================
# Cleanup Tasks: Desktop & User Caches
# ==============================================================

# ------------- Thumbnail Cache -------------
cleanup_thumbnails() {
    set_title "Cleaning Thumbnails"
    echo ">>> Cleaning thumbnail cache..."
    local thumb_dir="${XDG_CACHE_HOME:-$HOME/.cache}/thumbnails"
    if [[ -d "$thumb_dir" ]]; then
        local size_before
        size_before=$(du -sh "$thumb_dir" 2>/dev/null | awk '{print $1}')
        rm -rf "$thumb_dir"/* 2>/dev/null || true
        echo "Cleaned thumbnail cache (freed: ${size_before:-0B})."
    else
        echo "Thumbnail cache directory is already clean."
    fi
    echo
}

# ------------- User Trash -------------
cleanup_trash() {
    set_title "Cleaning Trash"
    echo ">>> Cleaning Trash (purging items older than 14 days)..."
    if command -v trash-empty &>/dev/null; then
        trash-empty -f 14 2>/dev/null || true
        echo "Emptied trash items older than 14 days."
    elif [[ -d "${XDG_DATA_HOME:-$HOME/.local/share}/Trash" ]]; then
        local trash_dir="${XDG_DATA_HOME:-$HOME/.local/share}/Trash"
        find "$trash_dir/files" "$trash_dir/info" -mindepth 1 -mtime +14 -delete 2>/dev/null || true
        echo "Emptied trash items older than 14 days from $trash_dir."
    else
        echo "Trash directory is clean."
    fi
    echo
}

# ==============================================================
# Cleanup Tasks: Developer Tools & Language Package Caches
# ==============================================================

cleanup_dev_caches() {
    set_title "Cleaning Dev Caches"
    local cleaned_any=false

    # Node.js: npm, yarn, pnpm
    if command -v npm &>/dev/null; then
        echo ">>> Cleaning npm cache..."
        npm cache clean --force 2>/dev/null || true
        cleaned_any=true
    fi
    if command -v yarn &>/dev/null; then
        echo ">>> Cleaning Yarn cache..."
        yarn cache clean 2>/dev/null || true
        cleaned_any=true
    fi
    if command -v pnpm &>/dev/null; then
        echo ">>> Pruning pnpm store..."
        pnpm store prune 2>/dev/null || true
        cleaned_any=true
    fi

    # Python: pip
    if command -v pip &>/dev/null; then
        echo ">>> Purging pip cache..."
        pip cache purge 2>/dev/null || true
        cleaned_any=true
    elif command -v pip3 &>/dev/null; then
        echo ">>> Purging pip3 cache..."
        pip3 cache purge 2>/dev/null || true
        cleaned_any=true
    fi

    # Rust: cargo-cache
    if command -v cargo-cache &>/dev/null; then
        echo ">>> Running cargo-cache autoclean..."
        cargo-cache --autoclean 2>/dev/null || true
        cleaned_any=true
    fi

    # Go build cache
    if command -v go &>/dev/null; then
        echo ">>> Cleaning Go build cache..."
        go clean -cache 2>/dev/null || true
        cleaned_any=true
    fi

    # PHP: Composer
    if command -v composer &>/dev/null; then
        echo ">>> Cleaning Composer cache..."
        composer clear-cache 2>/dev/null || true
        cleaned_any=true
    fi

    # Ruby: Gem
    if command -v gem &>/dev/null; then
        echo ">>> Cleaning old Ruby gems..."
        gem cleanup 2>/dev/null || true
        cleaned_any=true
    fi

    if [[ "$cleaned_any" = false ]]; then
        echo "No developer tool caches detected to clean."
    fi
    echo
}

# ==============================================================
# Main Orchestration Logic
# ==============================================================

echo "=============================================================="
echo " Starting System & Package Cleanup"
echo "=============================================================="

# 1. Initialize sudo once upfront with automated keep-alive
init_sudo

# 2. Record initial disk space
ROOT_DEV=$(df -Pk / 2>/dev/null | awk 'NR==2 {print $1}')
HOME_DEV=$(df -Pk "$HOME" 2>/dev/null | awk 'NR==2 {print $1}')

ROOT_START_KB=$(get_free_kb /)
HOME_START_KB=$(get_free_kb "$HOME")

# 3. System Package Managers
if command -v pacman &>/dev/null; then
    cleanup_pacman
    cleanup_pacman_cache
else
    echo "Skipping Pacman cleanup (not installed)."
fi

if command -v paru &>/dev/null; then
    cleanup_paru
    cleanup_paru_cache
else
    echo "Skipping Paru cleanup (not installed)."
fi

if command -v yay &>/dev/null; then
    cleanup_yay
    cleanup_yay_cache
else
    echo "Skipping Yay cleanup (not installed)."
fi

if command -v apt-get &>/dev/null || command -v apt &>/dev/null; then
    cleanup_apt
else
    echo "Skipping APT cleanup (not installed)."
fi

if command -v dnf &>/dev/null; then
    cleanup_dnf
else
    echo "Skipping DNF cleanup (not installed)."
fi

if command -v zypper &>/dev/null; then
    cleanup_zypper
else
    echo "Skipping Zypper cleanup (not installed)."
fi

if command -v nix-collect-garbage &>/dev/null; then
    cleanup_nixos
else
    echo "Skipping Nix cleanup (not installed)."
fi

if command -v brew &>/dev/null; then
    cleanup_brew
else
    echo "Skipping Homebrew cleanup (not installed)."
fi

# 4. Universal Application Runtimes
if command -v flatpak &>/dev/null; then
    cleanup_flatpak_user
    cleanup_flatpak_system
else
    echo "Skipping Flatpak cleanup (not installed)."
fi

if command -v snap &>/dev/null; then
    cleanup_snap
else
    echo "Skipping Snap cleanup (not installed)."
fi

# 5. Containers
if command -v docker &>/dev/null; then
    cleanup_docker
else
    echo "Skipping Docker cleanup (not installed)."
fi

if command -v podman &>/dev/null; then
    cleanup_podman
else
    echo "Skipping Podman cleanup (not installed)."
fi

# 6. System Logs & Temporary Files
if command -v journalctl &>/dev/null; then
    cleanup_journal
fi

if command -v coredumpctl &>/dev/null || [[ -d "/var/lib/systemd/coredump" ]]; then
    cleanup_coredumps
fi

if command -v systemd-tmpfiles &>/dev/null; then
    cleanup_system_tmp
fi

# 7. Desktop & User Caches
cleanup_thumbnails
cleanup_trash

# 8. Developer Package Caches
cleanup_dev_caches

# 9. Record final disk space and display summary
ROOT_END_KB=$(get_free_kb /)
HOME_END_KB=$(get_free_kb "$HOME")

ROOT_DIFF=$(( ROOT_END_KB - ROOT_START_KB ))
HOME_DIFF=$(( HOME_END_KB - HOME_START_KB ))

echo "=============================================================="
echo " Cleanup Summary"
echo "=============================================================="

TOTAL_RECLAIMED=0

if [[ "$ROOT_DEV" == "$HOME_DEV" ]]; then
    echo "  Partition (/):        $(format_kb "$ROOT_START_KB") -> $(format_kb "$ROOT_END_KB") free"
    if (( ROOT_DIFF > 0 )); then
        TOTAL_RECLAIMED=$ROOT_DIFF
        echo "  Space reclaimed:      ~$(format_kb "$ROOT_DIFF")"
        NOTIF_MSG="Cleanup complete! Freed ~$(format_kb "$ROOT_DIFF") of disk space."
    else
        echo "  Space reclaimed:      < 1 MB (disk was already clean)"
        NOTIF_MSG="Cleanup complete! Disk was already clean."
    fi
else
    echo "  Root partition (/):     $(format_kb "$ROOT_START_KB") -> $(format_kb "$ROOT_END_KB") free"
    echo "  Home partition (/home): $(format_kb "$HOME_START_KB") -> $(format_kb "$HOME_END_KB") free"
    
    (( ROOT_DIFF > 0 )) && TOTAL_RECLAIMED=$(( TOTAL_RECLAIMED + ROOT_DIFF ))
    (( HOME_DIFF > 0 )) && TOTAL_RECLAIMED=$(( TOTAL_RECLAIMED + HOME_DIFF ))
    
    if (( TOTAL_RECLAIMED > 0 )); then
        echo "  Total space reclaimed:  ~$(format_kb "$TOTAL_RECLAIMED")"
        NOTIF_MSG="Cleanup complete! Freed ~$(format_kb "$TOTAL_RECLAIMED") across / and /home."
    else
        echo "  Total space reclaimed:  < 1 MB (disks were already clean)"
        NOTIF_MSG="Cleanup complete! Disks were already clean."
    fi
fi
echo "=============================================================="

send_notification "Cleanup Complete" "$NOTIF_MSG"