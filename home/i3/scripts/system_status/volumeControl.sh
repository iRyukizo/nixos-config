#!/usr/bin/env bash

# You can call this script like this:
# $ ./volumeControl.sh up
# $ ./volumeControl.sh down
# $ ./volumeControl.sh mute

function get_volume {
  amixer -M get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
  amixer -M get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
  iconSound="audio-volume-high"
  iconMuted="audio-volume-muted"
  if is_mute ; then
    dunstify -t 1000 -i $iconMuted -r 2593 -u normal "mute"
  else
    volume=$(get_volume)
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    bar=$(seq --separator="─" 0 "$((volume / 5))" | sed 's/[0-9]//g')
    # Send the notification
    dunstify -t 1000 -i $iconSound -r 2593 -u normal "$volume%"$'\n'"$bar"
  fi
}

case $1 in
  up)
    pamixer --allow-boost -i 5
    send_notification
    ;;
  down)
    pamixer --allow-boost -d 5
    send_notification
    ;;
  mute)
    pamixer --toggle-mute
    send_notification
    ;;
esac
