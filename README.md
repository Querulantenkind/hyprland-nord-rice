# Hyprland Nord Rice + AGS Glass UI

An elegant Hyprland setup in [Nord Theme](https://www.nordtheme.com/) with **AGS Glass UI** overlays - minimalist, functional, and jaw-dropping aesthetic.

![Nord Theme](https://www.nordtheme.com/images/ports/visual-studio-code/editor-ui-jsx.png)

## Nord Color Palette

| Polar Night | Snow Storm | Frost | Aurora |
|-------------|------------|-------|--------|
| ![#2e3440](https://via.placeholder.com/15/2e3440/2e3440.png) `#2e3440` | ![#d8dee9](https://via.placeholder.com/15/d8dee9/d8dee9.png) `#d8dee9` | ![#8fbcbb](https://via.placeholder.com/15/8fbcbb/8fbcbb.png) `#8fbcbb` | ![#bf616a](https://via.placeholder.com/15/bf616a/bf616a.png) `#bf616a` |
| ![#3b4252](https://via.placeholder.com/15/3b4252/3b4252.png) `#3b4252` | ![#e5e9f0](https://via.placeholder.com/15/e5e9f0/e5e9f0.png) `#e5e9f0` | ![#88c0d0](https://via.placeholder.com/15/88c0d0/88c0d0.png) `#88c0d0` | ![#d08770](https://via.placeholder.com/15/d08770/d08770.png) `#d08770` |
| ![#434c5e](https://via.placeholder.com/15/434c5e/434c5e.png) `#434c5e` | ![#eceff4](https://via.placeholder.com/15/eceff4/eceff4.png) `#eceff4` | ![#81a1c1](https://via.placeholder.com/15/81a1c1/81a1c1.png) `#81a1c1` | ![#ebcb8b](https://via.placeholder.com/15/ebcb8b/ebcb8b.png) `#ebcb8b` |
| ![#4c566a](https://via.placeholder.com/15/4c566a/4c566a.png) `#4c566a` | | ![#5e81ac](https://via.placeholder.com/15/5e81ac/5e81ac.png) `#5e81ac` | ![#a3be8c](https://via.placeholder.com/15/a3be8c/a3be8c.png) `#a3be8c` |

## Included Configurations

- **Hyprland** - Wayland compositor with animations and blur
- **AGS Glass UI** - Nord/Ice Glass overlays (OSD, Quick Settings, Power Menu, Overview, Mini Dashboard)
- **Waybar** - Status bar with workspaces, clock, battery, network, audio
- **Wofi** - Application launcher in Nord style
- **Hyprpaper** - Wallpaper manager
- **Hyprlock** - Lockscreen in Nord design

## Features

- Complete Nord color scheme
- Blur effects and transparency
- Smooth animations
- **AGS Glass UI Overlays** - jaw-dropping Nord/Ice Glass effects
- **Quick Settings** - Live Audio/Brightness/Network controls
- **Mini Dashboard** - Compact Quick-Access panel with essential controls
- **OSD Notifications** - Frosted Glass popups for media keys
- **Power Menu** - Elegant system menu
- **Workspace Overview** - Visual workspace management
- Multi-monitor support
- German keyboard configuration
- Integrated screenshot tools
- Clipboard history (cliphist)
- Elegant lockscreen

## Installation

### Automatic (Recommended)

```bash
git clone https://github.com/your-username/hyprland-rice.git
cd hyprland-rice
chmod +x install.sh
./install.sh
```

### Manual

1. Install required packages (Arch Linux):

```bash
sudo pacman -S hyprland waybar wofi kitty thunar firefox dunst grim slurp wl-clipboard brightnessctl pavucontrol polkit-gnome gjs gtk3 libnotify sassc wireplumber playerctl bluez bluez-utils

# AUR (with yay)
yay -S hyprpaper hyprlock wlogout cliphist ttf-jetbrains-mono-nerd ags
```

2. Copy configuration files:

```bash
cp -r config/hypr ~/.config/
cp -r config/waybar ~/.config/
cp -r config/wofi ~/.config/
```

3. Add a Nord wallpaper:

```bash
mkdir -p ~/.config/hypr/wallpapers
# Copy your wallpaper to ~/.config/hypr/wallpapers/nord-mountains.jpg
```

## Keybindings

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
| `SUPER + CTRL + Space` | **AGS Quick Settings** |
| `SUPER + CTRL + D` | **AGS Mini Dashboard** |
| `SUPER + CTRL + P` | **AGS Power Menu** |
| `SUPER + CTRL + O` | **AGS Overview** |
| `Power Button (Right Click)` | **Mini Dashboard** |
| `Print` | Screenshot (select area) |
| `SHIFT + Print` | Screenshot (full screen) |

## Structure

```
hyprland-rice/
├── config/
│   ├── ags/
│   │   ├── main.ts          # AGS Entry Point
│   │   ├── style.scss       # Nord/Ice Glass Theme
│   │   ├── widgets/         # Modular UI Components
│   │   └── windows/         # LayerShell Windows
│   ├── hypr/
│   │   ├── hyprland.conf    # Main configuration
│   │   ├── hyprpaper.conf   # Wallpaper config
│   │   └── hyprlock.conf    # Lockscreen config
│   ├── waybar/
│   │   ├── config           # Waybar modules
│   │   └── style.css        # Waybar styling
│   └── wofi/
│       ├── config           # Wofi settings
│       └── style.css        # Wofi styling
├── install.sh               # Installation script
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

## License

MIT License - Free to use and modify.

## Credits

- [Nord Theme](https://www.nordtheme.com/) - The beautiful color palette
- [Hyprland](https://hyprland.org/) - The fantastic Wayland compositor
- Community for inspiration and support

---

**Enjoy your Nord Rice!**
