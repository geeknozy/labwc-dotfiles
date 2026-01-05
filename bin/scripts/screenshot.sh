#!/bin/sh

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

FILE="$DIR/screen_$(date +%Y%m%d_%H%M%S).png"

case "$1" in
  region)
    REGION=$(slurp) || exit 0
    grim -g "$REGION" -t png "$FILE" || {
      notify-send "Screenshot failed"
      exit 1
    }
    notify-send "Region screenshot saved" "$(basename "$FILE")"
    ;;
  full)
    grim -t png "$FILE" || {
      notify-send "Screenshot failed"
      exit 1
    }
    notify-send "Fullscreen screenshot saved" "$(basename "$FILE")"
    ;;
esac
