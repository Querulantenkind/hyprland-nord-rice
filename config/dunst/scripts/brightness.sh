#!/bin/bash

# Brightness notification script for Dunst
# Shows current brightness level with progress bar

# Get current brightness percentage
BRIGHTNESS=$(brightnessctl get)
MAX_BRIGHTNESS=$(brightnessctl max)
PERCENTAGE=$((BRIGHTNESS * 100 / MAX_BRIGHTNESS))

# Create notification with progress hint
dunstify -a "brightness" -u low -h int:value:"$PERCENTAGE" "Brightness" "Current level: ${PERCENTAGE}%" -t 2000
