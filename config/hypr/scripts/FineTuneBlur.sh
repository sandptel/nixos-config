#!/bin/bash
# /* ---- 👒 https://github.com/sandptel/nixos-config ---- */  ##
# Script for changing blurs on the fly with 10 variants

notif="$HOME/.config/swaync/images/bell.png"

# Array of blur configurations: [size, passes, message]
BLUR_SETTINGS=(
    "2 1 Minimal blur"
    "3 2 Very light blur"
    "4 2 Light blur"
    "5 3 Moderate blur"
    "6 3 Noticeable blur"
    "7 4 Strong blur"
    "8 4 Intense blur"
    "9 5 Very intense blur"
    "10 5 Extreme blur"
    "12 6 Maximal blur"
)

# Current state retrieval
STATE=$(hyprctl -j getoption decoration:blur:size | jq ".int")

# Determine next state index
NEXT_INDEX=0
for i in "${!BLUR_SETTINGS[@]}"; do
    size_pass_msg=(${BLUR_SETTINGS[$i]})
    if [ "${size_pass_msg[0]}" == "$STATE" ]; then
        NEXT_INDEX=$(( (i + 1) % ${#BLUR_SETTINGS[@]} ))
        break
    fi
done

# Apply the next blur configuration
IFS=" " read -r size passes message <<< "${BLUR_SETTINGS[$NEXT_INDEX]}"
hyprctl keyword decoration:blur:size "$size"
hyprctl keyword decoration:blur:passes "$passes"
notify-send -e -u low -i "$notif" "$message"
