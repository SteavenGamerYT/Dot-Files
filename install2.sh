
#!/usr/bin/env bash
set -Eeuo pipefail

THEMES_DIR="/usr/share/themes"
ICONS_DIR="/usr/share/icons"

LOCAL_THEMES="$HOME/.local/share/themes"
LOCAL_ICONS="$HOME/.local/share/icons"

THEMES=(
    "Mint-Y-Dark-Red"
    "Fluent-Dark"
    "Nordic"
)

ICONS=(
    "Fluent-dark"
    "Fluent-dark-cursors"
    "Nordzy-cursors"
    "WhiteSur-cursors"
)

blue()  { printf '\033[1;34m%s\033[0m\n' "$*"; }
green() { printf '\033[1;32m%s\033[0m\n' "$*"; }
yellow() { printf '\033[1;33m%s\033[0m\n' "$*"; }

mkdir -p "$LOCAL_THEMES" "$LOCAL_ICONS"

sync_items() {
    local source_dir="$1"
    local destination_dir="$2"
    shift 2

    local item source destination

    for item in "$@"; do
        source="$source_dir/$item"
        destination="$destination_dir/$item"

        if [[ ! -d "$source" ]]; then
            yellow "Skipping missing source: $source"
            continue
        fi

        blue "Updating $item..."

        # Remove the old local copy, if present.
        rm -rf -- "$destination"

        # Copy the latest system version.
        cp -a -- "$source" "$destination"

        green "Updated $item"
    done
}

blue "==> Syncing desktop themes..."
sync_items "$THEMES_DIR" "$LOCAL_THEMES" "${THEMES[@]}"

blue "==> Syncing icon and cursor themes..."
sync_items "$ICONS_DIR" "$LOCAL_ICONS" "${ICONS[@]}"

green "==> Theme and cursor sync complete!"
