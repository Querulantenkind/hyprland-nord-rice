# Hyprland Nord Rice - Installation

## Übersicht

Schritt-für-Schritt Anleitung zur Installation des Hyprland Nord Rice Setups - Visual Masterpiece Edition. Automatische und manuelle Installationsoptionen verfügbar.

## Systemvoraussetzungen

### Hardware-Anforderungen
- **GPU:** Vulkan-kompatible Grafikkarte (NVIDIA, AMD, Intel)
- **RAM:** Mindestens 4GB (8GB empfohlen)
- **Speicher:** 10GB freier Festplattenspeicher
- **Audio:** PipeWire oder PulseAudio für Audio-Visualizer

### Software-Voraussetzungen
- **Arch Linux** (oder kompatible Distribution)
- **AUR-Helper** (yay, paru) für automatische Installation
- **Git** für Repository-Klonen

### Erforderliche Pakete (vorab)
```bash
# Basis-Tools
sudo pacman -S git base-devel

# AUR-Helper installieren (falls nicht vorhanden)
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
```

## Automatische Installation (Empfohlen)

### 1. Repository klonen
```bash
git clone https://github.com/your-username/hyprland-nord-rice.git
cd hyprland-nord-rice
```

### 2. Ausführbar machen und starten
```bash
chmod +x install.sh
./install.sh
```

### 3. Installation verfolgen
Das Script wird automatisch:
- Paketmanager erkennen (pacman/apt/dnf/zypper)
- AUR-Helper (yay) installieren falls nicht vorhanden
- Alle Abhängigkeiten installieren (inkl. AGS, cava)
- Bestehende Konfiguration sichern
- Neue Konfiguration mit visuellen Effekten installieren
- Scripts ausführbar machen
- Services aktivieren (Bluetooth, NetworkManager)
- Cava FIFO für Audio-Visualizer erstellen
- Optional: GTK-Theme installieren

### 4. Post-Installation
Nach der Installation:
1. **Ausloggen** vom aktuellen Session
2. **Hyprland** als Session auswählen
3. **Einloggen** und Setup genießen

## Manuelle Installation

### Schritt 1: Basis-Pakete installieren
```bash
# Hyprland Ecosystem
sudo pacman -S hyprland waybar wofi kitty

# Audio & Multimedia
sudo pacman -S pipewire pipewire-pulse pavucontrol playerctl

# System Tools
sudo pacman -S thunar firefox dunst grim slurp wl-clipboard
sudo pacman -S brightnessctl network-manager-applet polkit-gnome

# Utilities (wichtig für Visual Effects)
sudo pacman -S btop jq bc curl wget zsh

# Bluetooth
sudo pacman -S bluez bluez-utils

# AGS Dependencies
sudo pacman -S gjs gtk3 libnotify sassc wireplumber
```

### Schritt 2: AUR-Pakete installieren
```bash
# Mit yay
yay -S hyprpaper hyprlock hypridle wlogout cliphist
yay -S ttf-jetbrains-mono-nerd qt5ct
yay -S xdg-desktop-portal-hyprland

# AGS (Aylur's GTK Shell)
yay -S aylurs-gtk-shell

# Audio Visualizer
yay -S cava
```

### Schritt 3: Konfiguration installieren
```bash
# Repository klonen
git clone https://github.com/your-username/hyprland-nord-rice.git
cd hyprland-nord-rice

# Backup erstellen
BACKUP_DIR="$HOME/.config/hyprland-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r ~/.config/hypr "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.config/waybar "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.config/wofi "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.config/ags "$BACKUP_DIR/" 2>/dev/null || true

# Konfiguration kopieren
cp -r config/hypr ~/.config/
cp -r config/waybar ~/.config/
cp -r config/wofi ~/.config/
cp -r config/kitty ~/.config/
cp -r config/dunst ~/.config/
cp -r config/btop ~/.config/
cp -r config/wlogout ~/.config/
cp -r config/hypridle ~/.config/
cp -r config/ags ~/.config/
cp -r config/cava ~/.config/
cp -r config/scripts ~/.config/
cp -r config/docs ~/.config/
```

### Schritt 4: Scripts ausführbar machen
```bash
# Alle Scripts ausführbar machen
chmod +x ~/.config/scripts/*.sh
chmod +x ~/.config/waybar/scripts/*.sh
chmod +x ~/.config/wofi/scripts/*.sh
chmod +x ~/.config/dunst/scripts/*.sh
chmod +x ~/.config/kitty/switch-theme.sh
```

### Schritt 5: Cava FIFO erstellen
```bash
# FIFO für Audio-Visualizer erstellen
mkfifo /tmp/cava.fifo
```

### Schritt 6: Services aktivieren
```bash
# Bluetooth
sudo systemctl enable bluetooth

# NetworkManager
sudo systemctl enable NetworkManager
```

## Installierte Features

### Core Components
- **Hyprland** - Wayland Compositor mit Blur und Animationen
- **Waybar** - Status-Bar mit Workspaces, Clock, System-Monitoring
- **Wofi** - Application Launcher
- **Kitty** - Terminal Emulator
- **Dunst** - Notification Daemon

### AGS Glass UI
- **Quick Settings** - Audio/Brightness/Network Controls
- **Mini Dashboard** - Compact Quick-Access Panel
- **Fullscreen Dashboard** - GNOME/macOS Style Overview
- **Power Menu** - Elegant System Menu
- **Notification Center** - Grouped Notifications
- **Workspace Preview** - Animated Workspace Overview
- **Ice Pill Bar** - Floating Window Indicator

### Visual Effects
- **Audio Visualizer** - Cava-basierte Musik-Visualisierung
- **Dynamic Borders** - Anwendungsspezifische Border-Farben
- **Particle Effects** - Schneeflocken, Aurora, Sterne
- **Screen Glow** - Ambient Glow basierend auf aktiver App
- **Window Shake** - Visuelles Feedback für Fehler/Warnungen

## Optionale Ergänzungen

### GTK Theme (Nordic)
```bash
yay -S nordic-theme

# GTK-Konfiguration
mkdir -p ~/.config/gtk-3.0
echo '[Settings]' > ~/.config/gtk-3.0/settings.ini
echo 'gtk-theme-name=Nordic' >> ~/.config/gtk-3.0/settings.ini
echo 'gtk-icon-theme-name=Papirus-Dark' >> ~/.config/gtk-3.0/settings.ini
```

### Cursor Theme (Nordzy)
```bash
yay -S nordzy-cursors
```

### Icon Theme (Papirus)
```bash
yay -S papirus-icon-theme
```

## Deinstallation

```bash
chmod +x uninstall.sh
./uninstall.sh
```

Das Uninstall-Script wird:
- Laufende Prozesse stoppen
- Konfigurationsdateien entfernen
- Backup-Wiederherstellung anbieten
- Optional Pakete entfernen
- Cache bereinigen

## Tastenkombinationen

### Basis-Steuerung
| Taste | Aktion |
|-------|--------|
| `SUPER + Return` | Terminal |
| `SUPER + Space` | App Launcher |
| `SUPER + Q` | Fenster schließen |
| `SUPER + 1-0` | Workspace wechseln |

### AGS Glass UI
| Taste | Aktion |
|-------|--------|
| `SUPER + CTRL + Space` | Quick Settings |
| `SUPER + CTRL + D` | Mini Dashboard |
| `SUPER + CTRL + N` | Notification Center |
| `SUPER + CTRL + W` | Workspace Preview |
| `SUPER + A` | Fullscreen Dashboard |

### Visual Effects
| Taste | Aktion |
|-------|--------|
| `SUPER + CTRL + V` | Audio Visualizer Toggle |
| `SUPER + CTRL + X` | Dynamic Borders Toggle |
| `SUPER + CTRL + G` | Screen Glow Toggle |
| `SUPER + CTRL + S` | Snow Particles |
| `SUPER + CTRL + A` | Aurora Particles |
| `SUPER + CTRL + R` | Random Particles |

## Fehlerbehebung

### AGS startet nicht
```bash
# AGS neu installieren
yay -S aylurs-gtk-shell

# Logs prüfen
ags --help
```

### Audio Visualizer funktioniert nicht
```bash
# Cava installieren
yay -S cava

# FIFO erstellen
mkfifo /tmp/cava.fifo

# Cava manuell starten
cava -p ~/.config/cava/config &
```

### Particle Effects funktionieren nicht
```bash
# bc und jq installieren
sudo pacman -S bc jq
```

### Dynamic Borders funktionieren nicht
```bash
# jq installieren
sudo pacman -S jq

# Script manuell ausführen
~/.config/scripts/dynamic-borders.sh start
```

## Updates

### Konfiguration aktualisieren
```bash
cd ~/hyprland-nord-rice
git pull
./install.sh
```

### System aktualisieren
```bash
# Über Waybar-Button oder:
~/.config/waybar/scripts/update-system.sh
```

## Support

Bei Problemen:
1. **Dokumentation:** `SUPER + H` -> Troubleshooting
2. **Logs prüfen:** `journalctl -b`
3. **Community:** Hyprland Discord oder GitHub Issues

---

**Viel Spaß mit deinem Nord Rice - A Visual Masterpiece!**