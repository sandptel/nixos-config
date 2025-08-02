#!/bin/bash
# /* ---- 👒 https://github.com/sandptel/nixos-config ---- */  ##
# Script for Monitor backlights (if supported) using brightnessctl

iDIR="$HOME/.config/swaync/icons"
step=10  # INCREASE/DECREASE BY THIS VALUE

# Get brightness
get_backlight() {
    brightnessctl -m | cut -d, -f4 | sed 's/%//'
}

# Get icons
get_icon() {
    current=$(get_backlight)
    if   [ "$current" -le "20" ]; then
        icon="$iDIR/brightness-20.png"
    elif [ "$current" -le "40" ]; then
        icon="$iDIR/brightness-40.png"
    elif [ "$current" -le "60" ]; then
        icon="$iDIR/brightness-60.png"
    elif [ "$current" -le "80" ]; then
        icon="$iDIR/brightness-80.png"
    else
        icon="$iDIR/brightness-100.png"
    fi
}

# Change brightness
change_backlight() {
    local current_brightness
    current_brightness=$(get_backlight)

    # Calculate new brightness
    if [[ "$1" == "+${step}%" ]]; then
        new_brightness=$((current_brightness + step))
    elif [[ "$1" == "${step}%-" ]]; then
        new_brightness=$((current_brightness - step))
    fi

    # Ensure new brightness is within valid range
    if (( new_brightness < 5 )); then
        new_brightness=5
    elif (( new_brightness > 100 )); then
        new_brightness=100
    fi

    brightnessctl set "${new_brightness}%"
}

# Execute accordingly
case "$1" in
    "--get")
        get_backlight
        ;;
    "--inc")
        change_backlight "+${step}%"
        ;;
    "--dec")
        change_backlight "${step}%-"
        ;;
    *)
        get_backlight
        ;;
esac