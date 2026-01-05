#!/bin/sh

CPU=$(awk -v RS="" '{printf "%.1f%%", 100-($5*100/($2+$3+$4+$5))}' /proc/stat)
RAM=$(free -h | awk '/Mem:/ {print $3 "/" $2}')

VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n1)
MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
[ "$MUTE" = "yes" ] && VOL="Muted"

TIME=$(date '+%a %d %b %Y %H:%M:%S')

if ping -c1 -W1 1.1.1.1 >/dev/null 2>&1; then
    NET="Up"
else
    NET="Down"
fi

notify-send "System Status" \
"| CPU $CPU | RAM $RAM | VOL $VOL | NET $NET | $TIME"
