#!/bin/bash
# /* ---- 👒 https://github.com/sandptel/nixos-config ---- */  ##
# Scripts for refreshing ags waybar, rofi, swaync, wallust

SCRIPTSDIR=$HOME/.config/hypr/scripts
UserScripts=$HOME/.config/hypr/UserScripts

pywalfox update

# Define file_exists function
file_exists() {
    if [ -e "$1" ]; then
        return 0  # File exists
    else
        return 1  # File does not exist
    fi
}

# Kill already running processes
_ps=(waybar rofi swaync ags)
for _prs in "${_ps[@]}"; do
    if pidof "${_prs}" >/dev/null; then
        pkill "${_prs}"
    fi
done

# quit ags
ags -q

#Restart waybar
killall .waybar-wrapped
sleep 0.3
waybar &

# relaunch swaync
# sleep 0.5
swaync > /dev/null 2>&1 &

# relaunch ags
ags &

#if not already running then only launch wallust again....
# sleep 1
# if ! pgrep .wallust-wrappe > /dev/null; then
#     # Relaunch wallust
#     ${SCRIPTSDIR}/WallustSwww.sh
# fi

${SCRIPTSDIR}/WallustSwww.sh

# Relaunching rainbow borders if the script exists
# sleep 1
# if file_exists "${UserScripts}/RainbowBorders.sh"; then
#     ${UserScripts}/RainbowBorders.sh &
# fi

exit 0
