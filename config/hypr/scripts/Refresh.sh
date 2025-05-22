#!/bin/bash
# /* ---- 👒 https://github.com/sandptel/nixos-config ---- */  ##
# Scripts for refreshing ags waybar, rofi, swaync, wallust

SCRIPTSDIR=$HOME/.config/hypr/scripts
UserScripts=$HOME/.config/hypr/UserScripts

# Define file_exists function
file_exists() {
    if [ -e "$1" ]; then
        return 0  # File exists
    else
        return 1  # File does not exist
    fi
}
${UserScripts}/Lights.sh
# Kill already running processes
_ps=(waybar rofi swaync ags)
for _prs in "${_ps[@]}"; do
    if pidof "${_prs}" >/dev/null; then
        pkill "${_prs}"
    fi
done

# quit ags
ags -q

killall .waybar-wrapped

# sleep 0.5
#Restart waybar
waybar & disown

# relaunch swaync
# sleep 0.5
swaync > /dev/null 2>&1 &

# relaunch ags
ags &

${SCRIPTSDIR}/WallustSwww.sh

pywalfox update

# sleep 0.5
${UserScripts}/Obsidian.sh
# ${UserScripts}/spicetify.sh
# Relaunching rainbow borders if the script exists
# sleep 1
# if file_exists "${UserScripts}/RainbowBorders.sh"; then
#     ${UserScripts}/RainbowBorders.sh &
# fi


exit 0