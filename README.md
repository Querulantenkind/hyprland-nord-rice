# Hyprland Nord Rice + AGS Glass UI

An elegant Hyprland setup in [Nord Theme](https://www.nordtheme.com/) with **AGS Glass UI** overlays - a visual masterpiece with stunning animations, particle effects, and ambient features.

![Nord Theme](https://www.nordtheme.com/images/ports/visual-studio-code/editor-ui-jsx.png)

## Nord Color Palette

| Polar Night | Snow Storm | Frost | Aurora |
|-------------|------------|-------|--------|
| ![#2e3440](https://via.placeholder.com/15/2e3440/2e3440.png) `#2e3440` | ![#d8dee9](https://via.placeholder.com/15/d8dee9/d8dee9.png) `#d8dee9` | ![#8fbcbb](https://via.placeholder.com/15/8fbcbb/8fbcbb.png) `#8fbcbb` | ![#bf616a](https://via.placeholder.com/15/bf616a/bf616a.png) `#bf616a` |
| ![#3b4252](https://via.placeholder.com/15/3b4252/3b4252.png) `#3b4252` | ![#e5e9f0](https://via.placeholder.com/15/e5e9f0/e5e9f0.png) `#e5e9f0` | ![#88c0d0](https://via.placeholder.com/15/88c0d0/88c0d0.png) `#88c0d0` | ![#d08770](https://via.placeholder.com/15/d08770/d08770.png) `#d08770` |
| ![#434c5e](https://via.placeholder.com/15/434c5e/434c5e.png) `#434c5e` | ![#eceff4](https://via.placeholder.com/15/eceff4/eceff4.png) `#eceff4` | ![#81a1c1](https://via.placeholder.com/15/81a1c1/81a1c1.png) `#81a1c1` | ![#ebcb8b](https://via.placeholder.com/15/ebcb8b/ebcb8b.png) `#ebcb8b` |
| ![#4c566a](https://via.placeholder.com/15/4c566a/4c566a.png) `#4c566a` | | ![#5e81ac](https://via.placeholder.com/15/5e81ac/5e81ac.png) `#5e81ac` | ![#a3be8c](https://via.placeholder.com/15/a3be8c/a3be8c.png) `#a3be8c` |

## Included Configurations

- **Hyprland** - Wayland compositor with animations, blur, and dynamic borders
- **AGS Glass UI** - Nord/Ice Glass overlays (OSD, Quick Settings, Power Menu, Overview, Dashboard, Notification Center)
- **Waybar** - Status bar with workspaces, clock, battery, network, audio, audio visualizer
- **Wofi** - Application launcher in Nord style
- **Hyprpaper** - Wallpaper manager
- **Hyprlock** - Lockscreen in Nord design
- **Hypridle** - Idle manager
- **Dunst** - Notification daemon
- **Kitty** - Terminal emulator
- **Btop** - System monitor
- **Cava** - Audio visualizer

## Features

### Core Features
- Complete Nord color scheme across all components
- Blur effects and transparency (Glass-Morphism)
- Smooth animations with custom Bezier curves
- Multi-monitor support
- German keyboard configuration (easily changeable)
- Integrated screenshot tools
- Clipboard history (cliphist)

### AGS Glass UI Overlays
- **Quick Settings** - Live Audio/Brightness/Network controls
- **Mini Dashboard** - Compact Quick-Access panel
- **Fullscreen Dashboard** - GNOME/macOS inspired overview
- **OSD Notifications** - Frosted Glass popups for media keys
- **Power Menu** - Elegant system menu
- **Workspace Overview** - Visual workspace management with previews
- **Notification Center** - Grouped notifications with actions
- **Ice Pill Window Indicator** - Floating window title bar

### Visual Effects
- **Audio Visualizer** - Cava-based music visualization in status bar
- **Dynamic Borders** - Application-specific border colors with Aurora palette
- **Workspace Indicator** - Animated workspace previews with window thumbnails
- **Particle Effects** - Snowflakes, Aurora, Stars, Success bursts
- **Screen-Edge Glow** - Ambient glow based on active application
- **Window Shake** - Visual feedback for errors/warnings with border flash

### Hyprbars Integration
- Floating ice-block title bars
- Nord/Frost themed buttons
- Minimal and elegant design

## Installation

### Automatic (Recommended)

```bash
git clone https://github.com/your-username/hyprland-rice.git
cd hyprland-rice
chmod +x install.sh
./install.sh
```

The install script will automatically:
- Detect your package manager (pacman/apt/dnf/zypper)
- Install all required dependencies
- Backup existing configurations
- Install the Nord Rice configuration
- Download Nord wallpapers
- Optionally install Nordic GTK theme

### Manual

1. Install required packages (Arch Linux):

```bash
# Base packages
sudo pacman -S hyprland waybar wofi kitty thunar firefox dunst grim slurp wl-clipboard brightnessctl pavucontrol polkit-gnome network-manager-applet zsh btop jq bc

# AUR packages (with yay)
yay -S hyprpaper hyprlock hypridle wlogout cliphist ttf-jetbrains-mono-nerd qt5ct xdg-desktop-portal-hyprland ags gjs gtk3 libnotify sassc wireplumber playerctl bluez bluez-utils cava
```

2. Copy configuration files:

```bash
cp -r config/hypr ~/.config/
cp -r config/waybar ~/.config/
cp -r config/wofi ~/.config/
cp -r config/ags ~/.config/
cp -r config/dunst ~/.config/
cp -r config/kitty ~/.config/
cp -r config/btop ~/.config/
cp -r config/scripts ~/.config/
cp -r config/cava ~/.config/
```

3. Make scripts executable:

```bash
chmod +x ~/.config/scripts/*.sh
chmod +x ~/.config/waybar/scripts/*.sh
chmod +x ~/.config/wofi/scripts/*.sh
```

## Uninstallation

```bash
chmod +x uninstall.sh
./uninstall.sh
```

The uninstall script will:
- Remove all installed configurations
- Optionally restore backed-up configurations
- Optionally remove installed packages

## Keybindings

### Basic Controls
| Key | Action |
|-----|--------|
| `SUPER + Return` | Terminal (Kitty) |
| `SUPER + Space` | App Launcher (Wofi) |
| `SUPER + Q` | Close window |
| `SUPER + F` | Fullscreen |
| `SUPER + SHIFT + F` | Floating toggle |
| `SUPER + E` | File manager (Thunar) |
| `SUPER + B` | Browser (Firefox) |
| `SUPER + V` | Clipboard history |
| `SUPER + 1-0` | Switch workspace |
| `SUPER + SHIFT + 1-0` | Move window to workspace |
| `SUPER + Arrow keys` | Switch focus |
| `SUPER + SHIFT + Arrow keys` | Move window |
| `SUPER + CTRL + Arrow keys` | Resize window |
| `SUPER + S` | Scratchpad (Special workspace) |
| `SUPER + Escape` | Lock screen |
| `Print` | Screenshot (select area) |
| `SHIFT + Print` | Screenshot (full screen) |

### AGS Glass UI Controls
| Key | Action |
|-----|--------|
| `SUPER + CTRL + Space` | Quick Settings |
| `SUPER + CTRL + D` | Mini Dashboard |
| `SUPER + CTRL + P` | Power Menu |
| `SUPER + CTRL + O` | Overview |
| `SUPER + CTRL + B` | Toggle AGS Bar |
| `SUPER + CTRL + W` | Workspace Preview |
| `SUPER + CTRL + N` | Notification Center |
| `SUPER + A` | Fullscreen Dashboard |

### Visual Effects Controls
| Key | Action |
|-----|--------|
| `SUPER + CTRL + V` | Toggle Audio Visualizer |
| `SUPER + CTRL + X` | Toggle Dynamic Borders |
| `SUPER + CTRL + G` | Toggle Screen Glow |
| `SUPER + CTRL + S` | Snow Particle Effect |
| `SUPER + CTRL + A` | Aurora Particle Effect |
| `SUPER + CTRL + T` | Stars Particle Effect |
| `SUPER + CTRL + U` | Success Particle Burst |
| `SUPER + CTRL + R` | Random Particle Effect |
| `SUPER + CTRL + E` | Error Window Shake |
| `SUPER + CTRL + I` | Info Window Shake |

## Structure

```
hyprland-rice/
├── config/
│   ├── ags/
│   │   ├── main.ts              # AGS Entry Point
│   │   ├── style.scss           # Nord/Ice Glass Theme
│   │   ├── services/            # System services (audio, network, etc.)
│   │   ├── widgets/             # Modular UI Components
│   │   │   ├── audio-visualizer.js
│   │   │   ├── notification.js
│   │   │   ├── window.js
│   │   │   ├── workspace-indicator.js
│   │   │   └── ...
│   │   └── windows/             # LayerShell Windows
│   │       ├── bar.js
│   │       ├── dashboard.js
│   │       ├── notification-center.js
│   │       ├── workspace-preview.js
│   │       └── ...
│   ├── btop/
│   │   └── btop.conf            # Btop configuration
│   ├── cava/
│   │   └── config               # Cava audio visualizer config
│   ├── dunst/
│   │   └── dunstrc              # Notification styling
│   ├── hypr/
│   │   ├── hyprland.conf        # Main configuration
│   │   ├── hyprpaper.conf       # Wallpaper config
│   │   ├── hyprlock.conf        # Lockscreen config
│   │   └── wallpapers/          # Nord wallpapers
│   ├── hypridle/
│   │   └── config.toml          # Idle manager config
│   ├── kitty/
│   │   └── kitty.conf           # Terminal config
│   ├── scripts/
│   │   ├── dynamic-borders.sh   # Dynamic border colors
│   │   ├── particle-effects.sh  # Particle animations
│   │   ├── screen-glow.sh       # Ambient glow effects
│   │   ├── window-shake.sh      # Window shake animations
│   │   └── ...
│   ├── waybar/
│   │   ├── config               # Waybar modules
│   │   ├── style.css            # Waybar styling
│   │   └── scripts/
│   │       ├── audio-visualizer.sh
│   │       └── ...
│   ├── wlogout/
│   │   └── config               # Logout menu config
│   └── wofi/
│       ├── config               # Wofi settings
│       └── style.css            # Wofi styling
├── install.sh                   # Installation script
├── uninstall.sh                 # Uninstallation script
└── README.md
```

## Customization

### Change Wallpaper

Edit `~/.config/hypr/hyprpaper.conf`:

```bash
preload = ~/.config/hypr/wallpapers/your-wallpaper.jpg
wallpaper = ,~/.config/hypr/wallpapers/your-wallpaper.jpg
```

### Monitor Setup

Edit `~/.config/hypr/hyprland.conf`:

```bash
# Single monitor
monitor=,preferred,auto,1

# Dual monitor example
monitor=DP-1,2560x1440@144,0x0,1
monitor=HDMI-A-1,1920x1080@60,2560x0,1
```

### Change Keyboard Layout

```bash
input {
    kb_layout = de  # Change to your layout (us, de, etc.)
}
```

### Configure Dynamic Borders

Edit the color mappings in `~/.config/scripts/dynamic-borders.sh`:

```bash
# Add custom application colors
["your-app"]="rgb($NORD15) rgb($NORD14) 45deg"
```

### Configure Particle Effects

```bash
# Customize particle duration and intensity
~/.config/scripts/particle-effects.sh snow 20      # 20 second snow
~/.config/scripts/particle-effects.sh aurora 15   # 15 second aurora
```

## Recommended Additions

- [Nordic GTK Theme](https://github.com/EliverLara/Nordic)
- [Nordzy Cursor](https://github.com/alvatip/Nordzy-cursors)
- [Papirus Nord Icons](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)

## Troubleshooting

### Waybar doesn't start
```bash
killall waybar
waybar &
```

### No blur effects
Make sure your GPU supports Vulkan and the drivers are installed.

### Wallpaper not displayed
Check if `hyprpaper` is running and the wallpaper path is correct.

### AGS not working
Make sure AGS is installed from AUR:
```bash
yay -S aylurs-gtk-shell
```

### Audio visualizer not showing
Install cava and create the FIFO:
```bash
yay -S cava
mkfifo /tmp/cava.fifo
cava -p ~/.config/cava/config &
```

### Particle effects not working
Ensure `bc` and `jq` are installed:
```bash
sudo pacman -S bc jq
```

## Dependencies

### Required Packages
- hyprland, waybar, wofi, kitty, thunar, firefox
- dunst, grim, slurp, wl-clipboard, brightnessctl
- pavucontrol, polkit-gnome, network-manager-applet
- jq, bc (for scripts)

### AUR Packages (Arch Linux)
- hyprpaper, hyprlock, hypridle, wlogout
- cliphist, ttf-jetbrains-mono-nerd, qt5ct
- xdg-desktop-portal-hyprland
- aylurs-gtk-shell (AGS)
- cava (audio visualizer)
- gjs, gtk3, libnotify, sassc
- wireplumber, playerctl, bluez, bluez-utils

## License

MIT License - Free to use and modify.

## Credits

- [Nord Theme](https://www.nordtheme.com/) - The beautiful color palette
- [Hyprland](https://hyprland.org/) - The fantastic Wayland compositor
- [AGS](https://github.com/Aylur/ags) - Amazing GTK Shell for custom widgets
- [Cava](https://github.com/karlstav/cava) - Console-based Audio Visualizer
- Community for inspiration and support

---

**Enjoy your Nord Rice - A Visual Masterpiece!**