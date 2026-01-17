#!/bin/sh

# 1. Quick logic for direction
[ "$1" = "down" ] && OP="-" || OP="+"

# 2. Change brightness and capture machine-readable output
RAW=$(brightnessctl set 10%${OP} -m)

# 3. Pure shell string manipulation (fastest possible extraction)
# Trims everything before the 4th field and everything after it
TEMP_VAL=${RAW#*,*,*,}
NEW_VAL=${TEMP_VAL%%,*}

# 4. Fire notification asynchronously
# Removed the '-h int:value' hint to hide the progress bar
notify-send -t 800 \
    -h string:x-canonical-private-synchronous:brightness \
    "Brightness" "Level: $NEW_VAL" &
