#!/bin/bash
# /* ---- 👒 https://github.com/sandptel/nixos-config ---- */  ##
# Wallust Colors for current wallpaper

# Define the path to the swww cache directory
cache_dir="$HOME/.cache/swww/"

# Get a list of monitor outputs
monitor_outputs=($(ls "$cache_dir"))

colorscheme="$HOME/.cache/wal/colors.json"

# Initialize a flag to determine if the ln command was executed
ln_success=false
# Get current focused monitor
current_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')
echo $current_monitor
# Construct the full path to the cache file
cache_file="$cache_dir$current_monitor"
echo $cache_file
# Check if the cache file exists for the current monitor output
if [ -f "$cache_file" ]; then
    # Get the wallpaper path from the cache file
    wallpaper_path=$(cat "$cache_file")
    echo $wallpaper_path
    # symlink the wallpaper to the location Rofi can access
    if ln -sf "$wallpaper_path" "$HOME/.config/rofi/.current_wallpaper"; then
        ln_success=true  # Set the flag to true upon successful execution
    fi
    # copy the wallpaper for wallpaper effects
	cp -r "$wallpaper_path" "$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"
fi

# Check the flag before executing further commands
if [ "$ln_success" = true ]; then
    #kill wallust previous sessions 
    killall .wallust-wrappe
    # execute pywal
	echo 'about to pywal'
    wal --cols16 -i $wallpaper_path --saturate 1 -n 
    # execute wallust skipping tty and terminal changes
    echo 'about to execute wallust'
    wallust run "$wallpaper_path" -s 
    # wallust cs ~/.cache/wal/colors.json -s &

    echo 'about to wpgtk'
    wpg --theme "$colorscheme" -n
fi


exit 0 