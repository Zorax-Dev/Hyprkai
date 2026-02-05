#!/usr/bin/env bash
set -euo pipefail

ROFI_CONFIG="$HOME/.config/rofi/sl.rasi"

# --- Define menu options (no icons) ---
MENU_ITEMS=(
    "󱂬   Waybar Layout"
    "󱓞   Rofi Layout"
    "󰸉   Wallpaper Switcher"
    "   Clipboard"
    "   Capture"
)

# --- Show rofi menu ---
SELECTED=$(printf "%s\n" "${MENU_ITEMS[@]}" | rofi -dmenu -i -p "Launcher" -config "$ROFI_CONFIG")

[ -z "$SELECTED" ] && exit 0  # Cancelled

# --- Run the corresponding script ---
case "$SELECTED" in
    "󱂬   Waybar Layout")
        "$HOME/.config/waybar/switch.sh"
        ;;
    "󱓞   Rofi Layout")
        "$HOME/.config/rofi/scripts/rofi-theme-switcher.sh"
        ;;
    "󰸉   Wallpaper Switcher")
        "$HOME/.config/hypr/scripts/wallpaper-picker.sh"
        ;;
    "   Clipboard")
        "$HOME/.config/hypr/scripts/clip.sh"
        ;;
    "   Capture")
		"$HOME/.config/hypr/scripts/screenshotrofi.sh"
		;;
    *)
        echo "Unknown option: $SELECTED"
        ;;
esac
