#!/bin/sh

case "$1" in
    up)   wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ ;;
    down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
    mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
esac

read -r _ VOL_VAL MUTE_STATUS <<EOF
$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
EOF

INT_PART=${VOL_VAL%.*}
DEC_PART=${VOL_VAL#*.}
PERCENT=$(( (INT_PART * 100) + (10#$DEC_PART) ))

if [ "$MUTE_STATUS" = "[MUTED]" ]; then
    DISPLAY="Muted"
    ICON="audio-volume-muted"
else
    DISPLAY="${PERCENT}%"
    if [ "$PERCENT" -lt 33 ]; then ICON="audio-volume-low"
    elif [ "$PERCENT" -lt 66 ]; then ICON="audio-volume-medium"
    else ICON="audio-volume-high"; fi
fi

notify-send -t 800 -u low \
    -h string:x-canonical-private-synchronous:volume \
    -i "$ICON" \
    "Volume" "$DISPLAY" &
