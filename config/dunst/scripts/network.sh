#!/bin/bash

# Network notification script for Dunst
# Shows network status and connection info

# Get network information
WIFI_NAME=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
WIFI_SIGNAL=$(nmcli -t -f active,signal dev wifi | grep '^yes' | cut -d: -f2)
ETHERNET=$(nmcli -t -f type,state dev | grep "ethernet:connected" | wc -l)

# Determine connection type and create notification
if [ -n "$WIFI_NAME" ]; then
    # WiFi connection
    if [ -n "$WIFI_SIGNAL" ]; then
        SIGNAL_ICON="󰖩"
        dunstify -a "network" -u low "WiFi Connected" "$WIFI_NAME (${WIFI_SIGNAL}%)" \
            -A "disconnect,Disconnect" \
            -A "settings,Network Settings" \
            -t 3000
    else
        dunstify -a "network" -u low "WiFi Connected" "$WIFI_NAME" -t 2000
    fi
elif [ "$ETHERNET" -gt 0 ]; then
    # Ethernet connection
    dunstify -a "network" -u low "Ethernet Connected" "Wired connection active" -t 2000
else
    # No connection
    dunstify -a "network" -u normal "No Network" "Not connected to any network" \
        -A "settings,Network Settings" \
        -t 5000
fi

# Handle actions
case "$1" in
    "disconnect")
        nmcli device disconnect wlan0 2>/dev/null || nmcli device disconnect wlp2s0 2>/dev/null
        ;;
    "settings")
        nm-connection-editor &
        ;;
esac
