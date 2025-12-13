#!/bin/bash
# Advanced Animations System for Hyprland
# Handles liquid/goo effects, elastic resizing, and morph transitions

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$HOME/.config/hypr/advanced-animations.conf"

# Default configuration
declare -A CONFIG=(
    ["ENABLED"]="true"
    ["LIQUID_ENABLED"]="true"
    ["MAGNETIC_ENABLED"]="true"
    ["ELASTIC_RESIZE_ENABLED"]="true"
    ["MORPH_TRANSITIONS_ENABLED"]="true"
    ["MAGNETIC_DISTANCE"]="30"
    ["ELASTIC_FACTOR"]="1.15"
    ["ANIMATION_SPEED"]="1.0"
    ["GOO_INTENSITY"]="0.8"
)

# Load configuration
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        while IFS='=' read -r key value; do
            [[ $key =~ ^[[:space:]]*# ]] && continue
            [[ -z $key ]] && continue
            CONFIG["$key"]="$value"
        done < "$CONFIG_FILE"
    fi
}

# Save configuration
save_config() {
    mkdir -p "$(dirname "$CONFIG_FILE")"
    {
        echo "# Advanced Animations Configuration"
        echo "# Generated on $(date)"
        echo ""
        for key in "${!CONFIG[@]}"; do
            echo "$key=${CONFIG[$key]}"
        done
    } > "$CONFIG_FILE"
}

# Enhanced liquid/goo window effects
liquid_window_effect() {
    local window_id=$1
    local effect_type=$2

    if [ "${CONFIG[LIQUID_ENABLED]}" != "true" ]; then
        return
    fi

    case $effect_type in
        "focus")
            # Liquid ripple effect on focus
            hyprctl dispatch resizeactive 5 5
            sleep 0.03
            hyprctl dispatch resizeactive -10 -10
            sleep 0.03
            hyprctl dispatch resizeactive 5 5
            ;;
        "unfocus")
            # Gentle settle effect
            hyprctl dispatch resizeactive -2 -2
            sleep 0.05
            hyprctl dispatch resizeactive 2 2
            ;;
        "open")
            # Elastic opening with goo effect
            for ((i=1; i<=3; i++)); do
                hyprctl dispatch resizeactive 15 15
                sleep 0.02
                hyprctl dispatch resizeactive -15 -15
                sleep 0.02
            done
            ;;
        "close")
            # Melting goo effect on close
            for ((i=1; i<=8; i++)); do
                hyprctl dispatch resizeactive -3 -3
                sleep 0.01
            done
            ;;
    esac
}

# Magnetic window snapping with advanced physics
magnetic_snap_advanced() {
    local direction=$1
    local window_id=$2

    if [ "${CONFIG[MAGNETIC_ENABLED]}" != "true" ]; then
        return
    fi

    # Get window and monitor info
    local win_info=$(hyprctl activewindow -j)
    local win_x=$(echo "$win_info" | jq '.at[0]')
    local win_y=$(echo "$win_info" | jq '.at[1]')
    local win_w=$(echo "$win_info" | jq '.size[0]')
    local win_h=$(echo "$win_info" | jq '.size[1]')

    local mon_info=$(hyprctl monitors -j | jq '.[0]')
    local mon_w=$(echo "$mon_info" | jq '.width')
    local mon_h=$(echo "$mon_info" | jq '.height')
    local mon_x=$(echo "$mon_info" | jq '.x')
    local mon_y=$(echo "$mon_info" | jq '.y')

    local magnetic_distance=${CONFIG[MAGNETIC_DISTANCE]}
    local target_x=$win_x
    local target_y=$win_y

    case $direction in
        "left")
            if [ $((win_x - mon_x)) -lt $magnetic_distance ]; then
                target_x=$mon_x
                target_y=$win_y
            fi
            ;;
        "right")
            local win_right=$((win_x + win_w))
            local mon_right=$((mon_x + mon_w))
            if [ $((mon_right - win_right)) -lt $magnetic_distance ]; then
                target_x=$((mon_right - win_w))
                target_y=$win_y
            fi
            ;;
        "top")
            if [ $((win_y - mon_y)) -lt $magnetic_distance ]; then
                target_x=$win_x
                target_y=$mon_y
            fi
            ;;
        "bottom")
            local win_bottom=$((win_y + win_h))
            local mon_bottom=$((mon_y + mon_h))
            if [ $((mon_bottom - win_bottom)) -lt $magnetic_distance ]; then
                target_x=$win_x
                target_y=$((mon_bottom - win_h))
            fi
            ;;
        "center")
            target_x=$(( (mon_w - win_w) / 2 + mon_x ))
            target_y=$(( (mon_h - win_h) / 2 + mon_y ))
            ;;
    esac

    # Apply magnetic movement with smooth animation
    if [ "$target_x" != "$win_x" ] || [ "$target_y" != "$win_y" ]; then
        hyprctl dispatch movewindowpixel "$target_x $target_y"
        # Add slight elastic overshoot
        local overshoot_x=$(( (target_x - win_x) / 10 ))
        local overshoot_y=$(( (target_y - win_y) / 10 ))
        if [ $overshoot_x -ne 0 ] || [ $overshoot_y -ne 0 ]; then
            hyprctl dispatch movewindowpixel "$((target_x + overshoot_x)) $((target_y + overshoot_y))"
            sleep 0.05
            hyprctl dispatch movewindowpixel "$target_x $target_y"
        fi
    fi
}

# Elastic window resize with advanced physics
elastic_resize_advanced() {
    local direction=$1
    local factor=${CONFIG[ELASTIC_FACTOR]}

    if [ "${CONFIG[ELASTIC_RESIZE_ENABLED]}" != "true" ]; then
        return
    fi

    local win_info=$(hyprctl activewindow -j)
    local win_w=$(echo "$win_info" | jq '.size[0]')
    local win_h=$(echo "$win_info" | jq '.size[1]')

    case $direction in
        "grow")
            local new_w=$((win_w * factor / 10))
            local new_h=$((win_h * factor / 10))

            # Elastic grow with overshoot
            hyprctl dispatch resizeactive $((new_w * 12 / 10)) $((new_h * 12 / 10))
            sleep 0.03
            hyprctl dispatch resizeactive -$((new_w * 2 / 10)) -$((new_h * 2 / 10))
            sleep 0.03
            hyprctl dispatch resizeactive $((new_w * 8 / 100)) $((new_h * 8 / 100))
            ;;
        "shrink")
            local shrink_w=$((win_w / 8))
            local shrink_h=$((win_h / 8))

            # Elastic shrink with bounce back
            hyprctl dispatch resizeactive -$shrink_w -$shrink_h
            sleep 0.03
            hyprctl dispatch resizeactive $((shrink_w / 3)) $((shrink_h / 3))
            sleep 0.03
            hyprctl dispatch resizeactive -$((shrink_w / 6)) -$((shrink_h / 6))
            ;;
    esac
}

# Workspace morph transitions
workspace_morph_transition() {
    local target_workspace=$1

    if [ "${CONFIG[MORPH_TRANSITIONS_ENABLED]}" != "true" ]; then
        hyprctl dispatch workspace $target_workspace
        return
    fi

    local win_info=$(hyprctl activewindow -j)
    local win_w=$(echo "$win_info" | jq '.size[0]')
    local win_h=$(echo "$win_info" | jq '.size[1]')

    # Morphing effect: shrink, move, grow
    hyprctl dispatch resizeactive -$((win_w / 3)) -$((win_h / 3))
    sleep 0.1

    hyprctl dispatch movetoworkspacesilent $target_workspace

    # Elastic grow back with goo effect
    for ((i=1; i<=3; i++)); do
        hyprctl dispatch resizeactive $((win_w / 9)) $((win_h / 9))
        sleep 0.02
        hyprctl dispatch resizeactive -$((win_w / 18)) -$((win_h / 18))
        sleep 0.02
    done

    hyprctl dispatch resizeactive $((win_w / 9)) $((win_h / 9))
}

# Event listener for window events
listen_events() {
    local enabled=${CONFIG[ENABLED]}

    if [ "$enabled" != "true" ]; then
        echo "Advanced animations disabled"
        return
    fi

    echo "Advanced animations enabled - listening for events..."

    # Listen for Hyprland events (simplified version)
    # In a real implementation, this would use hyprctl or socket connections
    while true; do
        # This is a placeholder for actual event listening
        # In production, you'd use hyprctl or connect to Hyprland's socket
        sleep 1
    done
}

# Configuration management
case $1 in
    "load")
        load_config
        echo "Configuration loaded"
        ;;
    "save")
        save_config
        echo "Configuration saved"
        ;;
    "set")
        CONFIG["$2"]="$3"
        save_config
        echo "Setting $2 = $3"
        ;;
    "get")
        echo "${CONFIG[$2]}"
        ;;
    "liquid")
        load_config
        liquid_window_effect "$2" "$3"
        ;;
    "magnetic")
        load_config
        magnetic_snap_advanced "$2" "$3"
        ;;
    "elastic")
        load_config
        elastic_resize_advanced "$2"
        ;;
    "morph")
        load_config
        workspace_morph_transition "$2"
        ;;
    "listen")
        load_config
        listen_events
        ;;
    "toggle")
        load_config
        if [ "${CONFIG[ENABLED]}" = "true" ]; then
            CONFIG["ENABLED"]="false"
            echo "Advanced animations disabled"
        else
            CONFIG["ENABLED"]="true"
            echo "Advanced animations enabled"
        fi
        save_config
        ;;
    *)
        echo "Usage: $0 {load|save|set|get|liquid|magnetic|elastic|morph|listen|toggle} [args...]"
        echo ""
        echo "Configuration options:"
        echo "  ENABLED - Enable/disable all animations"
        echo "  LIQUID_ENABLED - Enable liquid/goo effects"
        echo "  MAGNETIC_ENABLED - Enable magnetic snapping"
        echo "  ELASTIC_RESIZE_ENABLED - Enable elastic resize"
        echo "  MORPH_TRANSITIONS_ENABLED - Enable workspace morphing"
        echo "  MAGNETIC_DISTANCE - Distance for magnetic attraction (pixels)"
        echo "  ELASTIC_FACTOR - Elasticity multiplier"
        echo "  ANIMATION_SPEED - Animation speed multiplier"
        echo "  GOO_INTENSITY - Intensity of goo effects"
        exit 1
        ;;
esac
