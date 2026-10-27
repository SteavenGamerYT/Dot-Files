#!/usr/bin/env bash
# ==============================================================================
# Dotfiles Updater
# Pulls latest changes from Git and refreshes symlinks safely.
# ==============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Pulling latest changes from repository..."
cd "$DOTFILES_DIR"
git pull --rebase

echo "==> Running installer to update symlinks..."
"$DOTFILES_DIR/install.sh" "$@"
