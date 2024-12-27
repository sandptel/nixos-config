#!/bin/bash
# Script for selecting wallpaper Directory

set -euo pipefail
IFS=$'\n\t'

# Define directories
wallDir="$HOME/Pictures/wallpapers"
selectionFile="$wallDir/selected_directory.txt"
rofi_config="$HOME/.config/rofi/config-waybar-style.rasi"

# Function to display menu options
menu() {
    local options=()
    
    # Find all directories and subdirectories, and add them to the options
    while IFS= read -r folder; do
        if [ -d "$folder" ]; then
            options+=("$(basename "$folder")")
        fi
    done < <(find "$wallDir" -type d | sort)
    
    printf '%s\n' "${options[@]}"
}

# Save the selected path to the selection file
save_selection() {
    local choice="$1"

    # Resolve the full path of the selected folder
    local full_path
    full_path=$(find "$wallDir" -type d -name "$choice" -print -quit)

    if [[ -n "$full_path" ]]; then
        # Overwrite the selection file with the new selection
        printf '%s\n' "$full_path" > "$selectionFile"
    else
        printf "Error: Folder not found.\n" >&2
        exit 1
    fi
}

# Main function
main() {
    # Display the menu and get the user's choice
    local choice
    choice=$(menu | rofi -i -dmenu -config "$rofi_config")

    # Exit if no option is selected
    if [[ -z "$choice" ]]; then
        printf "No option selected. Exiting.\n"
        exit 0
    fi

    # Save the selection
    save_selection "$choice"
}

# Kill Rofi if already running before execution
if pgrep -x "rofi" >/dev/null; then
    pkill rofi
    exit 0
fi

main
