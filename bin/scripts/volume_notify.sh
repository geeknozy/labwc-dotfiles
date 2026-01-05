#!/bin/sh

case "$1" in
  up)   pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
  down) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
  mute) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
esac

VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n1)
MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
[ "$MUTE" = "yes" ] && VOL="Muted"

notify-send "Volume" "$VOL"
