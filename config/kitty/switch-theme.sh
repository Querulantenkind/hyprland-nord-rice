#!/bin/bash

# Kitty Theme Switcher
# Switch between different color themes

THEME_DIR="$HOME/.config/kitty/themes"
KITTY_CONFIG="$HOME/.config/kitty/kitty.conf"

# Available themes
THEMES=("nord" "dracula")

# Show theme selection menu
SELECTED=$(printf '%s\n' "${THEMES[@]}" | wofi --dmenu --prompt "Kitty Theme:" --width 300 --height 200 --location center --gtk-dark)

if [ -n "$SELECTED" ]; then
    THEME_FILE="$THEME_DIR/${SELECTED}.conf"

    if [ -f "$THEME_FILE" ]; then
        # Remove existing theme includes
        sed -i '/^include themes\//d' "$KITTY_CONFIG"

        # Add new theme
        echo "include themes/${SELECTED}.conf" >> "$KITTY_CONFIG"

        # Reload kitty config
        kill -USR1 $(pgrep kitty)

        notify-send "Kitty Theme" "Switched to ${SELECTED} theme" -t 2000
    else
        notify-send "Kitty Theme" "Theme file not found: ${THEME_FILE}" -t 3000
    fi
fi
