#!/usr/bin/env sh

# multiple monitors
if ! pgrep polybar; then
    if type "xrandr"; then
      for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar mybar &
      done
    else
      polybar --reload mybar &
    fi
else
    pkill polybar
    if type "xrandr"; then
      for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar mybar &
      done
    else
      polybar --reload mybar &
    fi
fi

echo "Bars launched..."
