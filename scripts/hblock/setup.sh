#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

hblock \
  --allowlist "$SCRIPT_DIR/allowlist.txt" \
  --denylist "$SCRIPT_DIR/denylist.txt"
