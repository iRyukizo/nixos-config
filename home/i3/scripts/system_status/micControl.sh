#!/usr/bin/env bash

function is_mic_mute {
	pactl list | sed -n '/^Source/,/^$/p' | grep Mute | grep yes > /dev/null
}

function send_notification {
	iconMic="microphone-sensitivity-high-symbolic"
	iconMuted="microphone-sensitivity-muted-symbolic"
	if is_mic_mute ; then
		dunstify -t 1000 -i $iconMuted -r 2593 -u normal "mute"
	else
		dunstify -t 1000 -i $iconMic -r 2593 -u normal  "unmute"
	fi
}

case $1 in
	mute)
		pactl set-source-mute @DEFAULT_SOURCE@ toggle
		send_notification
	;;
esac
