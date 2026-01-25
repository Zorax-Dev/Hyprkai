#!/usr/bin/env bash

# Kill both just in case (prevents overlap)
pkill -x waybar 2>/dev/null
pkill -x quickshell 2>/dev/null

sleep 0.2

# If quickshell was running, go back to waybar
if pgrep -x quickshell >/dev/null; then
    waybar &
else
    quickshell &
fi

