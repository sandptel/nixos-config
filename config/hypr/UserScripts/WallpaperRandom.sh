#!/bin/bash
# /* ---- 👒 https://github.com/sandptel/nixos-config ---- */  ##
# Script for Random Wallpaper ( CTRL ALT W)

set -euo pipefail  # Exit on error, undefined vars, pipe failures

allwallDIR="$HOME/Pictures/wallpapers"
BestwallDIR="$allwallDIR/Best"
scriptsDir="$HOME/.config/hypr/scripts"

# Check if wallpaper directory exists
if [[ ! -d "$allwallDIR" ]]; then
    echo "Error: Wallpaper directory $allwallDIR does not exist" >&2
    exit 1
fi

# Read selected directory with fallback
if [[ -f "$allwallDIR/selected_directory.txt" ]]; then
    wallDIR=$(cat "$allwallDIR/selected_directory.txt" 2>/dev/null || echo "$BestwallDIR")
else
    wallDIR="$BestwallDIR"
fi

# Verify wallDIR exists
if [[ ! -d "$wallDIR" ]]; then
    echo "Warning: Selected directory $wallDIR does not exist, using $BestwallDIR" >&2
    wallDIR="$BestwallDIR"
fi

# Get last wallpaper with error handling
last_wallpaper=""
if [[ -f "$allwallDIR/current_wallpaper.txt" ]]; then
    last_wallpaper=$(cat "$allwallDIR/current_wallpaper.txt" 2>/dev/null || echo "")
fi

# Clean up old tracking files safely
find "$wallDIR" -type f -name "current_wallpaper.txt" -delete 2>/dev/null || true

# Find wallpapers excluding the last one
mapfile -d '' PICS < <(find "$wallDIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0 2>/dev/null | grep -zv "$last_wallpaper" || true)

# Fallback if no wallpapers found
if [[ ${#PICS[@]} -eq 0 ]]; then
    echo "No new wallpapers found in $wallDIR, trying fallback directory..." >&2
    if [[ -d "$BestwallDIR" ]]; then
        mapfile -d '' PICS < <(find "$BestwallDIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0 2>/dev/null | grep -zv "$last_wallpaper" || true)
    fi
    
    # If still no wallpapers, use any available
    if [[ ${#PICS[@]} -eq 0 ]]; then
        mapfile -d '' PICS < <(find "$allwallDIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0 2>/dev/null || true)
        if [[ ${#PICS[@]} -eq 0 ]]; then
            echo "Error: No wallpapers found in any directory" >&2
            exit 1
        fi
    fi
fi
# Select random wallpaper
RANDOMPICS=${PICS[$RANDOM % ${#PICS[@]}]}

# Save current wallpaper name safely
if ! basename "$RANDOMPICS" > "$allwallDIR/current_wallpaper.txt" 2>/dev/null; then
    echo "Warning: Could not save current wallpaper name" >&2
fi

# Transition config
FPS=30
TYPE="any"
DURATION=0.6
BEZIER="0,.95,1,.05"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

# Initialize swww daemon if needed
if ! swww query >/dev/null 2>&1; then
    echo "Starting swww daemon..."
    swww-daemon --format xrgb &
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

# Kill waybar only if it's running to avoid restart
if pidof .waybar-wrapped >/dev/null 2>&1; then
    pkill .waybar-wrapped
fi

# Run additional scripts with error handling
if [[ -x "$scriptsDir/WallustSwww.sh" ]]; then
    "$scriptsDir/WallustSwww.sh" || echo "Warning: WallustSwww.sh failed" >&2
fi

if [[ -x "$scriptsDir/Refresh.sh" ]]; then
    "$scriptsDir/Refresh.sh" || echo "Warning: Refresh.sh failed" >&2
fi

exit 0