#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                     DYNAMIC BORDERS SCRIPT - NORD THEME                     ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Nord Color Palette
NORD0="#2e3440"      # Polar Night darkest
NORD1="#3b4252"      # Polar Night
NORD2="#434c5e"      # Polar Night
NORD3="#4c566a"      # Polar Night gray
NORD4="#d8dee9"      # Snow Storm
NORD5="#e5e9f0"      # Snow Storm
NORD6="#eceff4"      # Snow Storm lightest
NORD7="#8fbcbb"      # Frost cyan
NORD8="#88c0d0"      # Frost bright cyan (primary accent)
NORD9="#81a1c1"      # Frost blue
NORD10="#5e81ac"     # Frost dark blue
NORD11="#bf616a"     # Aurora red
NORD12="#d08770"     # Aurora orange
NORD13="#ebcb8b"     # Aurora yellow
NORD14="#a3be8c"     # Aurora green
NORD15="#b48ead"     # Aurora purple

# Border color mapping based on window class
declare -A BORDER_COLORS=(
    # Development
    ["code"]="rgb($NORD8) rgb($NORD9) 45deg"          # VS Code - Frost gradient
    ["code-oss"]="rgb($NORD8) rgb($NORD9) 45deg"      # VS Code OSS
    ["jetbrains-"]="rgb($NORD8) rgb($NORD7) 45deg"    # JetBrains IDEs
    ["vim"]="rgb($NORD14) rgb($NORD13) 45deg"         # Vim - Aurora green/yellow

    # Browsers
    ["firefox"]="rgb($NORD12) rgb($NORD11) 45deg"     # Firefox - Aurora orange/red
    ["chromium"]="rgb($NORD12) rgb($NORD11) 45deg"    # Chromium
    ["chrome"]="rgb($NORD12) rgb($NORD11) 45deg"      # Chrome

    # Terminals
    ["kitty"]="rgb($NORD7) rgb($NORD8) 45deg"         # Kitty - Frost cyan/blue
    ["alacritty"]="rgb($NORD7) rgb($NORD8) 45deg"     # Alacritty
    ["terminal"]="rgb($NORD7) rgb($NORD8) 45deg"      # Generic terminal

    # Media
    ["vlc"]="rgb($NORD15) rgb($NORD12) 45deg"         # VLC - Aurora purple/orange
    ["spotify"]="rgb($NORD14) rgb($NORD13) 45deg"     # Spotify - Aurora green/yellow
    ["mpv"]="rgb($NORD15) rgb($NORD12) 45deg"         # MPV

    # Gaming
    ["steam"]="rgb($NORD11) rgb($NORD12) 45deg"       # Steam - Aurora red/orange
    ["lutris"]="rgb($NORD11) rgb($NORD12) 45deg"      # Lutris

    # System
    ["thunar"]="rgb($NORD9) rgb($NORD10) 45deg"       # Thunar - Frost blue/dark blue
    ["nautilus"]="rgb($NORD9) rgb($NORD10) 45deg"     # Nautilus
    ["dolphin"]="rgb($NORD9) rgb($NORD10) 45deg"      # Dolphin

    # Communication
    ["discord"]="rgb($NORD15) rgb($NORD11) 45deg"     # Discord - Aurora purple/red
    ["telegram"]="rgb($NORD15) rgb($NORD11) 45deg"    # Telegram
    ["slack"]="rgb($NORD15) rgb($NORD11) 45deg"       # Slack

    # Graphics
    ["gimp"]="rgb($NORD13) rgb($NORD14) 45deg"        # GIMP - Aurora yellow/green
    ["inkscape"]="rgb($NORD13) rgb($NORD14) 45deg"    # Inkscape
    ["krita"]="rgb($NORD13) rgb($NORD14) 45deg"       # Krita

    # Office
    ["libreoffice"]="rgb($NORD10) rgb($NORD9) 45deg"  # LibreOffice - Frost dark blue
    ["evince"]="rgb($NORD10) rgb($NORD9) 45deg"       # Evince

    # Special states
    ["floating"]="rgb($NORD11) rgb($NORD12) 45deg"    # Floating windows - Aurora red
    ["urgent"]="rgb($NORD11) rgb($NORD13) 45deg"      # Urgent windows - Red/Yellow flash
    ["minimized"]="rgb($NORD3)"                       # Minimized - Gray (single color)
)

# Default border color
DEFAULT_BORDER="rgb($NORD8) rgb($NORD9) 45deg"

# Function to get border color for window class
get_border_color() {
    local window_class="$1"
    local window_state="$2"

    # Check for special states first
    if [[ "$window_state" == *"urgent"* ]]; then
        echo "${BORDER_COLORS["urgent"]}"
        return
    fi

    if [[ "$window_state" == *"floating"* ]]; then
        echo "${BORDER_COLORS["floating"]}"
        return
    fi

    # Check window class
    local lower_class=$(echo "$window_class" | tr '[:upper:]' '[:lower:]')

    for key in "${!BORDER_COLORS[@]}"; do
        if [[ $lower_class == *"$key"* ]]; then
            echo "${BORDER_COLORS[$key]}"
            return
        fi
    done

    # Default color
    echo "$DEFAULT_BORDER"
}

# Function to update window borders
update_window_borders() {
    # Get all windows
    local windows=$(hyprctl clients -j)

    # Parse and update each window
    echo "$windows" | jq -r '.[] | "\(.address) \(.class) \(.floating) \(.urgent)"' | while read -r address class floating urgent; do
        if [[ "$address" == "null" || -z "$address" ]]; then
            continue
        fi

        # Build state string
        local state=""
        if [[ "$floating" == "true" ]]; then
            state="floating"
        fi
        if [[ "$urgent" == "true" ]]; then
            state="${state} urgent"
        fi

        # Get border color
        local border_color=$(get_border_color "$class" "$state")

        # Apply border color
        hyprctl setprop address:$address bordercolor "$border_color" 2>/dev/null || true
    done
}

# Function to start dynamic borders
start_dynamic_borders() {
    echo "Starting Dynamic Borders..."

    # Initial update
    update_window_borders

    # Monitor for window changes and update borders
    while true; do
        # Listen for window events
        hyprctl --batch "keyword general:col.active_border rgb($NORD8) rgb($NORD9) 45deg; keyword general:col.inactive_border rgb($NORD3)" > /dev/null 2>&1

        # Update borders every 500ms
        sleep 0.5
        update_window_borders
    done
}

# Function to stop dynamic borders
stop_dynamic_borders() {
    echo "Stopping Dynamic Borders..."
    pkill -f "dynamic-borders.sh"
}

# Function to toggle dynamic borders
toggle_dynamic_borders() {
    if pgrep -f "dynamic-borders.sh start" > /dev/null; then
        stop_dynamic_borders
        echo "Dynamic Borders: OFF"
    else
        start_dynamic_borders &
        echo "Dynamic Borders: ON"
    fi
}

# Main function
main() {
    case "$1" in
        "start")
            start_dynamic_borders
            ;;
        "stop")
            stop_dynamic_borders
            ;;
        "toggle")
            toggle_dynamic_borders
            ;;
        "update")
            update_window_borders
            ;;
        *)
            echo "Usage: $0 {start|stop|toggle|update}"
            echo "  start  - Start dynamic borders"
            echo "  stop   - Stop dynamic borders"
            echo "  toggle - Toggle dynamic borders on/off"
            echo "  update - Update borders once"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"

