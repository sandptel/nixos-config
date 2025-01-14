#!/bin/bash

# wal_template=$HOME/.config/wal/templates/obsidian.css
wal_cached=$HOME/.cache/wal/colors.json


link_template () {
    ln -sr $wal_cached $1
} 

autolit_folder=$HOME/Documents/autolitt

rm $autolitt_folder/colors.json

cp $wal_cached $autolit_folder/colors.json
# cp $wal_cached $obsidian_vault/.obsidian/obsidian1.css

