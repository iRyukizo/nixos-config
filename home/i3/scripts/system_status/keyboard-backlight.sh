#!/usr/bin/env bash
# inspired by: https://www.frandieguez.dev/posts/macbook-pro-keyboard-backlight-keys-on-ubuntu-gnulinux/
BACKLIGHT=$(cat /sys/class/leds/smc::kbd_backlight/brightness)
MAX_BACKLIGHT=$(cat /sys/class/leds/smc::kbd_backlight/max_brightness) 
INCREMENT=20

SET_VALUE=0
case $1 in
    up)
        TOTAL=`expr $BACKLIGHT + $INCREMENT`
        if [ $TOTAL -gt $MAX_BACKLIGHT ]; then
            TOTAL=$MAX_BACKLIGHT
        fi
        ;;
    down)
        TOTAL=`expr $BACKLIGHT - $INCREMENT`
        if [ $TOTAL -lt "0" ]; then
            TOTAL=0
        fi
        ;;
    total)
    TEMP_VALUE=$BACKLIGHT
    while [ $TEMP_VALUE -lt $MAX_BACKLIGHT ]; do
        TEMP_VALUE=`expr $TEMP_VALUE + 1`
        if [ $TEMP_VALUE -gt $MAX_BACKLIGHT ]; then TOTAL=$MAX_BACKLIGHT; fi
    done
        ;;
    off)
    TEMP_VALUE=$BACKLIGHT
    while [ $TEMP_VALUE -gt "0" ]; do
        TEMP_VALUE=`expr $TEMP_VALUE - 1`
        if [ $TEMP_VALUE -lt "0" ]; then TOTAL=0; fi
    done
        ;;
    *)
        echo "Use: keyboard-light up|down|total|off"
        ;;
esac

function send_notification {
  icon="notification-keyboard-brightness"
  # Make the bar with the special character ─ (it's not dash -)
  # https://en.wikipedia.org/wiki/Box-drawing_character
  CALC_VALUE=$(($TOTAL * 100 / $MAX_BACKLIGHT))
  bar=$(seq -s "─" 0 $((CALC_VALUE / 5)) | sed 's/[0-9]//g')
  # Send the notification
  dunstify -t 1000 -i "$icon" -r 5555 -u normal "$CALC_VALUE%"$'\n'"$bar"
}

echo $TOTAL | sudo /usr/bin/tee /sys/class/leds/smc::kbd_backlight/brightness
send_notification
