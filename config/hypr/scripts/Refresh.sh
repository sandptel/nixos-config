#!/bin/bash
# /* ---- 👒 https://github.com/sandptel/nixos-config ---- */  ##
# Scripts for refreshing waybar, rofi, swaync, wallust

set -euo pipefail  # Exit on error, undefined vars, pipe failures

SCRIPTSDIR="$HOME/.config/hypr/scripts"

# Define file_exists function
file_exists() {
    [[ -e "$1" ]]
}

# Kill processes only if they're running to avoid unnecessary kills
processes_to_kill=(waybar rofi swaync)
for process in "${processes_to_kill[@]}"; do
    if pidof "$process" >/dev/null 2>&1; then
        echo "Stopping $process..."
        pkill "$process" || echo "Warning: Failed to kill $process" >&2
    fi
done

# Kill waybar wrapper if running
if pidof .waybar-wrapped >/dev/null 2>&1; then
    echo "Stopping waybar wrapper..."
    pkill .waybar-wrapped || echo "Warning: Failed to kill waybar wrapper" >&2
fi

# Run wallust script if available
if [[ -x "$SCRIPTSDIR/WallustSwww.sh" ]]; then
    echo "Running WallustSwww.sh..."
    "$SCRIPTSDIR/WallustSwww.sh" || echo "Warning: WallustSwww.sh failed" >&2
else
    echo "Warning: WallustSwww.sh not found or not executable" >&2
fi

# Update pywalfox if available
if command -v pywalfox >/dev/null 2>&1; then
    echo "Updating pywalfox..."
    pywalfox update 2>/dev/null || echo "Warning: pywalfox update failed" >&2
fi

# Check if Obsidian script exists and run it
obsidian_script="$HOME/.config/hypr/UserScripts/Obsidian.sh"
if [[ -x "$obsidian_script" ]]; then
    echo "Running Obsidian.sh..."
    "$obsidian_script" || echo "Warning: Obsidian.sh failed" >&2
fi

# Restart waybar
echo "Starting waybar..."
if command -v waybar >/dev/null 2>&1; then
    waybar >/dev/null 2>&1 &
    disown
else
    echo "Warning: waybar not found" >&2
fi

# Relaunch swaync
echo "Starting swaync..."
if command -v swaync >/dev/null 2>&1; then
    swaync >/dev/null 2>&1 &
else
    echo "Warning: swaync not found" >&2
fi

exit 0
