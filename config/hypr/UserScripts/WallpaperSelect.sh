#!/bin/bash
# /* ---- 👒https://github.com/sandptel/nixos-config ---- */ 
# This script for selecting wallpapers (SUPER W)

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# WALLPAPERS PATH
wallDIR="$HOME/Pictures/wallpapers"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

# Check if wallpaper directory exists
if [[ ! -d "$wallDIR" ]]; then
    echo "Error: Wallpaper directory $wallDIR does not exist" >&2
    exit 1
fi

# Variables
RELOAD_DURATION=1
# swww transition config
FPS=60
TYPE="any"
DURATION=2
BEZIER="0,.95,1,.05"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

# Check if swaybg is running and kill it only if necessary
if pidof swaybg >/dev/null 2>&1; then
    pkill swaybg
fi

# Retrieve image files using null delimiter to handle spaces in filenames
mapfile -d '' PICS < <(find "$wallDIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0 2>/dev/null || true)

# Check if wallpapers were found
if [[ ${#PICS[@]} -eq 0 ]]; then
    echo "Error: No wallpapers found in $wallDIR" >&2
    exit 1
fi

RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME=". random"

# Rofi command
rofi_command="rofi -i -show -dmenu -config ~/.config/rofi/config-wallpaper.rasi"

# Sorting Wallpapers
menu() {
  # Sort the PICS array
  IFS=$'\n' sorted_options=($(sort <<<"${PICS[*]}"))
  
  # Place ". random" at the beginning with the random picture as an icon
  printf "%s\x00icon\x1f%s\n" "$RANDOM_PIC_NAME" "$RANDOM_PIC"
  
  for pic_path in "${sorted_options[@]}"; do
    pic_name=$(basename "$pic_path")
    
    # Displaying .gif to indicate animated images
    if [[ ! "$pic_name" =~ \.gif$ ]]; then
      printf "%s\x00icon\x1f%s\n" "$(echo "$pic_name" | cut -d. -f1)" "$pic_path"
    else
      printf "%s\n" "$pic_name"
    fi
  done
}

# initiate swww if not running
if ! swww query >/dev/null 2>&1; then
    echo "Starting swww daemon..."
    swww-daemon --format xrgb &
    sleep 1
fi

# Choice of wallpapers
main() {
  choice=$(menu | $rofi_command)
  
  # Trim any potential whitespace or hidden characters
  choice=$(echo "$choice" | xargs)
  RANDOM_PIC_NAME=$(echo "$RANDOM_PIC_NAME" | xargs)

  # No choice case
  if [[ -z "$choice" ]]; then
    echo "No choice selected. Exiting."
    exit 0
  fi

  # Random choice case
  if [[ "$choice" == "$RANDOM_PIC_NAME" ]]; then
    if ! swww img "$RANDOM_PIC" $SWWW_PARAMS; then
        echo "Error: Failed to set random wallpaper" >&2
        exit 1
    fi
    
    # Copy wallpaper to effects directory
    wallpaper_effects_dir="$HOME/.config/hypr/wallpaper_effects"
    if [[ -d "$wallpaper_effects_dir" ]]; then
        cp "$RANDOM_PIC" "$wallpaper_effects_dir/.wallpaper_current" 2>/dev/null || echo "Warning: Could not copy to wallpaper effects" >&2
    fi
    
    sleep 0.5
    
    # Run scripts with error handling
    if [[ -x "$SCRIPTSDIR/WallustSwww.sh" ]]; then
        "$SCRIPTSDIR/WallustSwww.sh" || echo "Warning: WallustSwww.sh failed" >&2
    fi
    
    sleep $RELOAD_DURATION
    
    if [[ -x "$SCRIPTSDIR/Refresh.sh" ]]; then
        "$SCRIPTSDIR/Refresh.sh" || echo "Warning: Refresh.sh failed" >&2
    fi
    
    exit 0
  fi

  # Find the index of the selected file
  pic_index=-1
  for i in "${!PICS[@]}"; do
    filename=$(basename "${PICS[$i]}")
    if [[ "$filename" == "$choice"* ]]; then
      pic_index=$i
      break
    fi
  done

  if [[ $pic_index -ne -1 ]]; then
    if ! swww img "${PICS[$pic_index]}" $SWWW_PARAMS; then
        echo "Error: Failed to set selected wallpaper" >&2
        exit 1
    fi
    
    # Copy wallpaper to effects directory
    wallpaper_effects_dir="$HOME/.config/hypr/wallpaper_effects"
    if [[ -d "$wallpaper_effects_dir" ]]; then
        cp "${PICS[$pic_index]}" "$wallpaper_effects_dir/.wallpaper_current" 2>/dev/null || echo "Warning: Could not copy to wallpaper effects" >&2
    fi
  else
    echo "Error: Image not found" >&2
    exit 1
  fi
}

# Check if rofi is already running and kill only if necessary
if pidof rofi >/dev/null 2>&1; then
    pkill rofi
    sleep 1  # Allow some time for rofi to close
fi

main

# Run post-selection scripts with error handling
if [[ -x "$SCRIPTSDIR/WallustSwww.sh" ]]; then
    "$SCRIPTSDIR/WallustSwww.sh" &
    wallust_pid=$!
    
    # Wait for wallust to complete with timeout
    if wait $wallust_pid 2>/dev/null; then
        sleep $RELOAD_DURATION
    else
        echo "Warning: WallustSwww.sh failed or timed out" >&2
    fi
else
    echo "Warning: WallustSwww.sh not found or not executable" >&2
fi

if [[ -x "$SCRIPTSDIR/Refresh.sh" ]]; then
    "$SCRIPTSDIR/Refresh.sh" || echo "Warning: Refresh.sh failed" >&2
fi