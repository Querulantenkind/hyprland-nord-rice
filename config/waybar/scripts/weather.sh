#!/bin/bash

# Nord-themed weather script for Waybar
# Uses wttr.in for weather data

# Get location (you can set this manually or use IP geolocation)
LOCATION="${LOCATION:-auto}"  # Set LOCATION environment variable or use 'auto'

# Weather icons mapping (Nerd Fonts)
get_weather_icon() {
    local condition="$1"
    case $condition in
        "Sunny"|"Clear")
            echo "󰖙"
            ;;
        "Partly cloudy"|"Mostly cloudy")
            echo "󰖕"
            ;;
        "Cloudy"|"Overcast")
            echo "󰖐"
            ;;
        "Rain"|"Light rain"|"Moderate rain"|"Heavy rain")
            echo "󰖗"
            ;;
        "Snow"|"Light snow"|"Moderate snow"|"Heavy snow")
            echo "󰖘"
            ;;
        "Thunderstorm")
            echo "󰖓"
            ;;
        "Fog"|"Mist")
            echo "󰖑"
            ;;
        *)
            echo "󰖐"
            ;;
    esac
}

# Fetch weather data
WEATHER_DATA=$(curl -s "https://wttr.in/${LOCATION}?format=%C|%t|%h|%w" 2>/dev/null)

if [ $? -eq 0 ] && [ -n "$WEATHER_DATA" ]; then
    # Parse data
    CONDITION=$(echo "$WEATHER_DATA" | cut -d'|' -f1)
    TEMP=$(echo "$WEATHER_DATA" | cut -d'|' -f2)
    HUMIDITY=$(echo "$WEATHER_DATA" | cut -d'|' -f3)
    WIND=$(echo "$WEATHER_DATA" | cut -d'|' -f4)

    # Get icon
    ICON=$(get_weather_icon "$CONDITION")

    # Format temperature (remove + sign if present)
    TEMP_CLEAN=$(echo "$TEMP" | sed 's/+//')

    # Output JSON for waybar
    echo "{\"text\":\"$ICON $TEMP_CLEAN\",\"tooltip\":\"$CONDITION\\nTemperatur: $TEMP\\nLuftfeuchtigkeit: $HUMIDITY\\nWind: $WIND\",\"class\":\"weather\"}"
else
    # Fallback if weather data can't be fetched
    echo "{\"text\":\"󰖐 ?\",\"tooltip\":\"Wetterdaten nicht verfügbar\",\"class\":\"weather-error\"}"
fi
