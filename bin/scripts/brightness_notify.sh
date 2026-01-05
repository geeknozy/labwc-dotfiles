#!/bin/sh

case "$1" in
  up)   brightnessctl set +10% ;;
  down) brightnessctl set 10%- ;;
esac

BR=$(brightnessctl get)
MAX=$(brightnessctl max)
PCT=$(( BR * 100 / MAX ))

notify-send "Brightness" "$PCT%"
