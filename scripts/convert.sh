#!/usr/bin/env bash

set -euo pipefail

# === Configuration ===
LOSSLESS_FORMAT="png"  # Change to "tiff" if you prefer TIFF
INPUT_DIR="."
HEIC_DIR="heic"
OUTPUT_DIR="$LOSSLESS_FORMAT"

# === Create Output Directories ===
echo "[INFO] Creating folders if they don't exist..."
mkdir -vp "$HEIC_DIR"
mkdir -vp "$OUTPUT_DIR"
echo "[INFO] Done creating folders."

# === Find and Convert HEIC Files ===
echo "[INFO] Searching for HEIC files in: $INPUT_DIR"
found_any=false
find "$INPUT_DIR" -type f -iname '*.heic' | while read -r heic_file; do
    found_any=true
    base_name="$(basename "$heic_file" .heic)"
    output_file="$OUTPUT_DIR/${base_name}.${LOSSLESS_FORMAT}"

    echo "[CONVERTING] '$heic_file' → '$output_file'..."
    
    # Convert with magick
    if magick "$heic_file" "$output_file"; then
        echo "[SUCCESS] Converted to: $output_file"
    else
        echo "[ERROR] Failed to convert: $heic_file" >&2
        continue
    fi

    # Move original file
    echo "[MOVING] Moving original to: $HEIC_DIR/"
    mv -v "$heic_file" "$HEIC_DIR/"
done

if ! $found_any; then
    echo "[INFO] No HEIC files found in directory: $INPUT_DIR"
else
    echo "[DONE] All HEIC files processed."
    echo "        Converted files are in: '$OUTPUT_DIR/'"
    echo "        Original files are in:  '$HEIC_DIR/'"
fi
