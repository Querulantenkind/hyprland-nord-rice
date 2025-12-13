#!/bin/bash

# Nord-themed update checker for Waybar
# Returns JSON for waybar custom module

# Colors for output
NORD11="#bf616a"  # Red for updates available
NORD14="#a3be8c"  # Green for no updates

# Check for updates based on package manager
if command -v pacman &> /dev/null; then
    # Arch Linux
    UPDATES=$(checkupdates 2>/dev/null | wc -l)
elif command -v apt &> /dev/null; then
    # Debian/Ubuntu
    UPDATES=$(apt list --upgradable 2>/dev/null | grep -c "upgradable")
elif command -v dnf &> /dev/null; then
    # Fedora
    UPDATES=$(dnf check-update --quiet 2>/dev/null | grep -c "updates")
else
    UPDATES=0
fi

# Flatpak updates
if command -v flatpak &> /dev/null; then
    FLATPAK_UPDATES=$(flatpak remote-ls --updates 2>/dev/null | wc -l)
else
    FLATPAK_UPDATES=0
fi

TOTAL_UPDATES=$((UPDATES + FLATPAK_UPDATES))

# Output JSON for waybar
if [ "$TOTAL_UPDATES" -gt 0 ]; then
    echo "{\"text\":\"$TOTAL_UPDATES\",\"tooltip\":\"$TOTAL_UPDATES Updates verfügbar\",\"class\":\"updates-available\"}"
else
    echo "{\"text\":\"0\",\"tooltip\":\"System ist aktuell\",\"class\":\"up-to-date\"}"
fi
