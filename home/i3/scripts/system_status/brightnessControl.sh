#!/usr/bin/env bash

# You can call this script like this:
# $ ./brightnessControl.sh up
# $ ./brightnessControl.sh down

function send_notification {
  icon="notification-display-brightness"
  brightness="$1"
  # Make the bar with the special character ─ (it's not dash -)
  # https://en.wikipedia.org/wiki/Box-drawing_character
  bar=$(seq -s "─" 0 $((brightness / 5)) | sed 's/[0-9]//g')
  # Send the notification
  dunstify -t 1000 -i "$icon" -r 5432 -u normal "$brightness%"$'\n'"$bar"
}

case $1 in
  up)
    # increase the backlight by 10%
    newBrightness=$(brightnessctl -m set "+2%" | cut -d, -f4 | tr -d '%')
    send_notification "$newBrightness"
    ;;
  down)
    # decrease the backlight by 10%
    newBrightness=$(brightnessctl -m set "2%-" | cut -d, -f4 | tr -d '%')
    send_notification "$newBrightness"
    ;;
esac
