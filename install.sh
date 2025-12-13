#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║               HYPRLAND NORD RICE - INSTALL SCRIPT                         ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Nord Colors for output
NORD0='\033[38;2;46;52;64m'
NORD4='\033[38;2;216;222;233m'
NORD8='\033[38;2;136;192;208m'
NORD11='\033[38;2;191;97;106m'
NORD14='\033[38;2;163;190;140m'
RESET='\033[0m'

# Symbols
CHECK="${NORD14}✓${RESET}"
CROSS="${NORD11}✗${RESET}"
ARROW="${NORD8}→${RESET}"
INFO="${NORD8}ℹ${RESET}"

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"

echo -e ""
    echo -e "${NORD8}╔═══════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${NORD8}║${RESET}     ${NORD4}HYPRLAND NORD RICE + AGS GLASS UI INSTALLER${RESET}                ${NORD8}║${RESET}"
    echo -e "${NORD8}╚═══════════════════════════════════════════════════════════════════╝${RESET}"
echo -e ""

# ══════════════════════════════════════════════════════════════════════════════
# HELPER FUNCTIONS
# ══════════════════════════════════════════════════════════════════════════════

print_status() {
    echo -e "${ARROW} $1"
}

print_success() {
    echo -e "${CHECK} $1"
}

print_error() {
    echo -e "${CROSS} $1"
}

print_info() {
    echo -e "${INFO} $1"
}

command_exists() {
    command -v "$1" &> /dev/null
}

# ══════════════════════════════════════════════════════════════════════════════
# DETECT PACKAGE MANAGER
# ══════════════════════════════════════════════════════════════════════════════

detect_package_manager() {
    if command_exists pacman; then
        PKG_MANAGER="pacman"
        PKG_INSTALL="sudo pacman -S --noconfirm --needed"
        AUR_HELPER=""
        if command_exists yay; then
            AUR_HELPER="yay"
            AUR_INSTALL="yay -S --noconfirm --needed"
        elif command_exists paru; then
            AUR_HELPER="paru"
            AUR_INSTALL="paru -S --noconfirm --needed"
        fi
    elif command_exists apt; then
        PKG_MANAGER="apt"
        PKG_INSTALL="sudo apt install -y"
    elif command_exists dnf; then
        PKG_MANAGER="dnf"
        PKG_INSTALL="sudo dnf install -y"
    elif command_exists zypper; then
        PKG_MANAGER="zypper"
        PKG_INSTALL="sudo zypper install -y"
    else
        print_error "Kein unterstützter Paketmanager gefunden!"
        exit 1
    fi
    print_success "Paketmanager erkannt: $PKG_MANAGER"
}

# ══════════════════════════════════════════════════════════════════════════════
# INSTALL PACKAGES
# ══════════════════════════════════════════════════════════════════════════════

install_packages() {
    print_status "Installiere benötigte Pakete..."
    
    # Base packages (available in most distros)
    BASE_PACKAGES=(
        "hyprland"
        "waybar"
        "wofi"
        "kitty"
        "zsh"
        "btop"
        "thunar"
        "firefox"
        "dunst"
        "grim"
        "slurp"
        "wl-clipboard"
        "brightnessctl"
        "pavucontrol"
        "network-manager-applet"
        "polkit-gnome"
    )
    
    # Arch-specific packages
    ARCH_PACKAGES=(
        "hyprpaper"
        "hyprlock"
        "hypridle"
        "wlogout"
        "cliphist"
        "ttf-jetbrains-mono-nerd"
        "qt5ct"
        "xdg-desktop-portal-hyprland"
        # AGS Glass UI dependencies
        "ags"
        "gjs"
        "gtk3"
        "libnotify"
        "sassc"
        "wireplumber"
        "playerctl"
        "bluez"
        "bluez-utils"
    )
    
    case $PKG_MANAGER in
        pacman)
            print_info "Installiere Basis-Pakete..."
            $PKG_INSTALL ${BASE_PACKAGES[@]} 2>/dev/null
            
            if [ -n "$AUR_HELPER" ]; then
                print_info "Installiere AUR-Pakete mit $AUR_HELPER..."
                $AUR_INSTALL ${ARCH_PACKAGES[@]} 2>/dev/null
            else
                print_info "Kein AUR-Helper gefunden. Installiere manuelle Pakete..."
                $PKG_INSTALL ${ARCH_PACKAGES[@]} 2>/dev/null
            fi
            ;;
        apt)
            print_info "Installiere Pakete für Debian/Ubuntu..."
            $PKG_INSTALL ${BASE_PACKAGES[@]} 2>/dev/null
            print_info "Hinweis: Einige Pakete müssen manuell installiert werden (hyprpaper, hyprlock, etc.)"
            ;;
        dnf)
            print_info "Installiere Pakete für Fedora..."
            $PKG_INSTALL ${BASE_PACKAGES[@]} 2>/dev/null
            print_info "Hinweis: Einige Pakete müssen manuell installiert werden"
            ;;
        zypper)
            print_info "Installiere Pakete für openSUSE..."
            $PKG_INSTALL ${BASE_PACKAGES[@]} 2>/dev/null
            print_info "Hinweis: Einige Pakete müssen manuell installiert werden"
            ;;
    esac
    
    print_success "Paketinstallation abgeschlossen!"
}

# ══════════════════════════════════════════════════════════════════════════════
# BACKUP EXISTING CONFIG
# ══════════════════════════════════════════════════════════════════════════════

backup_config() {
    print_status "Erstelle Backup der bestehenden Konfiguration..."
    
    BACKUP_DIR="$HOME/.config/hyprland-backup-$(date +%Y%m%d_%H%M%S)"
    
    if [ -d "$HOME/.config/hypr" ] || [ -d "$HOME/.config/waybar" ] || [ -d "$HOME/.config/wofi" ]; then
        mkdir -p "$BACKUP_DIR"
        
        [ -d "$HOME/.config/hypr" ] && cp -r "$HOME/.config/hypr" "$BACKUP_DIR/"
        [ -d "$HOME/.config/waybar" ] && cp -r "$HOME/.config/waybar" "$BACKUP_DIR/"
        [ -d "$HOME/.config/wofi" ] && cp -r "$HOME/.config/wofi" "$BACKUP_DIR/"
        
        print_success "Backup erstellt in: $BACKUP_DIR"
    else
        print_info "Keine bestehende Konfiguration gefunden."
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
# INSTALL CONFIG
# ══════════════════════════════════════════════════════════════════════════════

install_config() {
    print_status "Installiere Konfigurationsdateien..."
    
    # Create directories
    mkdir -p "$HOME/.config/hypr/wallpapers"
    mkdir -p "$HOME/.config/waybar"
    mkdir -p "$HOME/.config/wofi"
    mkdir -p "$HOME/Pictures/Screenshots"
    
    # Copy configs
    if [ -d "$CONFIG_DIR/hypr" ]; then
        cp -r "$CONFIG_DIR/hypr/"* "$HOME/.config/hypr/"
        print_success "Hyprland-Konfiguration installiert"
    fi
    
    if [ -d "$CONFIG_DIR/waybar" ]; then
        cp -r "$CONFIG_DIR/waybar/"* "$HOME/.config/waybar/"
        print_success "Waybar-Konfiguration installiert"
    fi
    
    if [ -d "$CONFIG_DIR/wofi" ]; then
        cp -r "$CONFIG_DIR/wofi/"* "$HOME/.config/wofi/"
        print_success "Wofi-Konfiguration installiert"
    fi

    if [ -d "$CONFIG_DIR/dunst" ]; then
        cp -r "$CONFIG_DIR/dunst/"* "$HOME/.config/dunst/"
        print_success "Dunst-Konfiguration installiert"
    fi

    if [ -d "$CONFIG_DIR/wlogout" ]; then
        cp -r "$CONFIG_DIR/wlogout/"* "$HOME/.config/wlogout/"
        print_success "Wlogout-Konfiguration installiert"
    fi

    if [ -d "$CONFIG_DIR/hypridle" ]; then
        cp -r "$CONFIG_DIR/hypridle/"* "$HOME/.config/hypridle/"
        print_success "Hypridle-Konfiguration installiert"
    fi

    if [ -d "$CONFIG_DIR/kitty" ]; then
        cp -r "$CONFIG_DIR/kitty/"* "$HOME/.config/kitty/"
        print_success "Kitty-Konfiguration installiert"
    fi

    if [ -d "$CONFIG_DIR/btop" ]; then
        cp -r "$CONFIG_DIR/btop/"* "$HOME/.config/btop/"
        print_success "Btop-Konfiguration installiert"
    fi

    if [ -d "$CONFIG_DIR/scripts" ]; then
        mkdir -p "$HOME/.config/scripts"
        cp -r "$CONFIG_DIR/scripts/"* "$HOME/.config/scripts/"
        print_success "Bonus-Scripts installiert"
    fi

    if [ -d "$CONFIG_DIR/ags" ]; then
        mkdir -p "$HOME/.config/ags"
        cp -r "$CONFIG_DIR/ags/"* "$HOME/.config/ags/"
        print_success "AGS Glass UI installiert"
    fi

    if [ -d "$CONFIG_DIR/docs" ]; then
        mkdir -p "$HOME/.config/docs"
        cp -r "$CONFIG_DIR/docs/"* "$HOME/.config/docs/"
        print_success "Dokumentation installiert"
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
# DOWNLOAD WALLPAPER
# ══════════════════════════════════════════════════════════════════════════════

download_wallpaper() {
    print_status "Lade Nord-Wallpaper herunter..."
    
    WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
    mkdir -p "$WALLPAPER_DIR"
    
    # Nord-themed wallpaper URL (using a commonly available nord wallpaper)
    WALLPAPER_URL="https://raw.githubusercontent.com/nordtheme/assets/main/wallpapers/nord-visual-studio-code-editor-0.1.0.png"
    
    if command_exists curl; then
        curl -sL "$WALLPAPER_URL" -o "$WALLPAPER_DIR/nord-mountains.jpg" 2>/dev/null || {
            print_info "Wallpaper konnte nicht heruntergeladen werden."
            print_info "Bitte manuell ein Wallpaper nach $WALLPAPER_DIR/nord-mountains.jpg kopieren."
        }
    elif command_exists wget; then
        wget -q "$WALLPAPER_URL" -O "$WALLPAPER_DIR/nord-mountains.jpg" 2>/dev/null || {
            print_info "Wallpaper konnte nicht heruntergeladen werden."
            print_info "Bitte manuell ein Wallpaper nach $WALLPAPER_DIR/nord-mountains.jpg kopieren."
        }
    else
        print_info "Weder curl noch wget gefunden. Bitte Wallpaper manuell herunterladen."
    fi
    
    if [ -f "$WALLPAPER_DIR/nord-mountains.jpg" ]; then
        print_success "Wallpaper heruntergeladen"
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
# INSTALL GTK THEME (OPTIONAL)
# ══════════════════════════════════════════════════════════════════════════════

install_gtk_theme() {
    print_status "Möchtest du das Nordic GTK-Theme installieren? (y/n)"
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        case $PKG_MANAGER in
            pacman)
                if [ -n "$AUR_HELPER" ]; then
                    $AUR_INSTALL nordic-theme 2>/dev/null
                    print_success "Nordic GTK-Theme installiert"
                fi
                ;;
            *)
                print_info "Bitte installiere das Nordic-Theme manuell von:"
                print_info "https://github.com/EliverLara/Nordic"
                ;;
        esac
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
# POST INSTALL
# ══════════════════════════════════════════════════════════════════════════════

post_install() {
    echo -e ""
    echo -e "${NORD8}╔═══════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${NORD8}║${RESET}                  ${NORD14}INSTALLATION ABGESCHLOSSEN!${RESET}                     ${NORD8}║${RESET}"
    echo -e "${NORD8}╚═══════════════════════════════════════════════════════════════════╝${RESET}"
    echo -e ""
    echo -e "${NORD4}Wichtige Tastenkombinationen:${RESET}"
    echo -e ""
    echo -e "  ${NORD8}SUPER + Return${RESET}     → Terminal (Kitty)"
    echo -e "  ${NORD8}SUPER + Space${RESET}      → App-Launcher (Wofi)"
    echo -e "  ${NORD8}SUPER + Q${RESET}          → Fenster schließen"
    echo -e "  ${NORD8}SUPER + F${RESET}          → Vollbild"
    echo -e "  ${NORD8}SUPER + E${RESET}          → Dateimanager"
    echo -e "  ${NORD8}SUPER + B${RESET}          → Browser"
    echo -e "  ${NORD8}SUPER + 1-0${RESET}        → Workspace wechseln"
    echo -e "  ${NORD8}SUPER + SHIFT + Q${RESET}  → Hyprland beenden"
    echo -e "  ${NORD8}Print${RESET}              → Screenshot (Bereich)"
    echo -e ""
    echo -e "  ${NORD8}SUPER + CTRL + Space${RESET} → AGS Quick Settings"
    echo -e "  ${NORD8}SUPER + CTRL + P${RESET}     → AGS Power Menu"
    echo -e "  ${NORD8}SUPER + CTRL + O${RESET}     → AGS Overview"
    echo -e ""
    echo -e "${NORD4}Nächste Schritte:${RESET}"
    echo -e ""
    echo -e "  1. Logge dich aus und wähle Hyprland als Session"
    echo -e "  2. Passe die Konfiguration in ~/.config/hypr/ an"
    echo -e "  3. Füge ein Nord-Wallpaper hinzu: ~/.config/hypr/wallpapers/"
    echo -e ""
    echo -e "${NORD8}Viel Spaß mit deinem neuen Nord-Rice! ❄${RESET}"
    echo -e ""
}

# ══════════════════════════════════════════════════════════════════════════════
# MAIN
# ══════════════════════════════════════════════════════════════════════════════

main() {
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        print_error "Bitte nicht als root ausführen!"
        exit 1
    fi
    
    echo -e "${NORD4}Dieses Script wird folgendes tun:${RESET}"
    echo -e "  ${ARROW} Benötigte Pakete installieren (inkl. AGS Glass UI)"
    echo -e "  ${ARROW} Bestehende Config sichern"
    echo -e "  ${ARROW} Nord-Rice + AGS Glass UI Config installieren"
    echo -e "  ${ARROW} Wallpaper herunterladen"
    echo -e ""
    echo -e "${NORD4}Fortfahren? (y/n)${RESET}"
    read -r response
    
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_info "Installation abgebrochen."
        exit 0
    fi
    
    echo -e ""
    
    detect_package_manager
    install_packages
    backup_config
    install_config
    download_wallpaper
    install_gtk_theme
    post_install
}

# Run main function
main "$@"
