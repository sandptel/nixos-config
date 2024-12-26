#!/bin/bash
# /* ---- 👒 https://github.com/sandptel/nixos-config ---- */  ##
# Script for Random Wallpaper ( CTRL ALT W)

allwallDIR="$HOME/Pictures/wallpapers"
wallDIR="$HOME/Pictures/wallpapers/Gifs"
scriptsDir="$HOME/.config/hypr/scripts"

focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

# THis method is shit :/ as much as gpt itself is :)
# {# Find all images, excluding the previously used wallpaper
# if [[ -f "$wallDIR/current_wallpaper.txt" ]]; then
#     last_wallpaper=$(cat "$wallDIR/current_wallpaper.txt")
#     PICS=($(find "$wallDIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \) ! -name "$last_wallpaper"))
#     # Remove all existing .txt files in the wallpaper directory
#     find "$wallDIR" -type f -name "*.txt" -exec rm {} \;
# else
#     PICS=($(find "$wallDIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))
# fi }}


last_wallpaper=$(cat "$wallDIR/current_wallpaper.txt")
find "$wallDIR" -type f -name "*.txt" -exec rm {} \;
mapfile -d '' PICS < <(find "${wallDIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0 ! -name "$last_wallpaper")


# Select a random wallpaper from the filtered list
if [[ ${#PICS[@]} -eq 0 ]]; then
    echo "No wallpapers left to choose from!"
    mapfile -d '' PICS < <(find "${allwallDIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0 ! -name "$last_wallpaper")
    exit 1
fi
RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}

# Save the current wallpaper name in a .txt file
basename "$(basename "$RANDOMPICS")" > "$wallDIR/current_wallpaper.txt"

# Transition config
FPS=30
TYPE="any"
DURATION=1
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

# Set the wallpaper
swww query || swww-daemon --format xrgb && swww img -o $focused_monitor "${RANDOMPICS}" $SWWW_PARAMS

# Run additional scripts
"${scriptsDir}/WallustSwww.sh"
"${scriptsDir}/Refresh.sh"

exit 0