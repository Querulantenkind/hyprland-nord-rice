#!/bin/bash

# Volume notification script for Dunst
# Shows current volume level with progress bar and mute status

# Get volume information
VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')
MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o "\[MUTED\]")

# Convert to integer
VOLUME_INT=${VOLUME%.*}

# Create notification based on mute status
if [ "$MUTED" = "[MUTED]" ]; then
    dunstify -a "volume" -u low -h int:value:"$VOLUME_INT" "Volume" "Muted" -t 2000
else
    if [ "$VOLUME_INT" -eq 0 ]; then
        ICON="󰸈"
    elif [ "$VOLUME_INT" -lt 33 ]; then
        ICON="󰕿"
    elif [ "$VOLUME_INT" -lt 66 ]; then
        ICON="󰖀"
    else
        ICON="󰕾"
    fi

    dunstify -a "volume" -u low -h int:value:"$VOLUME_INT" "$ICON Volume" "${VOLUME_INT}%" -t 2000
fi
