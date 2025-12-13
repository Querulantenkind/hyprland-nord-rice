#!/bin/bash

# Wofi Modes Launcher
# Launch different wofi modes

# Colors for output
NORD8='\033[38;2;136;192;208m'
NORD4='\033[38;2;216;222;233m'
NORD14='\033[38;2;163;190;140m'
RESET='\033[0m'

# Available modes
MODES=(
    "apps|󰀻 Applications|wofi --show drun"
    "run|󰆍 Run|wofi --show run"
    "calc|󰃬 Calculator|kitty --title 'Calculator' -- bash -c '~/.config/wofi/scripts/calculator.sh'"
    "emoji|󰞅 Emoji Picker|bash ~/.config/wofi/scripts/emoji-picker.sh"
    "scripts|󰆍 Scripts|bash ~/.config/wofi/scripts/run-script.sh"
    "docs|📚 Dokumentation|bash ~/.config/wofi/scripts/docs-launcher.sh"
    "clipboard|󰅇 Clipboard|cliphist list | wofi --dmenu | cliphist decode | wl-copy"
    "power|⏻ Power Menu|wlogout"
)

# Extract mode names for menu
MODE_NAMES=$(printf '%s\n' "${MODES[@]}" | cut -d'|' -f2)

# Show mode selection menu
SELECTED=$(echo "$MODE_NAMES" | wofi --dmenu --prompt "Modus wählen:" --width 400 --height 250 --location center --gtk-dark)

# Execute selected mode
if [ -n "$SELECTED" ]; then
    # Find the corresponding command
    for mode in "${MODES[@]}"; do
        MODE_NAME=$(echo "$mode" | cut -d'|' -f2)
        if [ "$MODE_NAME" = "$SELECTED" ]; then
            COMMAND=$(echo "$mode" | cut -d'|' -f3)
            eval "$COMMAND" &
            break
        fi
    done
fi
