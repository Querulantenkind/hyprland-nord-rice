#!/bin/bash

# Screenshot notification script for Dunst
# Enhanced screenshot notifications with actions

# Get the screenshot action from the notification summary or body
ACTION="$1"

case "$ACTION" in
    *"Area"*)
        dunstify -a "screenshot" -u low "Screenshot" "Area screenshot saved to clipboard" \
            -A "open,Open in Image Viewer" \
            -A "edit,Edit in GIMP" \
            -t 5000
        ;;
    *"Full"*)
        dunstify -a "screenshot" -u low "Screenshot" "Full screen screenshot saved to clipboard" \
            -A "open,Open in Image Viewer" \
            -A "edit,Edit in GIMP" \
            -t 5000
        ;;
    *"Window"*)
        dunstify -a "screenshot" -u low "Screenshot" "Window screenshot saved to clipboard" \
            -A "open,Open in Image Viewer" \
            -A "edit,Edit in GIMP" \
            -t 5000
        ;;
    *)
        dunstify -a "screenshot" -u low "Screenshot" "Screenshot saved to clipboard" \
            -A "open,Open in Image Viewer" \
            -A "edit,Edit in GIMP" \
            -t 5000
        ;;
esac
