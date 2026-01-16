#!/bin/sh
# This updates and grabs the new value in a single command execution
NEW_VAL=$(brightnessctl set ${1:-up} 10% -q -m | cut -d, -f4)

notify-send -t 800 -h string:x-canonical-private-synchronous:brightness "Brightness" "$NEW_VAL"
