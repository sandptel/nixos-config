#!/bin/bash

set -euo pipefail

# Define variables
SRC_FILE="$HOME/.cache/wal/spicetify.ini"
DEST_DIR="$HOME/.config/spicetify/Themes/Pywal"
DEST_FILE="$DEST_DIR/color.ini"

# Ensure destination directory exists
mkdir -p "$DEST_DIR"

# Copy and rename the file in one step
cp -r "$SRC_FILE" "$DEST_FILE"

spicetify refresh
