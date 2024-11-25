#!/bin/bash

wallDIR="$HOME/Pictures/wallpapers"
scriptsDir="$HOME/.config/hypr/scripts"

# Get all monitors
monitors=($(hyprctl monitors | awk '/^Monitor/{print $2}'))

# Get a random wallpaper
PICS=($(find "${wallDIR}" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))
RANDOMPICS="${PICS[RANDOM % ${#PICS[@]}]}"

# Transition config
FPS=120
TYPE="random"
DURATION=3
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

# Ensure swww-daemon is running
swww query || swww-daemon --format xrgb

# Apply the wallpaper to all monitors
for monitor in "${monitors[@]}"; do
    swww img -o "$monitor" "$RANDOMPICS" $SWWW_PARAMS
done

# Call additional script
"${scriptsDir}/WallustSwww.sh"

sleep 1

