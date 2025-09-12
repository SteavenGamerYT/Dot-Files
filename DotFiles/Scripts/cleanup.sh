#!/usr/bin/env bash
set -euo pipefail

# ==============================================================
# Universal Package Manager Cleanup Script
# Cleans up unused packages, old caches, and disabled revisions
# across different Linux distros and macOS.
# ==============================================================

# ------------- Pacman -------------
cleanup_pacman() {
    echo ">>> Running cleanup for Pacman..."
    local orphans
    orphans=$(pacman -Qtdq || true)
    if [[ -n "$orphans" ]]; then
        sudo pacman -Rns --noconfirm $orphans
    else
        echo "No unused packages found for Pacman."
    fi
    echo
}

cleanup_pacman_cache() {
    echo ">>> Running cleanup for Pacman cache..."
    sudo pacman -Sc --noconfirm
    echo
}

# ------------- Paru -------------
cleanup_paru() {
    echo ">>> Running cleanup for Paru..."
    local orphans
    orphans=$(paru -Qtdq || true)
    if [[ -n "$orphans" ]]; then
        paru -Rns --noconfirm $orphans
    else
        echo "No unused packages found for Paru."
    fi
    echo
}

cleanup_paru_cache() {
    echo ">>> Running cleanup for Paru cache..."
    paru -Sc --noconfirm
    echo
}

# ------------- APT -------------
cleanup_apt() {
    echo ">>> Running cleanup for APT..."
    sudo apt autoremove --purge -y
    sudo apt clean
    echo
}

# ------------- DNF -------------
cleanup_dnf() {
    echo ">>> Running cleanup for DNF..."
    sudo dnf autoremove -y
    sudo dnf clean all -y
    echo
}

# ------------- Flatpak -------------
cleanup_flatpak_user() {
    echo ">>> Running user-level Flatpak cleanup..."
    flatpak remove --unused -y || true
    echo
}

cleanup_flatpak_system() {
    echo ">>> Running system-level Flatpak cleanup..."
    sudo flatpak remove --unused -y || true
    echo
}

# ------------- Snap -------------
cleanup_snap() {
    echo ">>> Running cleanup for Snap..."
    while read -r name rev; do
        sudo snap remove "$name" --revision="$rev"
    done < <(snap list --all | awk '/disabled/{print $1, $3}')
    echo
}

# ------------- NixOS -------------
cleanup_nixos() {
    echo ">>> Running cleanup for NixOS..."
    sudo nix-collect-garbage -d
    echo "NixOS garbage collected."
    # Uncomment this if you want to always reset boot configuration:
    # sudo /run/current-system/bin/switch-to-configuration boot
    echo
}

# ------------- Homebrew -------------
cleanup_brew() {
    echo ">>> Running cleanup for Homebrew..."
    brew autoremove -q
    brew cleanup -s -q
    echo
}

# ==============================================================
# Main Logic
# ==============================================================

if command -v nix-collect-garbage &>/dev/null; then
    cleanup_nixos
else
    echo "Skipping NixOS cleanup (not installed)."
fi

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

if command -v apt &>/dev/null; then
    cleanup_apt
else
    echo "Skipping APT cleanup (not installed)."
fi

if command -v dnf &>/dev/null; then
    cleanup_dnf
else
    echo "Skipping DNF cleanup (not installed)."
fi

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

if command -v brew &>/dev/null; then
    cleanup_brew
else
    echo "Skipping Homebrew cleanup (not installed)."
fi

echo ">>> All cleanup tasks complete!"
