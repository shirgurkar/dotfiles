#!/bin/bash

# Set a fixed ID for volume notifications
NOTIFY_ID=1234

# Change volume
case "$1" in
    up)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        ;;
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
esac

# Get current volume
VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)

# Get mute status
MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -oP 'yes|no')

# Send notification with fixed ID
if [ "$MUTE" = "yes" ]; then
    notify-send -r "$NOTIFY_ID" -h int:value:0 -u normal "Volume" "Muted"
else
    notify-send -r "$NOTIFY_ID" -h int:value:${VOLUME%\%} -u normal "Volume" "${VOLUME}"
fi
