#!/bin/bash
# /* ---- 👒 https://github.com/sandptel/nixos-config ---- */  ##
# Script for changing blurs on the fly with 5 variants

notif="$HOME/.config/swaync/images/bell.png"

# Array of blur configurations: [size, passes, message]
BLUR_SETTINGS=(
    "2 1 Less blur"
    "3 2 Mild blur"
    "4 2 Medium blur"
    "5 3 High blur"
    "6 4 Extreme blur"
    "8 5 Intense blur"
    "10 6 Maximal blur"
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
notify-send -r 2 -e -u low -i "$notif" "$message"
