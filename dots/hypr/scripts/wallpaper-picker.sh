#!/bin/bash

# Toggle rofi
if pgrep -x rofi >/dev/null; then
  pkill rofi
  exit 0
fi

WALL_DIR="$HOME/Pictures/wallpapers"
CACHE="$HOME/.cache/current_wallpaper"

IMG=$(find "$WALL_DIR" -maxdepth 1 -type f | while read -r img; do
  printf "%s\x00icon\x1f%s\n" "$img" "$img"
done | rofi -dmenu -i -theme ~/.config/rofi/wallpapers.rasi)

[ -z "$IMG" ] && exit 0

# Set wallpaper
swww img "$IMG" \
  --transition-type grow \
  --transition-pos center \
  --transition-duration 0.9

# Cache
echo "$IMG" >"$CACHE"
ln -sf "$IMG" "$HOME/.cache/wallpaper"

# Generate colors
matugen image "$IMG"

# Rofi current wallpaper (symlink)

ROFI_CACHE="$HOME/.cache/rofi_wall.jpg"

magick "$IMG" \
  -resize 960x540^ \
  -gravity center \
  -extent 960x540 \
  -quality 80 \
  "$ROFI_CACHE"

ln -sf "$ROFI_CACHE" "$HOME/.config/rofi/.current_wallpaper"

# Reload GTK
gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"

# 🔥 RELIABLE Waybar reload
pkill waybar
waybar &

pkill swaync
swaync &

