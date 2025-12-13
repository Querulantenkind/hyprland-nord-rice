#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                     SCREEN GLOW SCRIPT - NORD THEME                        ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Configuration
MONITOR="${1:-$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')}"
GLOW_INTENSITY="${2:-0.7}"
UPDATE_INTERVAL=1

# Nord Colors
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

# Application to color mapping
declare -A APP_COLORS=(
    # Development
    ["code"]="$NORD8"
    ["code-oss"]="$NORD8"
    ["jetbrains-"]="$NORD8"
    ["vim"]="$NORD14"
    ["nvim"]="$NORD14"

    # Browsers
    ["firefox"]="$NORD12"
    ["chromium"]="$NORD12"
    ["chrome"]="$NORD12"

    # Terminals
    ["kitty"]="$NORD7"
    ["alacritty"]="$NORD7"
    ["terminal"]="$NORD7"

    # Media
    ["vlc"]="$NORD15"
    ["spotify"]="$NORD14"
    ["mpv"]="$NORD15"

    # Gaming
    ["steam"]="$NORD11"

    # Communication
    ["discord"]="$NORD15"
    ["telegram"]="$NORD15"
    ["slack"]="$NORD15"

    # Graphics
    ["gimp"]="$NORD13"
    ["inkscape"]="$NORD13"
    ["krita"]="$NORD13"
)

# Workspace to color mapping
declare -A WORKSPACE_COLORS=(
    ["1"]="$NORD8"   # Terminal/Home
    ["2"]="$NORD12"  # Web Browser
    ["3"]="$NORD8"   # Code Editor
    ["4"]="$NORD15"  # Communication
    ["5"]="$NORD14"  # Media
    ["6"]="$NORD13"  # Graphics
    ["7"]="$NORD9"   # Documents
    ["8"]="$NORD11"  # Gaming
    ["9"]="$NORD7"   # System
    ["10"]="$NORD10" # Special
)

# Get screen dimensions
get_screen_info() {
    local monitor_info=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$MONITOR\")")
    if [ -z "$monitor_info" ]; then
        echo "Monitor $MONITOR not found, using primary monitor"
        monitor_info=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)')
    fi

    WIDTH=$(echo "$monitor_info" | jq -r '.width')
    HEIGHT=$(echo "$monitor_info" | jq -r '.height')
    X=$(echo "$monitor_info" | jq -r '.x')
    Y=$(echo "$monitor_info" | jq -r '.y')

    echo "Monitor: $MONITOR, Size: ${WIDTH}x${HEIGHT}, Position: ${X}x${Y}"
}

# Get current workspace
get_current_workspace() {
    hyprctl activeworkspace -j | jq -r '.id'
}

# Get active window class
get_active_window_class() {
    hyprctl activewindow -j | jq -r '.class // empty'
}

# Get glow color based on context
get_glow_color() {
    local workspace=$(get_current_workspace)
    local window_class=$(get_active_window_class)

    # Priority: Active window > Workspace
    if [ -n "$window_class" ]; then
        local lower_class=$(echo "$window_class" | tr '[:upper:]' '[:lower:]')
        for key in "${!APP_COLORS[@]}"; do
            if [[ $lower_class == *"$key"* ]]; then
                echo "${APP_COLORS[$key]}"
                return
            fi
        done
    fi

    # Fallback to workspace color
    echo "${WORKSPACE_COLORS[$workspace]:-$NORD8}"
}

# Create glow effect using hyprctl keyword
apply_glow_effect() {
    local color="$1"
    local intensity="$2"

    # Convert hex to rgb
    local r=$(printf '%d' "0x${color:1:2}")
    local g=$(printf '%d' "0x${color:3:2}")
    local b=$(printf '%d' "0x${color:5:2}")

    # Create rgba with intensity
    local alpha=$(echo "scale=2; $intensity" | bc)

    # Apply decoration blur with color tint (simulated glow)
    hyprctl keyword decoration:blur:size 12
    hyprctl keyword decoration:blur:passes 3
    hyprctl keyword decoration:shadow:range 25
    hyprctl keyword decoration:shadow:render_power 4
    hyprctl keyword decoration:shadow:color "rgba(${r}, ${g}, ${b}, ${alpha})"
}

# Remove glow effect
remove_glow_effect() {
    # Reset to default values
    hyprctl keyword decoration:blur:size 8
    hyprctl keyword decoration:blur:passes 2
    hyprctl keyword decoration:shadow:range 20
    hyprctl keyword decoration:shadow:render_power 3
    hyprctl keyword decoration:shadow:color "rgba(46, 52, 64, 0.37)"
}

# Pulse effect for notifications
pulse_effect() {
    local base_color="$1"
    local duration=${2:-2}

    for ((i=0; i<duration*10; i++)); do
        local intensity=$(echo "scale=2; 0.3 + 0.4 * (1 + s($i * 3.14159 / 5)) / 2" | bc -l)
        apply_glow_effect "$base_color" "$intensity"
        sleep 0.1
    done

    # Reset to normal
    apply_glow_effect "$base_color" "$GLOW_INTENSITY"
}

# Notification-triggered glow
notification_glow() {
    local urgency="$1"
    local color

    case "$urgency" in
        "critical") color="$NORD11" ;;  # Red
        "normal") color="$NORD8" ;;     # Blue
        *) color="$NORD3" ;;            # Gray
    esac

    pulse_effect "$color" 3
}

# Main glow loop
glow_loop() {
    echo "Starting screen glow effect on monitor $MONITOR"

    while true; do
        local glow_color=$(get_glow_color)
        apply_glow_effect "$glow_color" "$GLOW_INTENSITY"
        sleep "$UPDATE_INTERVAL"
    done
}

# Start screen glow
start_glow() {
    # Kill any existing glow process
    pkill -f "screen-glow.sh.*glow_loop"

    # Start new glow process
    get_screen_info
    glow_loop &
    echo "Screen glow started"
}

# Stop screen glow
stop_glow() {
    pkill -f "screen-glow.sh.*glow_loop"
    remove_glow_effect
    echo "Screen glow stopped"
}

# Toggle screen glow
toggle_glow() {
    if pgrep -f "screen-glow.sh.*glow_loop" > /dev/null; then
        stop_glow
    else
        start_glow
    fi
}

# Main function
main() {
    case "$1" in
        "start")
            start_glow
            ;;
        "stop")
            stop_glow
            ;;
        "toggle")
            toggle_glow
            ;;
        "pulse")
            local urgency="${2:-normal}"
            notification_glow "$urgency"
            ;;
        "color")
            local color="${2:-$NORD8}"
            apply_glow_effect "$color" "$GLOW_INTENSITY"
            ;;
        *)
            echo "Usage: $0 {start|stop|toggle|pulse|color} [options]"
            echo "  start          - Start ambient screen glow"
            echo "  stop           - Stop screen glow"
            echo "  toggle         - Toggle screen glow on/off"
            echo "  pulse [urgency] - Pulse effect (critical|normal|low)"
            echo "  color [hex]    - Set specific glow color"
            echo ""
            echo "Examples:"
            echo "  $0 start           # Start ambient glow"
            echo "  $0 pulse critical  # Red pulse for critical notifications"
            echo "  $0 color #88c0d0   # Set to Nord blue"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"

