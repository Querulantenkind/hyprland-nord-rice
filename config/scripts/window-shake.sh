#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                     WINDOW SHAKE SCRIPT - NORD THEME                       ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Configuration
SHAKE_INTENSITY="${1:-5}"     # Pixels to shake
SHAKE_SPEED="${2:-50}"        # Milliseconds between shakes
SHAKE_COUNT="${3:-6}"         # Number of shakes
WINDOW_ADDRESS="${4:-}"       # Specific window address (empty = active window)

# Nord Colors for border flash
NORD11="#bf616a"     # Aurora red (error)
NORD13="#ebcb8b"     # Aurora yellow (warning)
NORD14="#a3be8c"     # Aurora green (success)
NORD8="#88c0d0"      # Frost blue (info)

# Get window information
get_window_info() {
    local address="$1"

    if [ -n "$address" ]; then
        # Specific window
        hyprctl clients -j | jq -r ".[] | select(.address == \"$address\") | \"\(.at[0])\t\(.at[1])\t\(.size[0])\t\(.size[1])\""
    else
        # Active window
        hyprctl activewindow -j | jq -r "\"\(.at[0])\t\(.at[1])\t\(.size[0])\t\(.size[1])\t\(.address)\""
    fi
}

# Shake window function
shake_window() {
    local address="$1"
    local intensity="$2"
    local speed="$3"
    local count="$4"

    # Get window info
    local window_info=$(get_window_info "$address")
    if [ -z "$window_info" ]; then
        echo "Window not found"
        return 1
    fi

    # Parse window info
    IFS=$'\t' read -r x y width height window_addr <<< "$window_info"
    address="${address:-$window_addr}"

    # Store original position
    local original_x="$x"
    local original_y="$y"

    # Shake pattern: left-right alternating
    local directions=(1 -1 1 -1 1 -1)

    for ((i=0; i<count; i++)); do
        local direction=${directions[$i % ${#directions[@]}]}
        local offset=$((direction * intensity))

        # Move window
        hyprctl dispatch movewindowpixel "exact $((x + offset)) $y,address:$address"

        # Wait
        sleep "$(echo "scale=3; $speed / 1000" | bc)"

        # Return to center (but not original position yet)
        hyprctl dispatch movewindowpixel "exact $x $y,address:$address"

        # Quick pause
        sleep "$(echo "scale=3; $speed / 2000" | bc)"
    done

    # Return to original position
    hyprctl dispatch movewindowpixel "exact $original_x $original_y,address:$address"
}

# Border flash function
flash_border() {
    local address="$1"
    local color="$2"
    local duration="${3:-500}"  # milliseconds

    # Convert hex to rgb
    local r=$(printf '%d' "0x${color:1:2}")
    local g=$(printf '%d' "0x${color:3:2}")
    local b=$(printf '%d' "0x${color:5:2}")

    # Flash border color
    hyprctl setprop "address:$address" bordercolor "rgb($r, $g, $b)"

    # Wait
    sleep "$(echo "scale=3; $duration / 1000" | bc)"

    # Reset to dynamic border or default
    ~/.config/scripts/dynamic-borders.sh update 2>/dev/null || \
    hyprctl setprop "address:$address" bordercolor "rgb(136, 192, 208) rgb(129, 161, 193) 45deg"
}

# Combined shake and flash
shake_and_flash() {
    local address="$1"
    local shake_intensity="$2"
    local shake_speed="$3"
    local shake_count="$4"
    local flash_color="$5"

    # Start flash in background
    flash_border "$address" "$flash_color" "$((shake_speed * shake_count))" &

    # Shake window
    shake_window "$address" "$shake_intensity" "$shake_speed" "$shake_count"

    # Wait for flash to complete
    wait
}

# Error shake (red flash)
error_shake() {
    local address="$1"
    shake_and_flash "$address" 8 60 8 "$NORD11"
    echo "Error shake applied"
}

# Warning shake (yellow flash)
warning_shake() {
    local address="$1"
    shake_and_flash "$address" 6 70 6 "$NORD13"
    echo "Warning shake applied"
}

# Success shake (green flash)
success_shake() {
    local address="$1"
    shake_and_flash "$address" 4 80 4 "$NORD14"
    echo "Success shake applied"
}

# Info shake (blue flash)
info_shake() {
    local address="$1"
    shake_and_flash "$address" 3 90 4 "$NORD8"
    echo "Info shake applied"
}

# Custom shake
custom_shake() {
    local address="$1"
    local intensity="${2:-5}"
    local speed="${3:-50}"
    local count="${4:-6}"
    local color="${5:-$NORD11}"

    shake_and_flash "$address" "$intensity" "$speed" "$count" "$color"
    echo "Custom shake applied"
}

# Shake all windows
shake_all() {
    local shake_type="$1"

    # Get all window addresses
    local addresses=$(hyprctl clients -j | jq -r '.[].address')

    for address in $addresses; do
        case "$shake_type" in
            "error") error_shake "$address" ;;
            "warning") warning_shake "$address" ;;
            "success") success_shake "$address" ;;
            "info") info_shake "$address" ;;
            *) error_shake "$address" ;;
        esac

        # Small delay between windows
        sleep 0.1
    done
}

# Test shake patterns
test_shakes() {
    echo "Testing shake patterns..."

    # Test each type
    echo "Error shake:"
    error_shake "$WINDOW_ADDRESS"
    sleep 1

    echo "Warning shake:"
    warning_shake "$WINDOW_ADDRESS"
    sleep 1

    echo "Success shake:"
    success_shake "$WINDOW_ADDRESS"
    sleep 1

    echo "Info shake:"
    info_shake "$WINDOW_ADDRESS"
}

# Main function
main() {
    case "$1" in
        "error")
            error_shake "$WINDOW_ADDRESS"
            ;;
        "warning")
            warning_shake "$WINDOW_ADDRESS"
            ;;
        "success")
            success_shake "$WINDOW_ADDRESS"
            ;;
        "info")
            info_shake "$WINDOW_ADDRESS"
            ;;
        "custom")
            shift
            custom_shake "$@"
            ;;
        "all")
            local shake_type="${2:-error}"
            shake_all "$shake_type"
            ;;
        "test")
            test_shakes
            ;;
        "border")
            local color="${2:-$NORD11}"
            flash_border "$WINDOW_ADDRESS" "$color"
            ;;
        *)
            echo "Usage: $0 {error|warning|success|info|custom|all|test|border} [options]"
            echo "  error [address]    - Error shake with red flash"
            echo "  warning [address]  - Warning shake with yellow flash"
            echo "  success [address]  - Success shake with green flash"
            echo "  info [address]     - Info shake with blue flash"
            echo "  custom intensity speed count color [address] - Custom shake"
            echo "  all [type]         - Shake all windows (default: error)"
            echo "  test               - Test all shake patterns"
            echo "  border color [address] - Flash border only"
            echo ""
            echo "Examples:"
            echo "  $0 error           # Error shake active window"
            echo "  $0 warning 0x123   # Warning shake specific window"
            echo "  $0 custom 10 40 8 #bf616a  # Custom red shake"
            echo "  $0 all success     # Success shake all windows"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"

