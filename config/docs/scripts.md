# Hyprland Nord Rice - Scripts Documentation

## Overview

All custom scripts included in Hyprland Nord Rice and their functions, parameters, and customization options.

## Waybar Scripts

### `check-updates.sh`
**Path:** `~/.config/waybar/scripts/check-updates.sh`

**Function:**
- Checks for available system updates
- Shows update count in Waybar
- Supports different package managers

**Output:**
```json
{"text":"5","tooltip":"5 Updates verfügbar","class":"updates-available"}
```

**Configuration:**
```bash
# Supported package managers automatically detected:
# - pacman (Arch Linux)
# - apt (Debian/Ubuntu)
# - dnf (Fedora)
# - Flatpak
```

**Customization:**
```bash
# Change update interval in Waybar configuration:
"custom/updates": {
    "interval": 1800  # Check every 30 minutes
}
```

### `weather.sh`
**Path:** `~/.config/waybar/scripts/weather.sh`

**Function:**
- Fetches weather data from wttr.in
- Shows temperature with weather icon
- Tooltip with detailed information

**Output:**
```json
{"text":"󰖐 15°C","tooltip":"Clear\nTemperatur: 15°C\nLuftfeuchtigkeit: 65%\nWind: 5 km/h","class":"weather"}
```

**Configuration:**
```bash
# Set location:
LOCATION="Berlin"        # City name
LOCATION="52.52,13.41"  # Coordinates
LOCATION="auto"         # Automatic detection
```

### `system-monitor.sh`
**Path:** `~/.config/waybar/scripts/system-monitor.sh`

**Function:**
- Shows detailed system information
- CPU, RAM and disk usage
- Notification with all metrics

**Output:**
```
System Monitor
CPU: 45%
RAM: 8.2G/16G (51%)
Disk: 120G/500G (24% used)
```

**Features:**
- Automatic unit conversion
- Percentage usage
- Available/free memory

### `update-system.sh`
**Path:** `~/.config/waybar/scripts/update-system.sh`

**Function:**
- Perform complete system update
- Multiple package manager support
- Step-by-step execution

**Supported Systems:**
- **Arch Linux:** pacman + yay/paru
- **Debian/Ubuntu:** apt
- **Fedora:** dnf
- **Flatpak:** Universal updates

**Features:**
- Automatic package manager detection
- Safety prompts
- Detailed progress display
- Error handling

## Wofi Scripts

### `modes.sh`
**Path:** `~/.config/wofi/scripts/modes.sh`

**Function:**
- Main launcher for all Wofi modes
- Categorized selection menu
- Automatic mode execution

**Available Modes:**
```bash
apps     → wofi --show drun          # Applications
run      → wofi --show run           # Execute commands
calc     → Calculator Script         # Calculator
emoji    → Emoji Picker              # Emoji selection
scripts  → Script Runner             # Custom scripts
clipboard → Clipboard History        # Clipboard
power    → wlogout                   # Power menu
docs     → Documentation Launcher    # Documentation
```

**Customization:**
```bash
# Add new modes:
MODES=(
    "apps|󰀻 Applications|wofi --show drun"
    "my-mode|󰚝 My Custom|my-custom-command"
)
```

### `calculator.sh`
**Path:** `~/.config/wofi/scripts/calculator.sh`

**Function:**
- Terminal-based calculator
- Supports basic mathematical operations
- Safe evaluation with bc

**Supported Operations:**
```bash
2 + 3          # Addition
15 * 4         # Multiplication
100 / 5        # Division
sqrt(16)       # Square root
(10 + 5) * 2   # Complex expressions
```

**Features:**
- Floating point support
- Error handling for invalid expressions
- Automatic formatting

### `emoji-picker.sh`
**Path:** `~/.config/wofi/scripts/emoji-picker.sh`

**Function:**
- Searchable emoji database
- Automatic copy-to-clipboard
- Categorized emojis

**Included Emojis:**
- 😀 Faces & emotions
- 👍 Hands & gestures
- 🐱 Animals & nature
- 🍎 Food & drink
- ⚽ Activities & sports
- 🚗 Transport & vehicles
- 💡 Objects
- 🏳️‍🌈 Symbols & flags

**Features:**
- Fuzzy search
- Automatic clipboard
- Success notification

### `run-script.sh`
**Path:** `~/.config/wofi/scripts/run-script.sh`

**Function:**
- Execution of custom scripts
- Automatic script detection
- Integrated standard scripts

**Standard Scripts:**
```bash
screenshot.sh    # Screenshot tool
sysinfo.sh       # System information
network.sh       # Network status
bluetooth.sh     # Bluetooth devices
```

**Customization:**
```bash
# Add new scripts:
# Create ~/.config/hypr/scripts/my-script.sh
# Script will be automatically detected and displayed
```

### `docs-launcher.sh`
**Path:** `~/.config/wofi/scripts/docs-launcher.sh`

**Function:**
- Launcher for integrated documentation
- Categorized help system
- Searchable documentation

**Documentation Categories:**
```bash
shortcuts.md        # Keybindings
troubleshooting.md  # Troubleshooting
features.md         # Features overview
installation.md     # Installation
customization.md    # Customizations
scripts.md          # Script documentation
```

## Fun Scripts

### `matrix-rain.sh`
**Path:** `~/.config/scripts/matrix-rain.sh`

**Function:**
- Terminal-based matrix animation
- Nord theming for colors
- Hardware-accelerated effects

**Features:**
- Random matrix characters
- Fade effects (bright → dark → blue)
- Adjustable speed
- Terminal size adaptation

**Controls:**
- `CTRL+C` to exit
- Automatic terminal detection

### `easter-eggs.sh`
**Path:** `~/.config/scripts/easter-eggs.sh`

**Function:**
- Random surprises
- ASCII art and fun messages
- Motivational quotes

**Modes:**
```bash
easter-eggs.sh           # Random selection
easter-eggs.sh message   # Text messages only
easter-eggs.sh ascii     # ASCII art only
easter-eggs.sh both      # Text + ASCII
easter-eggs.sh matrix    # Starts matrix rain
```

### `fun-sounds.sh`
**Path:** `~/.config/scripts/fun-sounds.sh`

**Function:**
- Audio feedback for various actions
- Beep sounds for success/error
- Motivational sounds

**Available Sounds:**
```bash
success     # Success sound
error       # Error sound
levelup     # Level-up melody
matrix      # Matrix sound effect
celebrate   # Celebration sound
startup     # Greeting sound
test        # Test all sounds
```

**Audio Support:**
- **sox/play:** Full audio support
- **alsa/aplay:** Basic beep sounds
- **Fallback:** Terminal bell

## Dunst Scripts

### `brightness.sh`
**Path:** `~/.config/dunst/scripts/brightness.sh`

**Function:**
- Brightness-change notifications
- Shows current brightness
- Progress bar integration

### `volume.sh`
**Path:** `~/.config/dunst/scripts/volume.sh`

**Function:**
- Volume-change notifications
- Mute status display
- Automatic icon selection

### `screenshot.sh`
**Path:** `~/.config/dunst/scripts/screenshot.sh`

**Function:**
- Screenshot confirmations
- Action buttons (Open/Edit)
- Different screenshot types

### `music.sh`
**Path:** `~/.config/dunst/scripts/music.sh`

**Function:**
- Spotify integration
- Playback control
- Track information

### `network.sh`
**Path:** `~/.config/dunst/scripts/network.sh`

**Function:**
- Network status notifications
- Connection information
- Troubleshooting actions

## Kitty Scripts

### `switch-theme.sh`
**Path:** `~/.config/kitty/switch-theme.sh`

**Function:**
- Theme switcher for Kitty
- Supports Nord and Dracula
- Automatic configuration update

**Available Themes:**
```bash
nord      # Standard Nord theme
dracula   # Dracula theme
# Extensible through new theme.conf files
```

## Script Development

### Script Structure

```bash
#!/bin/bash
# Script header with description

# Nord colors for consistency
NORD8='\033[38;2;136;192,208m'
NORD14='\033[38;2;163;190,140m'
RESET='\033[0m'

# Functions
main() {
    # Main logic
}

# Parameter processing
case "$1" in
    "option1")
        # Action for option 1
        ;;
    "option2")
        # Action for option 2
        ;;
    *)
        # Default action or help
        echo "Usage: $0 [option1|option2]"
        ;;
esac

# Execute script
main "$@"
```

### Best Practices

1. **Error handling:**
   ```bash
   set -e  # Stop script on errors
   trap 'echo "Error in line $LINENO"' ERR
   ```

2. **Parameter validation:**
   ```bash
   if [ $# -eq 0 ]; then
       echo "Error: Parameter required"
       exit 1
   fi
   ```

3. **Nord consistency:**
   ```bash
   # Use defined color variables
   echo -e "${NORD14}Success!${RESET}"
   ```

4. **Make executable:**
   ```bash
   chmod +x script.sh
   ```

## Script Customization

### Add Custom Scripts

1. **Create script:**
   ```bash
   # ~/.config/hypr/scripts/my-script.sh
   #!/bin/bash
   echo "My custom script"
   ```

2. **Make executable:**
   ```bash
   chmod +x ~/.config/hypr/scripts/my-script.sh
   ```

3. **Integrate into launcher:**
   ```bash
   # Will be automatically detected in run-script.sh
   # Or manually add to modes.sh
   ```

### Extend Waybar Modules

```bash
# New custom module
"custom/my-module": {
    "format": "󰚝 {}",
    "exec": "~/.config/waybar/scripts/my-script.sh",
    "interval": 30,
    "return-type": "json"
}
```

---

**Script Reference: `$mainMod + H` → Scripts**

**Development: All scripts are in `~/.config/` and can be freely customized!**
