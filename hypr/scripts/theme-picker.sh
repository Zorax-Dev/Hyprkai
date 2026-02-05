#!/bin/bash

OPTIONS="catppuccin
tokyonight
matugen
gruvbox
kanagawaDark
everforest
osaka
nightfox"

CHOICE=$(echo "$OPTIONS" | rofi -dmenu -p "Select GTK Theme")

[ -z "$CHOICE" ] && exit 0

~/.config/hypr/scripts/switchtheme.sh "$CHOICE"
