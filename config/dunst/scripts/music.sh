#!/bin/bash

# Music notification script for Dunst
# Enhanced music notifications with player controls

# Check if Spotify is running
if pgrep -x "spotify" > /dev/null; then
    # Get current track info using playerctl
    if command -v playerctl &> /dev/null; then
        ARTIST=$(playerctl metadata artist 2>/dev/null || echo "Unknown Artist")
        TITLE=$(playerctl metadata title 2>/dev/null || echo "Unknown Title")
        STATUS=$(playerctl status 2>/dev/null || echo "Stopped")

        # Get album art if available (optional)
        # ART_URL=$(playerctl metadata mpris:artUrl 2>/dev/null)

        # Create notification with controls
        dunstify -a "spotify" -u low "$ARTIST - $TITLE" "$STATUS" \
            -A "play-pause,Play/Pause" \
            -A "next,Next Track" \
            -A "prev,Previous Track" \
            -t 3000

        # Handle actions (this would be called when user clicks actions)
        case "$1" in
            "play-pause")
                playerctl play-pause
                ;;
            "next")
                playerctl next
                ;;
            "prev")
                playerctl previous
                ;;
        esac
    else
        dunstify -a "spotify" -u low "Spotify" "Playerctl not available" -t 2000
    fi
fi
