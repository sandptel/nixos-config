#!/bin/bash
# This script opens and closes the nwg-drawer and adjust waybar accordingly during drawer operation
pkill -SIGUSR1 waybar

drawer_pid=$(pgrep -f nwg-drawer)

nwg-drawer

wait $drawer_pid

pkill -SIGUSR2 waybar

exit 0