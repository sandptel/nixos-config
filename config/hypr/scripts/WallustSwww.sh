#!/bin/bash
# /* ---- 👒 https://github.com/sandptel/nixos-config ---- */  ##
# This script is used to set the wallpaper and colorscheme using pywal and wallust.
# It also uses wpg to set the wallpaper and colorscheme for GTK applications.
# It is intended to be run in a Hyprland environment.

colorscheme="$HOME/.cache/wal/colors.json"

wallpaper_path="$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"

#kill wallust previous sessions
killall .wallust-wrappe
# execute pywal
echo 'about to pywal'
wal --cols16 darken -i $wallpaper_path --saturate 0.4 -n
# execute wallust skipping tty and terminal changes
echo 'about to execute wallust'
wallust run "$wallpaper_path" -s

echo 'about to wpgtk'
wpg --theme "$colorscheme" -n

exit 0
