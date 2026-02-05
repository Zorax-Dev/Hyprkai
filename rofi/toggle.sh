#!/usr/bin/env bash
set -euo pipefail

if pgrep -x rofi >/dev/null; then
    pkill -x rofi
else
    rofi -show drun -theme ~/.config/rofi/config.rasi
fi

