#!/bin/bash

# wal_template=$HOME/.config/wal/templates/obsidian.css
wal_cached=$HOME/.cache/wal/obsidian.css


link_template () {
    ln -sr $wal_cached $1
} 

obsidian_vault=$HOME/Documents/obsidian/obsidian

rm $obsidian_vault/.obsidian/snippets/obsidian.css

cp $wal_cached $obsidian_vault/.obsidian/snippets/pywalobsidian.css
# cp $wal_cached $obsidian_vault/.obsidian/obsidian1.css

