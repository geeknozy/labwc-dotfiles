#!/bin/sh

DIR="$HOME/Pictures/Screenshots"
[ -d "$DIR" ] || mkdir -p "$DIR"

NAME="screen_$(date +%Y%m%d_%H%M%S).png"
FILE="$DIR/$NAME"

# -c: Best color accuracy
# -l 1: Lowest compression (Fastest save, same quality, larger file)
GRIM_OPTS="-c -l 1"

case "$1" in
  region)
    if REGION=$(slurp); then
      grim $GRIM_OPTS -g "$REGION" "$FILE" && notify-send "Region Saved" "$NAME"
    fi
    ;;
  full)

    grim $GRIM_OPTS "$FILE" && notify-send "Fullscreen Saved" "$NAME"
    ;;
esac
