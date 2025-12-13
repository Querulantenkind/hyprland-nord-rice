#!/bin/bash
# Magnetic Window Snapping with Liquid/Goo Effects
# Enhanced snapping with smooth animations and magnetic attraction

# Configuration
MAGNETIC_DISTANCE=50  # Distance in pixels for magnetic attraction
SNAP_ANIMATION_TIME=300  # Animation time in milliseconds
ELASTIC_BOUNCE=1.2  # Elasticity factor for overshoot

# Function to get window position and size
get_window_info() {
    hyprctl activewindow -j | jq -r '.at[0], .at[1], .size[0], .size[1]'
}

# Function to get monitor dimensions
get_monitor_info() {
    hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .width, .height, .x, .y'
}

# Function to calculate magnetic snap position
calculate_magnetic_snap() {
    local win_x=$1 win_y=$2 win_w=$3 win_h=$4
    local mon_w=$5 mon_h=$6 mon_x=$7 mon_y=$8
    local direction=$9

    case $direction in
        "left")
            if [ $win_x -lt $MAGNETIC_DISTANCE ]; then
                echo "0 $win_y"
            else
                echo "$win_x $win_y"
            fi
            ;;
        "right")
            local right_edge=$((win_x + win_w))
            local mon_right=$((mon_x + mon_w))
            if [ $((mon_right - right_edge)) -lt $MAGNETIC_DISTANCE ]; then
                echo "$((mon_right - win_w)) $win_y"
            else
                echo "$win_x $win_y"
            fi
            ;;
        "top")
            if [ $win_y -lt $MAGNETIC_DISTANCE ]; then
                echo "$win_x 0"
            else
                echo "$win_x $win_y"
            fi
            ;;
        "bottom")
            local bottom_edge=$((win_y + win_h))
            local mon_bottom=$((mon_y + mon_h))
            if [ $((mon_bottom - bottom_edge)) -lt $MAGNETIC_DISTANCE ]; then
                echo "$win_x $((mon_bottom - win_h))"
            else
                echo "$win_x $win_y"
            fi
            ;;
        "center")
            echo "$(((mon_w - win_w) / 2)) $(((mon_h - win_h) / 2))"
            ;;
    esac
}

# Function for elastic resize animation
elastic_resize() {
    local direction=$1
    local step_size=20
    local steps=5

    for ((i=1; i<=steps; i++)); do
        case $direction in
            "grow")
                hyprctl dispatch resizeactive $step_size $step_size
                ;;
            "shrink")
                hyprctl dispatch resizeactive -$step_size -$step_size
                ;;
        esac
        sleep 0.02
    done

    # Bounce back effect
    for ((i=1; i<=2; i++)); do
        case $direction in
            "grow")
                hyprctl dispatch resizeactive -$((step_size/3)) -$((step_size/3))
                ;;
            "shrink")
                hyprctl dispatch resizeactive $((step_size/3)) $((step_size/3))
                ;;
        esac
        sleep 0.05
    done
}

# Function for liquid window morphing between workspaces
workspace_morph() {
    local target_workspace=$1

    # Get current window info
    read win_x win_y win_w win_h <<< $(get_window_info)

    # Create morphing effect by scaling window
    hyprctl dispatch resizeactive -$((win_w/4)) -$((win_h/4))
    sleep 0.1

    # Move to new workspace
    hyprctl dispatch movetoworkspacesilent $target_workspace

    # Restore size with elastic effect
    elastic_resize "grow"
}

# Main function for magnetic snapping
magnetic_snap() {
    local direction=$1

    # Get current window and monitor info
    read win_x win_y win_w win_h <<< $(get_window_info)
    read mon_w mon_h mon_x mon_y <<< $(get_monitor_info)

    # Calculate magnetic snap position
    read new_x new_y <<< $(calculate_magnetic_snap $win_x $win_y $win_w $win_h $mon_w $mon_h $mon_x $mon_y $direction)

    # Apply magnetic movement with animation
    if [ "$new_x" != "$win_x" ] || [ "$new_y" != "$win_y" ]; then
        # Smooth magnetic attraction
        hyprctl dispatch movewindowpixel "$new_x $new_y" active
    fi
}

# Function for goo-like window effects
goo_effect() {
    local effect_type=$1

    case $effect_type in
        "bounce")
            # Bounce effect on window focus
            hyprctl dispatch resizeactive -10 -10
            sleep 0.05
            hyprctl dispatch resizeactive 20 20
            sleep 0.05
            hyprctl dispatch resizeactive -10 -10
            ;;
        "melt")
            # Melting effect for window close
            for ((i=1; i<=5; i++)); do
                hyprctl dispatch resizeactive -5 -5
                sleep 0.02
            done
            ;;
        "stretch")
            # Stretching effect for resize
            hyprctl dispatch resizeactive 50 0
            sleep 0.1
            hyprctl dispatch resizeactive -50 0
            ;;
    esac
}

# Parse command line arguments
case $1 in
    "snap")
        magnetic_snap $2
        ;;
    "elastic-resize")
        elastic_resize $2
        ;;
    "workspace-morph")
        workspace_morph $2
        ;;
    "goo")
        goo_effect $2
        ;;
    *)
        echo "Usage: $0 {snap|elastic-resize|workspace-morph|goo} [direction|workspace|effect]"
        echo "Examples:"
        echo "  $0 snap left          # Magnetic snap to left"
        echo "  $0 elastic-resize grow # Elastic resize grow"
        echo "  $0 workspace-morph 2  # Morph to workspace 2"
        echo "  $0 goo bounce         # Goo bounce effect"
        exit 1
        ;;
esac
