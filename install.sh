#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║               HYPRLAND NORD RICE - INSTALL SCRIPT                         ║
# ║                   Visual Masterpiece Edition                               ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Nord Colors for output
NORD0='\033[38;2;46;52;64m'
NORD4='\033[38;2;216;222;233m'
NORD8='\033[38;2;136;192;208m'
NORD11='\033[38;2;191;97;106m'
NORD14='\033[38;2;163;190;140m'
NORD13='\033[38;2;235;203;139m'
RESET='\033[0m'

# Symbols
CHECK="${NORD14}[OK]${RESET}"
CROSS="${NORD11}[FAIL]${RESET}"
ARROW="${NORD8}>>>${RESET}"
INFO="${NORD8}[i]${RESET}"
WARN="${NORD13}[!]${RESET}"

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"

# Version
VERSION="2.0.0"

echo -e ""
echo -e "${NORD8}+===================================================================+${RESET}"
echo -e "${NORD8}|${RESET}     ${NORD4}HYPRLAND NORD RICE + AGS GLASS UI INSTALLER${RESET}                ${NORD8}|${RESET}"
echo -e "${NORD8}|${RESET}              ${NORD8}Visual Masterpiece Edition v${VERSION}${RESET}               ${NORD8}|${RESET}"
echo -e "${NORD8}+===================================================================+${RESET}"
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

print_warn() {
    echo -e "${WARN} $1"
}

command_exists() {
    command -v "$1" &> /dev/null
}

# ══════════════════════════════════════════════════════════════════════════════
# DETECT PACKAGE MANAGER
# ══════════════════════════════════════════════════════════════════════════════

detect_package_manager() {
    print_status "Detecting package manager..."

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
        print_error "No supported package manager found!"
        exit 1
    fi
    print_success "Package manager detected: $PKG_MANAGER"

    if [ -n "$AUR_HELPER" ]; then
        print_success "AUR helper detected: $AUR_HELPER"
    elif [ "$PKG_MANAGER" == "pacman" ]; then
        print_warn "No AUR helper found. Installing yay..."
        install_yay
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
# INSTALL YAY (AUR HELPER)
# ══════════════════════════════════════════════════════════════════════════════

install_yay() {
    print_status "Installing yay AUR helper..."

    if ! command_exists git; then
        sudo pacman -S --noconfirm git base-devel
    fi

    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR" || exit 1
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit 1
    makepkg -si --noconfirm
    cd "$SCRIPT_DIR" || exit 1
    rm -rf "$TEMP_DIR"

    if command_exists yay; then
        AUR_HELPER="yay"
        AUR_INSTALL="yay -S --noconfirm --needed"
        print_success "yay installed successfully"
    else
        print_error "Failed to install yay"
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
# INSTALL PACKAGES
# ══════════════════════════════════════════════════════════════════════════════

install_packages() {
    print_status "Installing required packages..."

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
        "jq"
        "bc"
        "curl"
        "wget"
    )

    # Arch-specific packages (official repos)
    ARCH_PACKAGES=(
        "qt5ct"
        "xdg-desktop-portal-hyprland"
        "gjs"
        "gtk3"
        "libnotify"
        "sassc"
        "wireplumber"
        "playerctl"
        "bluez"
        "bluez-utils"
    )

    # AUR packages
    AUR_PACKAGES=(
        "hyprpaper"
        "hyprlock"
        "hypridle"
        "wlogout"
        "cliphist"
        "ttf-jetbrains-mono-nerd"
        "aylurs-gtk-shell"
        "cava"
    )

    case $PKG_MANAGER in
        pacman)
            print_info "Installing base packages..."
            $PKG_INSTALL "${BASE_PACKAGES[@]}" 2>/dev/null || true

            print_info "Installing Arch-specific packages..."
            $PKG_INSTALL "${ARCH_PACKAGES[@]}" 2>/dev/null || true

            if [ -n "$AUR_HELPER" ]; then
                print_info "Installing AUR packages with $AUR_HELPER..."
                $AUR_INSTALL "${AUR_PACKAGES[@]}" 2>/dev/null || true
            else
                print_warn "No AUR helper available. Some packages need manual installation:"
                print_info "  - hyprpaper, hyprlock, hypridle, wlogout"
                print_info "  - cliphist, ttf-jetbrains-mono-nerd"
                print_info "  - aylurs-gtk-shell (AGS), cava"
            fi
            ;;
        apt)
            print_info "Installing packages for Debian/Ubuntu..."
            $PKG_INSTALL "${BASE_PACKAGES[@]}" 2>/dev/null || true
            print_warn "Some packages need manual installation on Debian/Ubuntu:"
            print_info "  - hyprpaper, hyprlock, hypridle, AGS, cava"
            print_info "  - Visit: https://github.com/Aylur/ags for AGS installation"
            ;;
        dnf)
            print_info "Installing packages for Fedora..."
            $PKG_INSTALL "${BASE_PACKAGES[@]}" 2>/dev/null || true
            print_warn "Some packages need manual installation on Fedora"
            ;;
        zypper)
            print_info "Installing packages for openSUSE..."
            $PKG_INSTALL "${BASE_PACKAGES[@]}" 2>/dev/null || true
            print_warn "Some packages need manual installation on openSUSE"
            ;;
    esac

    print_success "Package installation completed!"
}

# ══════════════════════════════════════════════════════════════════════════════
# BACKUP EXISTING CONFIG
# ══════════════════════════════════════════════════════════════════════════════

backup_config() {
    print_status "Creating backup of existing configuration..."

    BACKUP_DIR="$HOME/.config/hyprland-backup-$(date +%Y%m%d_%H%M%S)"

    # List of configs to backup
    CONFIGS_TO_BACKUP=(
        "hypr"
        "waybar"
        "wofi"
        "dunst"
        "wlogout"
        "kitty"
        "btop"
        "ags"
        "cava"
    )

    BACKUP_NEEDED=false
    for config in "${CONFIGS_TO_BACKUP[@]}"; do
        if [ -d "$HOME/.config/$config" ]; then
            BACKUP_NEEDED=true
            break
        fi
    done

    if [ "$BACKUP_NEEDED" = true ]; then
        mkdir -p "$BACKUP_DIR"

        for config in "${CONFIGS_TO_BACKUP[@]}"; do
            if [ -d "$HOME/.config/$config" ]; then
                cp -r "$HOME/.config/$config" "$BACKUP_DIR/"
                print_info "Backed up: $config"
            fi
        done

        # Also backup scripts if they exist
        if [ -d "$HOME/.config/scripts" ]; then
            cp -r "$HOME/.config/scripts" "$BACKUP_DIR/"
            print_info "Backed up: scripts"
        fi

        print_success "Backup created in: $BACKUP_DIR"
    else
        print_info "No existing configuration found to backup."
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
# INSTALL CONFIG
# ══════════════════════════════════════════════════════════════════════════════

install_config() {
    print_status "Installing configuration files..."

    # Create required directories
    mkdir -p "$HOME/.config/hypr/wallpapers"
    mkdir -p "$HOME/.config/waybar/scripts"
    mkdir -p "$HOME/.config/wofi/scripts"
    mkdir -p "$HOME/.config/dunst/scripts"
    mkdir -p "$HOME/.config/wlogout"
    mkdir -p "$HOME/.config/hypridle"
    mkdir -p "$HOME/.config/kitty/themes"
    mkdir -p "$HOME/.config/btop/themes"
    mkdir -p "$HOME/.config/ags/widgets"
    mkdir -p "$HOME/.config/ags/windows"
    mkdir -p "$HOME/.config/ags/services"
    mkdir -p "$HOME/.config/scripts"
    mkdir -p "$HOME/.config/cava"
    mkdir -p "$HOME/.config/docs"
    mkdir -p "$HOME/Pictures/Screenshots"

    # Copy all configurations
    declare -A CONFIG_MAPPINGS=(
        ["hypr"]="hypr"
        ["waybar"]="waybar"
        ["wofi"]="wofi"
        ["dunst"]="dunst"
        ["wlogout"]="wlogout"
        ["hypridle"]="hypridle"
        ["kitty"]="kitty"
        ["btop"]="btop"
        ["ags"]="ags"
        ["scripts"]="scripts"
        ["cava"]="cava"
        ["docs"]="docs"
    )

    for src in "${!CONFIG_MAPPINGS[@]}"; do
        dest="${CONFIG_MAPPINGS[$src]}"
        if [ -d "$CONFIG_DIR/$src" ]; then
            cp -r "$CONFIG_DIR/$src/"* "$HOME/.config/$dest/" 2>/dev/null || true
            print_success "Installed: $src"
        fi
    done

    # Make all scripts executable
    print_info "Making scripts executable..."
    find "$HOME/.config/scripts" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    find "$HOME/.config/waybar/scripts" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    find "$HOME/.config/wofi/scripts" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    find "$HOME/.config/dunst/scripts" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    find "$HOME/.config/kitty" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

    print_success "All configurations installed!"
}

# ══════════════════════════════════════════════════════════════════════════════
# CREATE CAVA FIFO
# ══════════════════════════════════════════════════════════════════════════════

setup_cava() {
    print_status "Setting up Cava audio visualizer..."

    # Create FIFO for cava output
    if [ ! -p /tmp/cava.fifo ]; then
        mkfifo /tmp/cava.fifo 2>/dev/null || true
        print_success "Created cava FIFO"
    else
        print_info "Cava FIFO already exists"
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
# DOWNLOAD WALLPAPERS
# ══════════════════════════════════════════════════════════════════════════════

download_wallpapers() {
    print_status "Setting up wallpapers..."

    WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
    mkdir -p "$WALLPAPER_DIR"

    # Check if wallpapers already exist from config
    if [ -d "$CONFIG_DIR/hypr/wallpapers" ] && [ "$(ls -A "$CONFIG_DIR/hypr/wallpapers" 2>/dev/null)" ]; then
        print_success "Wallpapers already included in config"
    else
        print_info "You can add Nord wallpapers to: $WALLPAPER_DIR"
        print_info "Recommended sources:"
        print_info "  - https://github.com/nordtheme/assets"
        print_info "  - https://www.nordtheme.com/"
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
# INSTALL GTK THEME (OPTIONAL)
# ══════════════════════════════════════════════════════════════════════════════

install_gtk_theme() {
    echo -e ""
    print_status "Would you like to install the Nordic GTK theme? (y/n)"
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        case $PKG_MANAGER in
            pacman)
                if [ -n "$AUR_HELPER" ]; then
                    $AUR_INSTALL nordic-theme 2>/dev/null || true
                    print_success "Nordic GTK theme installed"
                fi
                ;;
            *)
                print_info "Please install the Nordic theme manually from:"
                print_info "https://github.com/EliverLara/Nordic"
                ;;
        esac
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
# ENABLE SERVICES
# ══════════════════════════════════════════════════════════════════════════════

enable_services() {
    print_status "Enabling system services..."

    # Enable Bluetooth
    if command_exists bluetoothctl; then
        sudo systemctl enable bluetooth.service 2>/dev/null || true
        print_success "Bluetooth service enabled"
    fi

    # Enable NetworkManager
    if command_exists nmcli; then
        sudo systemctl enable NetworkManager.service 2>/dev/null || true
        print_success "NetworkManager service enabled"
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
# POST INSTALL
# ══════════════════════════════════════════════════════════════════════════════

post_install() {
    echo -e ""
    echo -e "${NORD8}+===================================================================+${RESET}"
    echo -e "${NORD8}|${RESET}                  ${NORD14}INSTALLATION COMPLETE!${RESET}                        ${NORD8}|${RESET}"
    echo -e "${NORD8}+===================================================================+${RESET}"
    echo -e ""
    echo -e "${NORD4}Basic Keybindings:${RESET}"
    echo -e ""
    echo -e "  ${NORD8}SUPER + Return${RESET}       Terminal (Kitty)"
    echo -e "  ${NORD8}SUPER + Space${RESET}        App-Launcher (Wofi)"
    echo -e "  ${NORD8}SUPER + Q${RESET}            Close window"
    echo -e "  ${NORD8}SUPER + F${RESET}            Fullscreen"
    echo -e "  ${NORD8}SUPER + E${RESET}            File manager"
    echo -e "  ${NORD8}SUPER + B${RESET}            Browser"
    echo -e "  ${NORD8}SUPER + 1-0${RESET}          Switch workspace"
    echo -e "  ${NORD8}SUPER + Escape${RESET}       Lock screen"
    echo -e "  ${NORD8}Print${RESET}                Screenshot"
    echo -e ""
    echo -e "${NORD4}AGS Glass UI Controls:${RESET}"
    echo -e ""
    echo -e "  ${NORD8}SUPER + CTRL + Space${RESET} Quick Settings"
    echo -e "  ${NORD8}SUPER + CTRL + D${RESET}     Mini Dashboard"
    echo -e "  ${NORD8}SUPER + CTRL + P${RESET}     Power Menu"
    echo -e "  ${NORD8}SUPER + CTRL + N${RESET}     Notification Center"
    echo -e "  ${NORD8}SUPER + CTRL + W${RESET}     Workspace Preview"
    echo -e "  ${NORD8}SUPER + A${RESET}            Fullscreen Dashboard"
    echo -e ""
    echo -e "${NORD4}Visual Effects:${RESET}"
    echo -e ""
    echo -e "  ${NORD8}SUPER + CTRL + V${RESET}     Toggle Audio Visualizer"
    echo -e "  ${NORD8}SUPER + CTRL + X${RESET}     Toggle Dynamic Borders"
    echo -e "  ${NORD8}SUPER + CTRL + G${RESET}     Toggle Screen Glow"
    echo -e "  ${NORD8}SUPER + CTRL + S${RESET}     Snow Particles"
    echo -e "  ${NORD8}SUPER + CTRL + A${RESET}     Aurora Particles"
    echo -e "  ${NORD8}SUPER + CTRL + R${RESET}     Random Particles"
    echo -e ""
    echo -e "${NORD4}Next Steps:${RESET}"
    echo -e ""
    echo -e "  1. Log out and select Hyprland as your session"
    echo -e "  2. Customize configuration in ~/.config/hypr/"
    echo -e "  3. Add Nord wallpapers to ~/.config/hypr/wallpapers/"
    echo -e "  4. Run 'cava' to start the audio visualizer"
    echo -e ""
    echo -e "${NORD8}Enjoy your Nord Rice - A Visual Masterpiece!${RESET}"
    echo -e ""
}

# ══════════════════════════════════════════════════════════════════════════════
# MAIN
# ══════════════════════════════════════════════════════════════════════════════

main() {
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        print_error "Please do not run as root!"
        exit 1
    fi

    echo -e "${NORD4}This script will:${RESET}"
    echo -e "  ${ARROW} Install all required packages (including AGS, cava)"
    echo -e "  ${ARROW} Backup existing configuration"
    echo -e "  ${ARROW} Install Nord Rice + AGS Glass UI"
    echo -e "  ${ARROW} Install visual effects (particles, glow, shake)"
    echo -e "  ${ARROW} Setup audio visualizer"
    echo -e "  ${ARROW} Enable required services"
    echo -e ""
    echo -e "${NORD4}Continue? (y/n)${RESET}"
    read -r response

    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_info "Installation cancelled."
        exit 0
    fi

    echo -e ""

    detect_package_manager
    install_packages
    backup_config
    install_config
    setup_cava
    download_wallpapers
    enable_services
    install_gtk_theme
    post_install
}

# Run main function
main "$@"