#!/bin/bash

VIDEO_DIR="$HOME/Videos"
mkdir -p "$VIDEO_DIR"

DEFAULT_NAME="recording-$(date +%F-%T)"

# Auto-focus Stop if already recording
if pgrep wf-recorder > /dev/null; then
  DEFAULT_ROW=4
else
  DEFAULT_ROW=0
fi

# ---- MENU ----
choice=$(printf "🎥 Video only (no audio)\n🎤 Mic only\n🔊 Desktop sound only\n🎤 + 🔊 Mic + Desktop\n⏹ Stop recording" | \
  rofi -dmenu \
    -no-config \
    -selected-row "$DEFAULT_ROW" \
    -theme ~/.config/rofi/record.rasi)

# ---- FILENAME ----
ask_filename() {
  name=$(printf "" | rofi -dmenu \
    -no-config \
    -theme ~/.config/rofi/record-input.rasi)

  [ -z "$name" ] && name="$DEFAULT_NAME"
  echo "$VIDEO_DIR/$name.mp4"
}

case "$choice" in
  "🎥 Video only (no audio)")
    FILE=$(ask_filename)
    pkill wf-recorder
    wf-recorder -f "$FILE" &
    notify-send "Screen Recording" "Recording VIDEO ONLY"
    ;;

  "🎤 Mic only")
    FILE=$(ask_filename)
    pkill wf-recorder
    wf-recorder --audio=@DEFAULT_SOURCE@ -f "$FILE" &
    notify-send "Screen Recording" "Recording MIC ONLY"
    ;;

  "🔊 Desktop sound only")
    FILE=$(ask_filename)
    pkill wf-recorder
    wf-recorder --audio=@DEFAULT_SINK@.monitor -f "$FILE" &
    notify-send "Screen Recording" "Recording DESKTOP AUDIO"
    ;;

  "🎤 + 🔊 Mic + Desktop")
    FILE=$(ask_filename)
    pkill wf-recorder

    pactl load-module module-null-sink sink_name=RecordMix >/dev/null
    pactl load-module module-loopback source=@DEFAULT_SOURCE@ sink=RecordMix >/dev/null
    pactl load-module module-loopback source=@DEFAULT_SINK@.monitor sink=RecordMix >/dev/null

    wf-recorder --audio=RecordMix.monitor -f "$FILE" &
    notify-send "Screen Recording" "Recording MIC + DESKTOP"
    ;;

  "⏹ Stop recording")
    pkill wf-recorder
    notify-send "Screen Recording" "Recording stopped"
    ;;
esac
