#!/bin/bash
# /* ---- 👒 https://github.com/sandptel/nixos-config ---- */  ##
# Script for Random Wallpaper ( CTRL ALT W)

set -euo pipefail  # Exit on error, undefined vars, pipe failures

allwallDIR="$HOME/Pictures/wallpapers"
wallDIR="/home/roronoa/Pictures/wallpapers/Gifs/GOOD_GIFS/BEST_GIFS/"
scriptsDir="$HOME/.config/hypr/scripts"

# Check if gif directory exists
if [[ ! -d "$wallDIR" ]]; then
    echo "Error: GIF directory $wallDIR does not exist" >&2
    exit 1
fi

# Check if fallback directory exists
if [[ ! -d "$allwallDIR" ]]; then
    echo "Error: Fallback wallpaper directory $allwallDIR does not exist" >&2
    exit 1
fi

# Get last wallpaper with error handling
last_wallpaper=""
if [[ -f "$wallDIR/current_wallpaper.txt" ]]; then
    last_wallpaper=$(cat "$wallDIR/current_wallpaper.txt" 2>/dev/null || echo "")
fi

# Clean up old tracking files safely
find "$wallDIR" -type f -name "*.txt" -delete 2>/dev/null || true

# Find GIFs excluding the last one
mapfile -d '' PICS < <(find "$wallDIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0 2>/dev/null | grep -zv "$last_wallpaper" || true)

# Fallback if no GIFs found
if [[ ${#PICS[@]} -eq 0 ]]; then
    echo "No new GIFs found, trying all wallpapers..." >&2
    mapfile -d '' PICS < <(find "$allwallDIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0 2>/dev/null | grep -zv "$last_wallpaper" || true)
    
    # If still no wallpapers, use any available
    if [[ ${#PICS[@]} -eq 0 ]]; then
        mapfile -d '' PICS < <(find "$allwallDIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0 2>/dev/null || true)
        if [[ ${#PICS[@]} -eq 0 ]]; then
            echo "Error: No wallpapers found" >&2
            exit 1
        fi
    fi
fi
# Select random wallpaper
RANDOMPICS=${PICS[$RANDOM % ${#PICS[@]}]}

# Save current wallpaper name safely
if ! basename "$RANDOMPICS" > "$wallDIR/current_wallpaper.txt" 2>/dev/null; then
    echo "Warning: Could not save current wallpaper name" >&2
fi

# Transition config
FPS=30
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

# Initialize swww daemon if needed
if ! swww query >/dev/null 2>&1; then
    echo "Starting swww daemon..."
    swww-daemon --format xrgb &
    sleep 1
fi

# Set the wallpaper
if ! swww img "$RANDOMPICS" $SWWW_PARAMS; then
    echo "Error: Failed to set wallpaper" >&2
    exit 1
fi

# Copy wallpaper to effects directory
wallpaper_effects_dir="$HOME/.config/hypr/wallpaper_effects"
if [[ -d "$wallpaper_effects_dir" ]]; then
    cp "$RANDOMPICS" "$wallpaper_effects_dir/.wallpaper_current" 2>/dev/null || echo "Warning: Could not copy to wallpaper effects" >&2
fi

# Run additional scripts with error handling
if [[ -x "$scriptsDir/WallustSwww.sh" ]]; then
    "$scriptsDir/WallustSwww.sh" || echo "Warning: WallustSwww.sh failed" >&2
fi

if [[ -x "$scriptsDir/Refresh.sh" ]]; then
    "$scriptsDir/Refresh.sh" || echo "Warning: Refresh.sh failed" >&2
fi

exit 0