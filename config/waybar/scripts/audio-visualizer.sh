#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                     AUDIO-VISUALIZER SCRIPT - NORD THEME                     ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Configuration
BAR_COUNT=8           # Number of bars in visualizer
BAR_HEIGHT=10         # Maximum height of bars
UPDATE_RATE=60        # Update rate in milliseconds
SENSITIVITY=250       # Cava sensitivity
FRAMERATE=60          # Cava framerate

# Nord Colors (matching theme)
NORD8="#88c0d0"      # Frost blue
NORD9="#81a1c1"      # Frost blue-gray
NORD3="#4c566a"      # Polar Night gray
NORD0="#2e3440"      # Polar Night darkest

# Function to get cava output
get_cava_data() {
    # Check if cava is running
    if ! pgrep -x "cava" > /dev/null; then
        echo "No cava process found. Make sure cava is running with proper config."
        exit 1
    fi

    # Read from cava FIFO or try to capture output
    if [ -p "/tmp/cava.fifo" ]; then
        timeout 0.1 cat "/tmp/cava.fifo" 2>/dev/null || echo ""
    else
        # Alternative: try to get data from cava directly
        echo ""
    fi
}

# Function to create visual bars
create_bars() {
    local cava_data="$1"
    local bars=""

    # Parse cava data (assuming space-separated values)
    IFS=' ' read -ra values <<< "$cava_data"

    # Create bars for each segment
    for ((i=0; i<BAR_COUNT; i++)); do
        # Get value for this bar (distribute across available data)
        local index=$((i * ${#values[@]} / BAR_COUNT))
        local value=${values[$index]:-0}

        # Normalize value (assuming 0-100 range from cava)
        local height=$((value * BAR_HEIGHT / 100))

        # Create gradient color based on height
        local color
        if [ $height -gt 7 ]; then
            color="$NORD8"  # Bright blue for high bars
        elif [ $height -gt 4 ]; then
            color="$NORD9"  # Medium blue for medium bars
        else
            color="$NORD3"  # Gray for low bars
        fi

        # Create bar segments
        local bar=""
        for ((j=0; j<BAR_HEIGHT; j++)); do
            if [ $j -lt $height ]; then
                bar="█$bar"  # Filled bar
            else
                bar="░$bar"  # Empty bar
            fi
        done

        # Color the bar
        bars+="<span color=\"$color\">$bar</span> "
    done

    echo "$bars"
}

# Function to check if audio is playing
is_audio_playing() {
    # Check for active audio streams
    if command -v pactl >/dev/null 2>&1; then
        pactl list sink-inputs | grep -q "state: RUNNING"
        return $?
    elif command -v amixer >/dev/null 2>&1; then
        amixer get Master | grep -q "\[on\]"
        return $?
    else
        return 1
    fi
}

# Main function
main() {
    case "$1" in
        "toggle")
            # Toggle cava process
            if pgrep -x "cava" > /dev/null; then
                pkill -x cava
                echo '{"text": "󰎇", "tooltip": "Audio Visualizer: OFF"}'
            else
                # Start cava in background
                nohup cava -p ~/.config/cava/config &
                echo '{"text": "󰎆", "tooltip": "Audio Visualizer: ON"}'
            fi
            ;;
        "status")
            # Return status for waybar
            if pgrep -x "cava" > /dev/null && is_audio_playing; then
                cava_data=$(get_cava_data)
                if [ -n "$cava_data" ]; then
                    bars=$(create_bars "$cava_data")
                    echo "{\"text\": \"$bars\", \"tooltip\": \"Audio Visualizer Active\"}"
                else
                    echo '{"text": "󰎆", "tooltip": "Audio Visualizer: No Data"}'
                fi
            else
                echo '{"text": "󰎇", "tooltip": "Audio Visualizer: Inactive"}'
            fi
            ;;
        *)
            # Default: output for waybar module
            if pgrep -x "cava" > /dev/null && is_audio_playing; then
                cava_data=$(get_cava_data)
                if [ -n "$cava_data" ]; then
                    bars=$(create_bars "$cava_data")
                    echo "$bars"
                else
                    echo "󰎆"
                fi
            else
                echo "󰎇"
            fi
            ;;
    esac
}

# Run main function
main "$@"

