#!/usr/bin/env bash

WB="$HOME/.config/waybar"
THEMES_DIR="$WB/Hyprland"

# Toggle rofi: if already running, close it
if pgrep -x rofi >/dev/null; then
  pkill rofi
  exit 0
fi

# Show rofi menu
THEME=$(ls "$THEMES_DIR" | rofi -dmenu -i -p "Waybar Theme" -theme ~/.config/rofi/waybarthemeswitcher.rasi)
[ -z "$THEME" ] && exit 0

THEME_DIR="$THEMES_DIR/$THEME"

if [ ! -d "$THEME_DIR" ]; then
  notify-send "Waybar" "Theme not found: $THEME"
  exit 1
fi

ln -sf "$THEME_DIR/config.jsonc" "$WB/config.jsonc"
ln -sf "$THEME_DIR/style.css" "$WB/style.css"

pkill waybar
waybar &

