# Hyprland Nord Rice - Troubleshooting Guide

## Overview

Common problems and their solutions in the Hyprland Nord Rice setup. If a problem is not solved here, check the logs and search the Hyprland documentation.

## Hyprland doesn't start

### Problem: Black screen when starting

**Symptoms:**
- Hyprland doesn't start
- Black screen
- Back to login manager

**Solutions:**

1. **Check GPU drivers:**
   ```bash
   # NVIDIA
   pacman -Q | grep nvidia

   # AMD
   pacman -Q | grep mesa

   # Intel
   pacman -Q | grep intel
   ```

2. **Validate configuration:**
   ```bash
   hyprland --verify-config
   ```

3. **Check logs:**
   ```bash
   journalctl -b | grep hyprland
   ```

4. **Test fallback configuration:**
   ```bash
   cp ~/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf.backup
   hyprland --config /usr/share/hyprland/hyprland.conf
   ```

### Problem: Poor performance

**Symptoms:**
- Jerky animations
- High CPU usage
- Delayed inputs

**Solutions:**

1. **Enable V-Sync:**
   ```bash
   # Add to ~/.config/hypr/hyprland.conf:
   misc {
       vfr = true
   }
   ```

2. **Reduce animation speed:**
   ```bash
   # Change in ~/.config/hypr/hyprland.conf:
   animation = windows, 0, 1, default  # Disables window animations
   ```

3. **Check hardware acceleration:**
   ```bash
   glxinfo | grep renderer
   ```

## Waybar doesn't start

### Problem: Waybar doesn't appear in the bar

**Symptoms:**
- No status bar visible
- Waybar process not running

**Solutions:**

1. **Start Waybar manually:**
   ```bash
   killall waybar
   waybar &
   ```

2. **Check configuration:**
   ```bash
   # Check for syntax errors
   cat ~/.config/waybar/config | jq . >/dev/null 2>&1
   echo $?
   ```

3. **Install dependencies:**
   ```bash
   # Arch Linux
   sudo pacman -S waybar jq

   # Module-specific dependencies
   sudo pacman -S pulseaudio-utils brightnessctl network-manager-applet
   ```

4. **Check logs:**
   ```bash
   waybar 2>&1 | tee waybar.log
   ```

### Problem: Waybar modules show wrong values

**Symptoms:**
- CPU/RAM display shows 0%
- Network status wrong
- Battery not detected

**Solutions:**

1. **Check permissions:**
   ```bash
   # For brightness
   groups | grep video

   # If not: sudo usermod -aG video $USER
   ```

2. **Install tools:**
   ```bash
   sudo pacman -S sysstat lm_sensors
   ```

3. **Check module configuration:**
   ```bash
   # Test CPU module
   top -bn1 | grep "Cpu(s)"

   # Test RAM module
   free -h
   ```

## No blur effects

### Problem: Windows have no transparencies/blur

**Symptoms:**
- No blurred backgrounds
- No transparencies
- Sharp edges

**Solutions:**

1. **Check GPU support:**
   ```bash
   glxinfo | grep "OpenGL version"
   ```

2. **Check Hyprland configuration:**
   ```bash
   # blur in decoration should be enabled
   grep -A 10 "decoration {" ~/.config/hypr/hyprland.conf
   ```

3. **Check shader support:**
   ```bash
   # If blur doesn't work, disable advanced options:
   blur {
       enabled = true
       size = 3
       passes = 1
       new_optimizations = false  # Set to false
   }
   ```

## Wofi doesn't work

### Problem: Wofi doesn't start or shows nothing

**Symptoms:**
- Wofi window doesn't open
- Empty list
- Crash

**Solutions:**

1. **Update applications list:**
   ```bash
   # Update desktop files
   update-desktop-database
   ```

2. **Check configuration:**
   ```bash
   # Test Wofi configuration
   wofi --show drun --width 400 --height 200
   ```

3. **Check GTK themes:**
   ```bash
   # Set GTK theme
   export GTK_THEME=Nordic
   ```

## Wallpaper not displayed

### Problem: Hyprpaper shows no wallpaper

**Symptoms:**
- Black background
- Wallpaper file exists but is not displayed

**Solutions:**

1. **Check hyprpaper:**
   ```bash
   # Check status
   pgrep hyprpaper

   # If not running:
   hyprpaper &
   ```

2. **Check configuration:**
   ```bash
   cat ~/.config/hypr/hyprpaper.conf
   ```

3. **Correct wallpaper path:**
   ```bash
   # Make sure path is correct
   ls -la ~/.config/hypr/wallpapers/
   ```

4. **Enable IPC:**
   ```bash
   # In hyprpaper.conf:
   ipc = on
   ```

## Hyprlock doesn't work

### Problem: Screen locking fails

**Symptoms:**
- Lock screen doesn't appear
- System remains unlocked

**Solutions:**

1. **Install hyprlock:**
   ```bash
   sudo pacman -S hyprlock
   ```

2. **Check configuration:**
   ```bash
   cat ~/.config/hypr/hyprlock.conf
   ```

3. **Check PAM configuration:**
   ```bash
   # PAM file should exist
   ls -la /etc/pam.d/hyprlock
   ```

## Audio doesn't work

### Problem: No sound or microphone

**Symptoms:**
- No audio output
- Microphone not detected
- PulseAudio errors

**Solutions:**

1. **Check audio server:**
   ```bash
   # PipeWire/PulseAudio status
   pactl info
   ```

2. **List audio devices:**
   ```bash
   pactl list sinks
   pactl list sources
   ```

3. **Check Waybar modules:**
   ```bash
   # Test PulseAudio module
   wpctl get-volume @DEFAULT_AUDIO_SINK@
   ```

## Network doesn't work

### Problem: No internet connection

**Symptoms:**
- Waybar shows "Offline"
- No internet access

**Solutions:**

1. **Check NetworkManager:**
   ```bash
   systemctl status NetworkManager
   ```

2. **List connections:**
   ```bash
   nmcli device status
   nmcli connection show
   ```

3. **Scan WLAN connections:**
   ```bash
   nmcli device wifi list
   ```

## Battery not detected

### Problem: Battery status not available

**Symptoms:**
- Waybar shows no battery
- Laptop battery not detected

**Solutions:**

1. **Check battery status:**
   ```bash
   ls -la /sys/class/power_supply/
   cat /sys/class/power_supply/BAT*/capacity
   ```

2. **Install UPower:**
   ```bash
   sudo pacman -S upower
   ```

3. **Check Waybar configuration:**
   ```bash
   # Battery module should be configured correctly
   grep -A 10 "battery {" ~/.config/waybar/config
   ```

## Touchpad doesn't work

### Problem: Touchpad gestures or clicks not available

**Symptoms:**
- No touchpad gestures
- Clicks not detected

**Solutions:**

1. **Check touchpad drivers:**
   ```bash
   pacman -Q | grep xf86-input-libinput
   ```

2. **Check libinput configuration:**
   ```bash
   cat ~/.config/hypr/hyprland.conf | grep -A 10 "touchpad"
   ```

3. **Gesture configuration:**
   ```bash
   # In hyprland.conf touchpad block should be enabled
   touchpad {
       natural_scroll = true
       tap-to-click = true
       drag_lock = true
   }
   ```

## Logs and Debug Information

### Important log files:

```bash
# Hyprland logs
journalctl -b | grep hyprland

# Waybar logs
waybar 2>&1 | tee waybar-debug.log

# System logs
journalctl -b -p err
```

### Debug commands:

```bash
# Hardware info
lspci -v
lsusb

# GPU info
glxinfo | head -20

# System info
uname -a
cat /etc/os-release
```

## Advanced Help

If these solutions don't help:

1. **Hyprland Discord:** https://discord.gg/hyprland
2. **Arch Wiki:** https://wiki.archlinux.org/title/Hyprland
3. **GitHub Issues:** Search for similar problems
4. **Forum:** https://bbs.archlinux.org/

## Emergency Recovery

### Skip Hyprland:

1. At login: Select session → "Hyprland (Debug)"
2. Or temporarily select other session (e.g. XFCE)

### Reset configuration:

```bash
# Create backup
cp ~/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf.backup

# Minimal configuration
cat > ~/.config/hypr/hyprland.conf << EOF
# Minimal Hyprland config
monitor=,preferred,auto,1

bind = SUPER, Return, exec, kitty
bind = SUPER, Q, killactive
bind = SUPER SHIFT, E, exit

exec-once = waybar
EOF
```

---

**For more help: `$mainMod + H` → Troubleshooting**
