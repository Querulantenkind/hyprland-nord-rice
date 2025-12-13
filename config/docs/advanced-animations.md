# Advanced Animations - Liquid/Goo Effects & Magnetic Snapping

This document describes the advanced animation system implemented for the Hyprland rice setup, featuring liquid/goo-like window animations, magnetic snapping effects, workspace morph transitions, and elastic window resizing.

## Features Overview

### 1. Liquid/Goo Animation für Windows
- **Elastic window opening/closing** with bounce effects
- **Ripple effects** on window focus/unfocus
- **Melting animations** for window close operations
- **Goo-like stretching** effects during resize operations

### 2. Magnetic Window Effects beim Snapping
- **Automatic edge attraction** when windows approach screen borders
- **Smooth magnetic snapping** to corners and edges
- **Elastic overshoot** with settle animation
- **Configurable magnetic distance** for attraction threshold

### 3. Window-Morph-Transitions zwischen Workspaces
- **Smooth morphing animations** when switching workspaces
- **Size scaling effects** during transition
- **Elastic bounce-back** when arriving at destination workspace
- **Alternative workspace switching** with enhanced visuals

### 4. Elastic Window Resize
- **Overshoot and settle** physics for resize operations
- **Elastic grow/shrink** with bounce effects
- **Smooth animation curves** for natural feel
- **Configurable elasticity factors**

## Configuration

### Animation Curves
The system uses advanced Bezier curves for smooth animations:

```hyprlang
# Elastic bounce for window opening/closing
bezier = elastic, 0.68, -0.55, 0.265, 1.55
# Magnetic snap curve for edge snapping
bezier = magnetic, 0.34, 1.56, 0.64, 1
# Smooth liquid flow for window movements
bezier = liquid, 0.25, 0.46, 0.45, 0.94
# Elastic overshoot for resize operations
bezier = elasticOvershoot, 0.175, 0.885, 0.32, 1.275
# Morph transition for workspace changes
bezier = morph, 0.4, 0, 0.2, 1
# Gentle settle for final positions
bezier = settle, 0.25, 0.1, 0.25, 1
```

### Configuration File
Advanced settings are stored in `~/.config/hypr/advanced-animations.conf`:

```bash
# Main settings
ENABLED=true
LIQUID_ENABLED=true
MAGNETIC_ENABLED=true
ELASTIC_RESIZE_ENABLED=true
MORPH_TRANSITIONS_ENABLED=true

# Animation parameters
MAGNETIC_DISTANCE=30
ELASTIC_FACTOR=1.15
ANIMATION_SPEED=1.0
GOO_INTENSITY=0.8
```

## Keybindings

### Basic Magnetic Snapping
- `SUPER + ALT + H/L/K/J` - Magnetic snap to left/right/top/bottom
- `SUPER + ALT + C` - Center window with magnetic attraction

### Elastic Resize
- `SUPER + ALT + SHIFT + H/L` - Elastic grow/shrink resize
- `SUPER + CTRL + ALT + +/-` - Advanced elastic resize

### Workspace Morph Transitions
- `SUPER + ALT + [1-9/0]` - Morph to workspace with animation
- `SUPER + CTRL + ALT + [1-5]` - Alternative morph transitions

### Liquid/Goo Effects
- `SUPER + CTRL + ALT + B` - Bounce effect on current window
- `SUPER + CTRL + ALT + M` - Melt effect
- `SUPER + CTRL + ALT + S` - Stretch effect

### System Controls
- `SUPER + CTRL + ALT + T` - Toggle advanced animations on/off
- `SUPER + CTRL + ALT + F/U/O` - Focus/unfocus/open effects

## Scripts

### `magnetic-snap.sh`
Handles basic magnetic snapping and goo effects:

```bash
# Usage examples
./magnetic-snap.sh snap left          # Snap to left edge
./magnetic-snap.sh elastic-resize grow # Elastic resize
./magnetic-snap.sh workspace-morph 2  # Morph to workspace 2
./magnetic-snap.sh goo bounce         # Apply bounce effect
```

### `advanced-animations.sh`
Advanced animation system with physics-based effects:

```bash
# Configuration management
./advanced-animations.sh load         # Load configuration
./advanced-animations.sh save         # Save configuration
./advanced-animations.sh toggle       # Toggle animations

# Effects
./advanced-animations.sh liquid <window_id> <effect>
./advanced-animations.sh magnetic <direction> <window_id>
./advanced-animations.sh elastic <direction>
./advanced-animations.sh morph <workspace>
```

## Technical Implementation

### Animation System Architecture
1. **Hyprland Animation Engine** - Uses native Hyprland animation system with custom Bezier curves
2. **Shell Scripts** - Handle complex animation sequences and physics
3. **Event System** - Monitors window events for automatic effects
4. **Configuration System** - Runtime configuration management

### Physics Simulation
- **Spring physics** for elastic effects
- **Magnetic attraction** with distance-based force calculation
- **Damping and overshoot** for realistic motion
- **Morphing algorithms** for smooth transitions

### Performance Considerations
- **Efficient calculations** using shell arithmetic
- **Minimal system calls** for smooth performance
- **Configurable intensity** to balance effects vs. performance
- **Background processing** for non-blocking animations

## Customization

### Adjusting Animation Intensity
Modify the configuration file to change animation behavior:

```bash
# Increase magnetic attraction distance
./advanced-animations.sh set MAGNETIC_DISTANCE 50

# Make elastic effects more pronounced
./advanced-animations.sh set ELASTIC_FACTOR 1.3

# Adjust animation speed
./advanced-animations.sh set ANIMATION_SPEED 1.2
```

### Disabling Specific Effects
```bash
# Disable liquid effects
./advanced-animations.sh set LIQUID_ENABLED false

# Disable magnetic snapping
./advanced-animations.sh set MAGNETIC_ENABLED false

# Disable workspace morphing
./advanced-animations.sh set MORPH_TRANSITIONS_ENABLED false
```

## Troubleshooting

### Animations Not Working
1. Check if scripts are executable: `chmod +x ~/.config/scripts/*.sh`
2. Verify configuration is loaded: `~/.config/scripts/advanced-animations.sh load`
3. Check Hyprland logs for errors: `hyprctl reload`

### Performance Issues
1. Reduce animation intensity: `~/.config/scripts/advanced-animations.sh set GOO_INTENSITY 0.5`
2. Disable specific effects if needed
3. Check system resources during animations

### Configuration Issues
1. Reset configuration: `rm ~/.config/hypr/advanced-animations.conf && ~/.config/scripts/advanced-animations.sh save`
2. Reload Hyprland: `hyprctl reload`

## Future Enhancements

- **Plugin-based architecture** for better performance
- **GPU-accelerated effects** using shaders
- **Custom animation curves** per window type
- **Physics-based collision** detection between windows
- **Advanced morphing** with shape interpolation
