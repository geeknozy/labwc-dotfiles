#!/bin/bash

# Absolute path for screenshots
DIR="/home/nozy/Pictures/Screenshots"
mkdir -p "$DIR"

# Timestamped filename
FILE="$DIR/screen_$(date +%Y%m%d_%H%M%S).png"

# Select region; exit if cancelled
REGION=$(slurp) || exit 0

# Capture selected region at full resolution, lossless PNG
grim -g "$REGION" -t png "$FILE" || { notify-send "Screenshot failed"; exit 1; }

# Copy screenshot to clipboard
wl-copy --type image/png < "$FILE" || notify-send "Clipboard copy failed"

# Notify user
notify-send "Screenshot saved" "$(basename "$FILE")"
