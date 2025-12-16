#!/bin/bash

# Wofi Script Runner
# Run custom scripts from a dedicated directory

# Script directories (primary and fallback)
SCRIPT_DIR="$HOME/.config/hypr/scripts"
SCRIPT_DIR_ALT="$HOME/.config/scripts"
mkdir -p "$SCRIPT_DIR"

# Colors for output
NORD8='\033[38;2;136;192;208m'
NORD4='\033[38;2;216;222;233m'
NORD14='\033[38;2;163;190;140m'
NORD11='\033[38;2;191;97;106m'
RESET='\033[0m'

# Default scripts to create if they don't exist
create_default_scripts() {
    # Screenshot script
    if [ ! -f "$SCRIPT_DIR/screenshot.sh" ]; then
        cat > "$SCRIPT_DIR/screenshot.sh" << 'EOF'
#!/bin/bash
# Screenshot script with options
CHOICE=$(echo -e "Area\nFull\nWindow" | wofi --dmenu --prompt "Screenshot:" --width 300 --height 200)

case "$CHOICE" in
    "Area")
        grim -g "$(slurp)" - | wl-copy
        notify-send "Screenshot" "Area copied to clipboard"
        ;;
    "Full")
        grim - | wl-copy
        notify-send "Screenshot" "Full screen copied to clipboard"
        ;;
    "Window")
        grim -g "$(hyprctl activewindow -j | jq -r '.at,.size' | tr '\n' ' ' | sed 's/ /,/g' | sed 's/,$//')" - | wl-copy
        notify-send "Screenshot" "Window copied to clipboard"
        ;;
esac
EOF
        chmod +x "$SCRIPT_DIR/screenshot.sh"
    fi

    # System info script
    if [ ! -f "$SCRIPT_DIR/sysinfo.sh" ]; then
        cat > "$SCRIPT_DIR/sysinfo.sh" << 'EOF'
#!/bin/bash
# System information display
kitty --title "System Info" -- bash -c "
echo '=== SYSTEM INFORMATION ==='
echo 'OS:      $(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '\"')'
echo 'Kernel:  $(uname -r)'
echo 'Uptime:  $(uptime -p)'
echo 'CPU:     $(lscpu | grep 'Model name' | cut -d: -f2 | sed 's/^[ \t]*//')"
echo 'Memory:  $(free -h | grep Mem | awk '{print $3 \"/\" $2}')"
echo 'Disk:    $(df -h / | tail -1 | awk '{print $3 \"/\" $2 \" (\" $5 \" used)\"}')"
echo ''
echo 'Press Enter to close...'
read
"
EOF
        chmod +x "$SCRIPT_DIR/sysinfo.sh"
    fi

    # Network info script
    if [ ! -f "$SCRIPT_DIR/network.sh" ]; then
        cat > "$SCRIPT_DIR/network.sh" << 'EOF'
#!/bin/bash
# Network information and control
kitty --title "Network Manager" -- bash -c "
echo '=== NETWORK INTERFACES ==='
ip -brief addr show
echo ''
echo '=== WIFI NETWORKS ==='
nmcli device wifi list
echo ''
echo 'Press Enter to close...'
read
"
EOF
        chmod +x "$SCRIPT_DIR/network.sh"
    fi

    # Bluetooth script
    if [ ! -f "$SCRIPT_DIR/bluetooth.sh" ]; then
        cat > "$SCRIPT_DIR/bluetooth.sh" << 'EOF'
#!/bin/bash
# Bluetooth device manager
kitty --title "Bluetooth Manager" -- bash -c "
echo '=== BLUETOOTH DEVICES ==='
bluetoothctl devices
echo ''
echo '=== CONNECTED DEVICES ==='
bluetoothctl info
echo ''
echo 'Press Enter to close...'
read
"
EOF
        chmod +x "$SCRIPT_DIR/bluetooth.sh"
    fi
}

# Create default scripts if directory is empty
if [ -z "$(ls -A "$SCRIPT_DIR")" ]; then
    create_default_scripts
fi

# Get list of available scripts from both directories
SCRIPTS=""
if [ -d "$SCRIPT_DIR" ]; then
    SCRIPTS+=$(find "$SCRIPT_DIR" -maxdepth 1 -type f -executable -printf '%P\n' 2>/dev/null)
fi
if [ -d "$SCRIPT_DIR_ALT" ]; then
    ALT_SCRIPTS=$(find "$SCRIPT_DIR_ALT" -maxdepth 1 -type f -executable -printf '%P\n' 2>/dev/null)
    if [ -n "$ALT_SCRIPTS" ]; then
        [ -n "$SCRIPTS" ] && SCRIPTS+="\n"
        SCRIPTS+="$ALT_SCRIPTS"
    fi
fi
SCRIPTS=$(echo -e "$SCRIPTS" | sort -u)

if [ -z "$SCRIPTS" ]; then
    echo -e "${NORD11}Keine ausführbaren Scripts in $SCRIPT_DIR gefunden${RESET}"
    echo -e "${NORD8}Erstelle einige Standard-Scripts...${RESET}"
    create_default_scripts
    SCRIPTS=$(find "$SCRIPT_DIR" -maxdepth 1 -type f -executable -printf '%P\n' | sort)
fi

# Show script menu with wofi
SELECTED=$(echo "$SCRIPTS" | wofi --dmenu --prompt "Script ausführen:" --width 500 --height 300 --location center --gtk-dark)

# Execute selected script
if [ -n "$SELECTED" ]; then
    # Check both directories for the script
    if [ -x "$SCRIPT_DIR/$SELECTED" ]; then
        SCRIPT_PATH="$SCRIPT_DIR/$SELECTED"
    elif [ -x "$SCRIPT_DIR_ALT/$SELECTED" ]; then
        SCRIPT_PATH="$SCRIPT_DIR_ALT/$SELECTED"
    else
        echo -e "${NORD11}Script $SELECTED nicht gefunden${RESET}"
        exit 1
    fi
    
    echo -e "${NORD14}Führe $SELECTED aus...${RESET}"
    "$SCRIPT_PATH" &
fi
