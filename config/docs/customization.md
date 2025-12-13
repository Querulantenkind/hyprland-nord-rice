# Hyprland Nord Rice - Customization & Configuration

## Overview

Guide to customizing the Hyprland Nord Rice setup. Learn how to adjust colors, themes, keybinds and more.

## Customize Nord Theme

### Change Color Palette

The Nord color palette is defined in multiple files. Change it centrally:

```bash
# In all relevant configuration files:
$nord0 = rgb(2e3440)   # Darkest background
$nord1 = rgb(3b4252)   # Dark background
$nord2 = rgb(434c5e)   # Selection background
$nord3 = rgb(4c566a)   # Comments, line numbers
$nord4 = rgb(d8dee9)   # Darkest foreground
$nord5 = rgb(e5e9f0)   # Light foreground
$nord6 = rgb(eceff4)   # Lightest foreground
$nord7 = rgb(8fbcbb)   # Cyan
$nord8 = rgb(88c0d0)   # Light cyan
$nord9 = rgb(81a1c1)   # Blue
$nord10 = rgb(5e81ac)  # Light blue
$nord11 = rgb(bf616a)  # Red
$nord12 = rgb(d08770)  # Orange
$nord13 = rgb(ebcb8b)  # Yellow
$nord14 = rgb(a3be8c)  # Green
$nord15 = rgb(b48ead)  # Magenta
```

### Different Nord Variants

#### Arctic Ice (Lighter Variant)
```bash
$nord0 = rgb(3b4252)   # Lighter background
$nord1 = rgb(434c5e)
$nord2 = rgb(4c566a)
$nord3 = rgb(616e88)
$nord4 = rgb(d8dee9)
$nord5 = rgb(e5e9f0)
$nord6 = rgb(eceff4)
# Rest remains the same
```

#### Polar Night (Darker Variant)
```bash
$nord0 = rgb(2e3440)   # Standard
$nord1 = rgb(2e3440)   # Same as nord0
$nord2 = rgb(3b4252)
$nord3 = rgb(434c5e)
# Rest remains the same
```

## Hyprland Configuration

### Customize Keybinds

```bash
# In ~/.config/hypr/hyprland.conf

# Change $mainMod (SUPER is standard)
$mainMod = ALT  # Alternative: ALT as mod key

# Change individual keybinds
bind = $mainMod, Q, killactive,  # Close window
bind = $mainMod, C, killactive,  # Alternative key for closing

# Add new keybinds
bind = $mainMod, F12, exec, flameshot gui  # Screenshot tool
bind = $mainMod SHIFT, F12, exec, grim - | wl-copy  # Quick screenshot
```

### Change Animation Speed

```bash
# In ~/.config/hypr/hyprland.conf

animations {
    enabled = true

    # Faster animations
    bezier = fast, 0.1, 0.1, 0.1, 1.0
    animation = windows, 1, 3, fast, slide

    # Slower animations
    bezier = slow, 0.5, 0.1, 0.5, 1.0
    animation = windows, 1, 8, slow, slide

    # No animations (performance)
    # enabled = false
}
```

### Adjust Blur Effects

```bash
# In ~/.config/hypr/hyprland.conf

decoration {
    blur {
        enabled = true
        size = 8        # Size of blur effect (2-15)
        passes = 2      # Number of passes (1-4)
        new_optimizations = true
        xray = true     # Blur through transparent windows
    }
}
```

### Change Window Gaps

```bash
# In ~/.config/hypr/hyprland.conf

general {
    gaps_in = 5       # Distance between windows
    gaps_out = 10     # Distance to screen edge

    # Dynamic gaps (changes with window count)
    gaps_in = 0       # No gaps with many windows
    gaps_out = 0
}
```

## Customize Waybar

### Add/Remove Modules

```bash
# In ~/.config/waybar/config

# Add new modules to bar
"modules-left": ["hyprland/workspaces", "hyprland/window", "cpu"],
"modules-center": ["clock", "weather"],
"modules-right": ["tray", "memory", "network", "battery", "custom/power"]

# Remove modules
"modules-right": ["network", "battery"]  # Remove tray and custom/power
```

### Configure CPU Module

```bash
# In ~/.config/waybar/config

"cpu": {
    "format": "󰻠 {usage}%",     # Change icon
    "format-alt": "{icon} {load}", # Alternative display
    "interval": 2,               # Update interval (seconds)
    "min-length": 5,             # Minimum width
    "max-length": 6              # Maximum width
}
```

### Setup Weather Module

```bash
# Configure weather API
# In ~/.config/waybar/scripts/weather.sh

# Change location
LOCATION="Berlin"  # City name
# or
LOCATION="52.52,13.41"  # Coordinates
# or
LOCATION="auto"  # Automatic detection
```

### Create Custom Module

```bash
# Create new script file
# ~/.config/waybar/scripts/my-custom.sh
#!/bin/bash

# Example: Shows random quote
QUOTES=(
    "Stay cool!"
    "To the moon!"
    "Aim high!"
)

RANDOM_INDEX=$((RANDOM % ${#QUOTES[@]}))
echo "{\"text\":\"${QUOTES[$RANDOM_INDEX]}\", \"tooltip\":\"Motivational Quote\"}"
```

```bash
# Add to ~/.config/waybar/config
"custom/quote": {
    "format": "{}",
    "return-type": "json",
    "interval": 3600,  # New quote every hour
    "exec": "~/.config/waybar/scripts/my-custom.sh"
}
```

## Customize Wofi

### Add New Modes

```bash
# In ~/.config/wofi/scripts/modes.sh

# Add new mode
MODES=(
    "apps|󰀻 Applications|wofi --show drun"
    "files|󰉋 Files|thunar"
    "browser|󰊯 Browser|firefox"
    # ... more modes
)
```

### Change Wofi Styling

```bash
# In ~/.config/wofi/style.css

# Change background color
window {
    background-color: rgba(30, 33, 40, 0.95);  # Darker background
}

# Change button hover
#entry:hover {
    background-color: rgba(136, 192, 208, 0.3);  # Lighter hover
}
```

## Kitty Terminal

### Switch Theme

```bash
# Available themes
~/.config/kitty/switch-theme.sh

# Or manually
# In ~/.config/kitty/kitty.conf
include themes/nord.conf   # Nord theme
include themes/dracula.conf # Dracula theme
```

### Create New Theme

```bash
# New theme file
# ~/.config/kitty/themes/my-theme.conf

background #1a1b26
foreground #c0caf5
cursor #c0caf5

color0 #15161e
color1 #f7768e
# ... more colors
```

### Change Font

```bash
# In ~/.config/kitty/kitty.conf

font_family      Fira Code Nerd Font
bold_font        Fira Code Nerd Font Bold
italic_font      Fira Code Nerd Font Italic
font_size 13
```

## Dunst Notifications

### Change Notification Styles

```bash
# In ~/.config/dunst/dunstrc

[urgency_normal]
    background = "#3b4252"
    foreground = "#d8dee9"
    timeout = 5  # Longer display time

[urgency_critical]
    background = "#bf616a"
    foreground = "#eceff4"
    timeout = 0  # Critical stay permanently
```

### Add New Notification Rules

```bash
# In ~/.config/dunst/dunstrc

# Rule for Spotify
[spotify]
    appname = spotify
    summary = "*"
    script = ~/.config/dunst/scripts/spotify.sh
    timeout = 3000

# Rule for system updates
[updates]
    appname = pacman
    summary = "System updated"
    script = ~/.config/dunst/scripts/system-update.sh
```

## Easter Eggs & Scripts

### Add New Sound Effects

```bash
# In ~/.config/scripts/fun-sounds.sh

# Add new sound
achievement_sound() {
    play_beep 523 0.1  # C5
    sleep 0.1
    play_beep 659 0.1  # E5
    sleep 0.1
    play_beep 784 0.2  # G5
    notify-send "Achievement!" "You did something awesome!"
}
```

### Create New Easter Eggs

```bash
# In ~/.config/scripts/easter-eggs.sh

# Add new ASCII art
ASCII_ART+=("
   .-~~~-.
  /       \\
 |  Hello  |
  \\       /
   '-~~~-'
")
```

### Add Custom Scripts

```bash
# Create new script
# ~/.config/scripts/my-script.sh

#!/bin/bash
# My custom script

notify-send "My Script" "Was executed!"
echo "Script executed successfully"
```

```bash
# Add to script menu
# ~/.config/wofi/scripts/run-script.sh will automatically find all .sh files
```

## System-wide Customizations

### Change GTK Themes

```bash
# GTK-3 configuration
# ~/.config/gtk-3.0/settings.ini

[Settings]
gtk-theme-name=Nordic
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=JetBrains Mono 10
gtk-cursor-theme-name=Nordzy-cursors
```

### Theme Qt Applications

```bash
# QT5 configuration
# ~/.config/qt5ct/qt5ct.conf

[Appearance]
color_scheme_path=/usr/share/qt5ct/colors/nord.conf
style=kvantum
```

### Change Cursor Size

```bash
# In ~/.config/hypr/hyprland.conf

env = XCURSOR_SIZE,24    # Larger cursor
env = XCURSOR_SIZE,16    # Smaller cursor
```

## File Manager (Thunar)

### Add Custom Actions

```bash
# Thunar Custom Actions
# Extend right-click menu

# Example: Open terminal here
Command: kitty --working-directory %f
Name: Open terminal here
Icon: terminal
```

### Install Thunar Plugins

```bash
# Additional plugins
sudo pacman -S thunar-archive-plugin  # Archive manager
sudo pacman -S thunar-media-tags-plugin  # Media tags
sudo pacman -S thunar-vcs-plugin  # VCS integration
```

## Gaming Optimization

### Setup Gamescope

```bash
# Gamescope for Steam-Proton
gamescope -w 1920 -h 1080 -f -- steam

# With MangoHud
mangohud gamescope -w 1920 -h 1080 -- steam
```

### Feral Gamemode

```bash
# Gamemode for better performance
sudo pacman -S gamemode

# In Steam launch options:
gamemoded %command%
```

## Security Improvements

### Adjust Automatic Locking

```bash
# In ~/.config/hypridle/config.toml

listener {
    timeout = 300    # 5 minutes until lock
    on-timeout = loginctl lock-session
}

listener {
    timeout = 600    # 10 minutes until suspend
    on-timeout = systemctl suspend
}
```

### Enable Firewall

```bash
# Install and configure UFW
sudo pacman -S ufw
sudo ufw enable

# GUI for firewall
sudo pacman -S gufw
```

## Extend Monitoring

### Additional Waybar Modules

```bash
# GPU temperature (for NVIDIA)
"custom/gpu": {
    "format": "󰒋 {}°C",
    "exec": "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits",
    "interval": 5
}
```

### Customize Btop Configuration

```bash
# In ~/.config/btop/btop.conf

# Show more CPU cores
cpu_bottom = cpu0,cpu1,cpu2,cpu3

# Temperature graphs
show_temp = true

# Network details
net_download = 100M
net_upload = 50M
```

## Network Configuration

### VPN Integration

```bash
# OpenVPN
sudo pacman -S openvpn networkmanager-openvpn

# WireGuard
sudo pacman -S wireguard-tools
```

### Network Profiles

```bash
# Save different network setups
# In ~/.config/hypr/hyprland.conf

# Office setup
bind = $mainMod CTRL, B, exec, ~/.config/scripts/network-office.sh

# Home setup
bind = $mainMod CTRL, H, exec, ~/.config/scripts/network-home.sh
```

## Backup System

### Automatic Backups

```bash
# Cron job for daily backups
# crontab -e

# Daily backup at 2 AM
0 2 * * * ~/.config/scripts/backup.sh
```

### Dotfile Management with GNU Stow

```bash
# Install stow
sudo pacman -S stow

# Organize dotfiles
mkdir ~/dotfiles
mv ~/.config/hypr ~/dotfiles/
cd ~/dotfiles
stow hypr  # Creates symlinks
```

## Performance Tuning

### System Optimizations

```bash
# Reduce swappiness
echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-swappiness.conf

# I/O scheduler
echo "mq-deadline" | sudo tee /sys/block/sda/queue/scheduler
```

### GPU-specific Optimizations

```bash
# NVIDIA
echo "options nvidia NVreg_UsePageAttributeTable=1" | sudo tee /etc/modprobe.d/nvidia.conf

# AMD
echo "options amdgpu dc=1" | sudo tee /etc/modprobe.d/amdgpu.conf
```

---

**For more help: `$mainMod + H` → Customization**
