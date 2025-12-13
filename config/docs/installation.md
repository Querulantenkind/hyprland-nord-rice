# 🚀 Hyprland Nord Rice - Installation

## Übersicht

Schritt-für-Schritt Anleitung zur Installation des Hyprland Nord Rice Setups. Automatische und manuelle Installationsoptionen verfügbar.

## 🔍 Systemvoraussetzungen

### Hardware-Anforderungen
- **GPU:** Vulkan-kompatible Grafikkarte (NVIDIA, AMD, Intel)
- **RAM:** Mindestens 4GB (8GB empfohlen)
- **Speicher:** 10GB freier Festplattenspeicher

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

## 📦 Automatische Installation (Empfohlen)

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
Das Script wird:
- ✅ Paketmanager erkennen (pacman/apt/dnf/zypper)
- ✅ Abhängigkeiten automatisch installieren
- ✅ Bestehende Konfiguration sichern
- ✅ Neue Konfiguration installieren
- ✅ Wallpaper herunterladen
- ✅ GTK-Theme optional installieren

### 4. Post-Installation
Nach der Installation:
1. **Ausloggen** vom aktuellen Session
2. **Hyprland** als Session auswählen
3. **Einloggen** und Setup genießen

## 🔧 Manuelle Installation

### Schritt 1: Basis-Pakete installieren
```bash
# Hyprland Ecosystem
sudo pacman -S hyprland waybar wofi kitty

# Audio & Multimedia
sudo pacman -S pipewire pipewire-pulse pavucontrol

# System Tools
sudo pacman -S thunar firefox dunst grim slurp wl-clipboard
sudo pacman -S brightnessctl network-manager-applet polkit-gnome

# Utilities
sudo pacman -S btop jq curl wget imagemagick
```

### Schritt 2: AUR-Pakete installieren
```bash
# Mit yay
yay -S hyprpaper hyprlock hypridle wlogout cliphist
yay -S ttf-jetbrains-mono-nerd
yay -S xdg-desktop-portal-hyprland
```

### Schritt 3: Konfiguration installieren
```bash
# Repository klonen
git clone https://github.com/your-username/hyprland-nord-rice.git
cd hyprland-nord-rice

# Backup erstellen
mkdir -p ~/.config/backup
cp -r ~/.config/hypr ~/.config/backup/ 2>/dev/null || true
cp -r ~/.config/waybar ~/.config/backup/ 2>/dev/null || true
cp -r ~/.config/wofi ~/.config/backup/ 2>/dev/null || true

# Konfiguration kopieren
cp -r config/hypr ~/.config/
cp -r config/waybar ~/.config/
cp -r config/wofi ~/.config/
cp -r config/kitty ~/.config/
cp -r config/dunst ~/.config/
cp -r config/btop ~/.config/
cp -r config/wlogout ~/.config/
cp -r config/hypridle ~/.config/
cp -r config/scripts ~/.config/
cp -r config/docs ~/.config/
```

### Schritt 4: Wallpaper einrichten
```bash
# Verzeichnis erstellen
mkdir -p ~/.config/hypr/wallpapers
mkdir -p ~/Pictures/Screenshots

# Wallpaper herunterladen
curl -L "https://raw.githubusercontent.com/nordtheme/assets/main/wallpapers/nord-visual-studio-code-editor-0.1.0.png" \
     -o ~/.config/hypr/wallpapers/nord-mountains.jpg
```

### Schritt 5: Berechtigungen setzen
```bash
# Scripts ausführbar machen
chmod +x ~/.config/waybar/scripts/*.sh
chmod +x ~/.config/wofi/scripts/*.sh
chmod +x ~/.config/scripts/*.sh
chmod +x ~/.config/kitty/switch-theme.sh
```

### Schritt 6: Services aktivieren
```bash
# Bluetooth (optional)
sudo systemctl enable bluetooth

# NetworkManager
sudo systemctl enable NetworkManager

# Polkit Agent
# Wird automatisch über exec-once gestartet
```

## 🎨 Optionale Ergänzungen

### GTK Theme (Nordic)
```bash
# AUR Theme installieren
yay -S nordic-theme

# GTK-Konfiguration
echo 'gtk-theme-name=Nordic' >> ~/.config/gtk-3.0/settings.ini
echo 'gtk-icon-theme-name=Papirus-Dark' >> ~/.config/gtk-3.0/settings.ini
```

### Cursor Theme (Nordzy)
```bash
# Cursor Theme installieren
yay -S nordzy-cursors

# Hyprland Konfiguration anpassen
echo 'env = XCURSOR_THEME,Nordzy-cursors' >> ~/.config/hypr/hyprland.conf
echo 'env = XCURSOR_SIZE,24' >> ~/.config/hypr/hyprland.conf
```

### Icon Theme (Papirus Nord)
```bash
# Icon Pack installieren
yay -S papirus-icon-theme

# GTK-Konfiguration aktualisieren
sed -i 's/gtk-icon-theme-name=.*/gtk-icon-theme-name=Papirus-Dark/' ~/.config/gtk-3.0/settings.ini
```

### Zsh & Starship (Erweiterte Shell)
```bash
# Zsh installieren
sudo pacman -S zsh zsh-completions

# Starship installieren
curl -sS https://starship.rs/install.sh | sh

# Konfiguration
echo 'export ZSH=$HOME/.oh-my-zsh' >> ~/.zshrc
echo 'ZSH_THEME="robbyrussell"' >> ~/.zshrc
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
```

## 🔧 Konfiguration anpassen

### Monitor-Setup
```bash
# In ~/.config/hypr/hyprland.conf bearbeiten:
# Einzelner Monitor
monitor=,preferred,auto,1

# Dual-Monitor Beispiel
monitor=DP-1,2560x1440@144,0x0,1
monitor=HDMI-A-1,1920x1080@60,2560x0,1
```

### Tastaturlayout ändern
```bash
# In ~/.config/hypr/hyprland.conf:
input {
    kb_layout = de  # de, us, fr, etc.
    kb_variant =    # nodeadkeys, etc.
}
```

### Waybar-Module anpassen
```bash
# In ~/.config/waybar/config bearbeiten:
# Module hinzufügen/entfernen nach Bedarf
# Temperatur-Sensor anpassen für dein System
```

## 🧪 Installation testen

### 1. Konfiguration validieren
```bash
hyprland --verify-config
```

### 2. Einzelne Komponenten testen
```bash
# Waybar testen
waybar

# Wofi testen
wofi --show drun

# Kitty testen
kitty

# Dunst testen
notify-send "Test" "Dunst funktioniert!"
```

### 3. Vollständigen Start testen
```bash
# Temporäre Session starten (in neuem TTY: Ctrl+Alt+F2)
Hyprland
```

## 🔄 Updates & Maintenance

### System aktualisieren
```bash
# Mit dem eingebauten Update-Script
$mainMod + U  # Oder manuell:
~/.config/waybar/scripts/update-system.sh
```

### Konfiguration aktualisieren
```bash
cd ~/hyprland-nord-rice
git pull
./install.sh  # Überschreibt Konfiguration
```

## 🆘 Fehlerbehebung

### Hyprland startet nicht
```bash
# Logs prüfen
journalctl -b | grep hyprland

# Minimal-Konfiguration testen
hyprctl version
```

### Waybar funktioniert nicht
```bash
# Dependencies prüfen
pacman -Q waybar jq

# Manuell starten
killall waybar; waybar &
```

### Wofi zeigt keine Apps
```bash
# Desktop-Dateien aktualisieren
update-desktop-database
```

## 📞 Support

Bei Problemen:
1. **Dokumentation:** `$mainMod + H` → Troubleshooting
2. **Logs prüfen:** `journalctl -b`
3. **Community:** Hyprland Discord oder GitHub Issues

---

**Viel Spaß mit deinem neuen Nord Rice! ❄️🚀**

Für detaillierte Hilfe: `$mainMod + H` → Troubleshooting
