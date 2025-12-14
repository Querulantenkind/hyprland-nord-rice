#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                     MEDIA PLAYER WIDGET - NORD THEME                      ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
#
# Shows currently playing media from Spotify, Firefox, Chrome, etc.
# Uses playerctl to control media players

# Check if playerctl is available
if ! command -v playerctl &> /dev/null; then
    echo '{"text": "", "tooltip": "playerctl not installed", "class": "stopped"}'
    exit 0
fi

# Get player status
player_status=$(playerctl status 2>/dev/null)

if [ -z "$player_status" ] || [ "$player_status" = "No players found" ]; then
    # No player running - show nothing or minimal indicator
    echo '{"text": "", "tooltip": "No media playing", "class": "stopped"}'
    exit 0
fi

# Get metadata
artist=$(playerctl metadata artist 2>/dev/null || echo "")
title=$(playerctl metadata title 2>/dev/null || echo "")
album=$(playerctl metadata album 2>/dev/null || echo "")
player_name=$(playerctl metadata --format '{{playerName}}' 2>/dev/null || echo "Unknown")

# Truncate if too long
max_length=35
if [ ${#title} -gt $max_length ]; then
    title="${title:0:$max_length}..."
fi
if [ ${#artist} -gt 20 ]; then
    artist="${artist:0:20}..."
fi

# Format display text
if [ -n "$artist" ] && [ -n "$title" ]; then
    display_text="$artist - $title"
elif [ -n "$title" ]; then
    display_text="$title"
else
    display_text="$player_name"
fi

# Get position and duration for tooltip
position=$(playerctl position --format '{{duration(position)}}' 2>/dev/null || echo "0:00")
duration=$(playerctl metadata --format '{{duration(mpris:length)}}' 2>/dev/null || echo "0:00")

# Build tooltip
tooltip="$player_name\n"
[ -n "$title" ] && tooltip+="Title: $title\n"
[ -n "$artist" ] && tooltip+="Artist: $artist\n"
[ -n "$album" ] && tooltip+="Album: $album\n"
tooltip+="Status: $player_status\n"
tooltip+="Position: $position / $duration\n"
tooltip+="\nControls:\n"
tooltip+="Left-click: Play/Pause\n"
tooltip+="Right-click: Next\n"
tooltip+="Middle-click: Previous\n"
tooltip+="Scroll: Volume"

# Determine icon class based on status
case "$player_status" in
    "Playing")
        class="playing"
        icon="󰎆"
        ;;
    "Paused")
        class="paused"
        icon="󰏤"
        ;;
    *)
        class="stopped"
        icon="󰓛"
        ;;
esac

# Output JSON for Waybar
echo "{\"text\": \"$icon $display_text\", \"tooltip\": \"$tooltip\", \"class\": \"$class\", \"alt\": \"$player_status\"}"

