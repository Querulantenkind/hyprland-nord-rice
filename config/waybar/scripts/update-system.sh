#!/bin/bash

# System update script for Nord-themed Hyprland rice
# This script will update the system based on the detected package manager

# Nord colors for output
NORD8='\033[38;2;136;192;208m'
NORD14='\033[38;2;163;190;140m'
NORD11='\033[38;2;191;97;106m'
RESET='\033[0m'

echo -e "${NORD8}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${NORD8}║${RESET}              ${NORD14}SYSTEM UPDATE${RESET}                              ${NORD8}║${RESET}"
echo -e "${NORD8}╚══════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Function to show progress
show_progress() {
    echo -e "${NORD8}→${RESET} $1"
}

# Function to show success
show_success() {
    echo -e "${NORD14}✓${RESET} $1"
}

# Function to show error
show_error() {
    echo -e "${NORD11}✗${RESET} $1"
}

# Detect package manager and update accordingly
if command -v pacman &> /dev/null; then
    show_progress "Aktualisiere Arch Linux System..."

    # Update package database
    if sudo pacman -Sy --noconfirm; then
        show_success "Paketdatenbank aktualisiert"
    else
        show_error "Fehler beim Aktualisieren der Paketdatenbank"
        exit 1
    fi

    # Update system
    if sudo pacman -Su --noconfirm; then
        show_success "System erfolgreich aktualisiert!"
    else
        show_error "Fehler beim System-Update"
        exit 1
    fi

    # Update AUR packages if yay/paru is available
    if command -v yay &> /dev/null; then
        show_progress "Aktualisiere AUR-Pakete (yay)..."
        if yay -Syu --noconfirm; then
            show_success "AUR-Pakete aktualisiert"
        else
            show_error "Fehler beim AUR-Update"
        fi
    elif command -v paru &> /dev/null; then
        show_progress "Aktualisiere AUR-Pakete (paru)..."
        if paru -Syu --noconfirm; then
            show_success "AUR-Pakete aktualisiert"
        else
            show_error "Fehler beim AUR-Update"
        fi
    fi

elif command -v apt &> /dev/null; then
    show_progress "Aktualisiere Debian/Ubuntu System..."

    # Update package lists
    if sudo apt update; then
        show_success "Paketlisten aktualisiert"
    else
        show_error "Fehler beim Aktualisieren der Paketlisten"
        exit 1
    fi

    # Upgrade system
    if sudo apt upgrade -y; then
        show_success "System erfolgreich aktualisiert!"
    else
        show_error "Fehler beim System-Update"
        exit 1
    fi

    # Auto-remove unused packages
    if sudo apt autoremove -y; then
        show_success "Nicht benötigte Pakete entfernt"
    fi

elif command -v dnf &> /dev/null; then
    show_progress "Aktualisiere Fedora System..."

    # Update system
    if sudo dnf upgrade -y; then
        show_success "System erfolgreich aktualisiert!"
    else
        show_error "Fehler beim System-Update"
        exit 1
    fi

    # Clean up
    if sudo dnf autoremove -y; then
        show_success "Nicht benötigte Pakete entfernt"
    fi

else
    show_error "Unbekannter Paketmanager. Manuelles Update erforderlich."
    exit 1
fi

# Update Flatpak if available
if command -v flatpak &> /dev/null; then
    show_progress "Aktualisiere Flatpak-Anwendungen..."
    if flatpak update -y; then
        show_success "Flatpak-Anwendungen aktualisiert"
    else
        show_error "Fehler beim Flatpak-Update"
    fi
fi

# Update firmware if fwupdmgr is available
if command -v fwupdmgr &> /dev/null; then
    show_progress "Prüfe auf Firmware-Updates..."
    if sudo fwupdmgr refresh && sudo fwupdmgr update -y; then
        show_success "Firmware aktualisiert"
    else
        show_error "Fehler beim Firmware-Update"
    fi
fi

echo ""
echo -e "${NORD14}System-Update abgeschlossen!${RESET}"
echo -e "${NORD8}Drücke Enter zum Schließen...${RESET}"
read
