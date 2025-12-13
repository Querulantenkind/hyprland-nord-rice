#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║               HYPRLAND NORD RICE - UNINSTALL SCRIPT                       ║
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

echo -e ""
echo -e "${NORD11}+===================================================================+${RESET}"
echo -e "${NORD11}|${RESET}     ${NORD4}HYPRLAND NORD RICE - UNINSTALLER${RESET}                           ${NORD11}|${RESET}"
echo -e "${NORD11}+===================================================================+${RESET}"
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
# STOP RUNNING PROCESSES
# ══════════════════════════════════════════════════════════════════════════════

stop_processes() {
    print_status "Stopping running processes..."

    # List of processes to stop
    PROCESSES=(
        "waybar"
        "hyprpaper"
        "hypridle"
        "dunst"
        "ags"
        "cava"
    )

    for process in "${PROCESSES[@]}"; do
        if pgrep -x "$process" > /dev/null; then
            pkill -x "$process" 2>/dev/null || true
            print_info "Stopped: $process"
        fi
    done

    # Stop custom scripts
    pkill -f "dynamic-borders.sh" 2>/dev/null || true
    pkill -f "screen-glow.sh" 2>/dev/null || true
    pkill -f "particle-effects.sh" 2>/dev/null || true

    print_success "Processes stopped"
}

# ══════════════════════════════════════════════════════════════════════════════
# REMOVE CONFIGURATIONS
# ══════════════════════════════════════════════════════════════════════════════

remove_configs() {
    print_status "Removing configuration files..."

    # List of configs to remove
    CONFIGS_TO_REMOVE=(
        "hypr"
        "waybar"
        "wofi"
        "dunst"
        "wlogout"
        "hypridle"
        "kitty"
        "btop"
        "ags"
        "scripts"
        "cava"
        "docs"
    )

    for config in "${CONFIGS_TO_REMOVE[@]}"; do
        if [ -d "$HOME/.config/$config" ]; then
            rm -rf "$HOME/.config/$config"
            print_info "Removed: ~/.config/$config"
        fi
    done

    # Remove cava FIFO
    if [ -p /tmp/cava.fifo ]; then
        rm -f /tmp/cava.fifo
        print_info "Removed: cava FIFO"
    fi

    print_success "Configurations removed"
}

# ══════════════════════════════════════════════════════════════════════════════
# RESTORE BACKUP
# ══════════════════════════════════════════════════════════════════════════════

restore_backup() {
    print_status "Looking for backups..."

    # Find backup directories
    BACKUPS=$(find "$HOME/.config" -maxdepth 1 -name "hyprland-backup-*" -type d 2>/dev/null | sort -r)

    if [ -z "$BACKUPS" ]; then
        print_info "No backup found."
        return
    fi

    echo -e ""
    echo -e "${NORD4}Available backups:${RESET}"
    echo -e ""

    # List backups with numbers
    i=1
    for backup in $BACKUPS; do
        backup_name=$(basename "$backup")
        backup_date=$(echo "$backup_name" | sed 's/hyprland-backup-//' | sed 's/_/ /')
        echo -e "  ${NORD8}$i)${RESET} $backup_name (Created: $backup_date)"
        ((i++))
    done

    echo -e ""
    echo -e "${NORD4}Would you like to restore a backup? (Enter number or 'n' to skip)${RESET}"
    read -r response

    if [[ "$response" =~ ^[0-9]+$ ]]; then
        # Get selected backup
        SELECTED_BACKUP=$(echo "$BACKUPS" | sed -n "${response}p")

        if [ -n "$SELECTED_BACKUP" ] && [ -d "$SELECTED_BACKUP" ]; then
            print_status "Restoring backup from: $(basename "$SELECTED_BACKUP")"

            # Restore each config
            for config_dir in "$SELECTED_BACKUP"/*; do
                if [ -d "$config_dir" ]; then
                    config_name=$(basename "$config_dir")
                    mkdir -p "$HOME/.config/$config_name"
                    cp -r "$config_dir/"* "$HOME/.config/$config_name/" 2>/dev/null || true
                    print_info "Restored: $config_name"
                fi
            done

            print_success "Backup restored!"
        else
            print_error "Invalid selection"
        fi
    else
        print_info "Skipping backup restore"
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
# REMOVE PACKAGES (OPTIONAL)
# ══════════════════════════════════════════════════════════════════════════════

remove_packages() {
    echo -e ""
    echo -e "${NORD11}WARNING: This will remove installed packages.${RESET}"
    echo -e "${NORD4}Would you like to remove the installed packages? (y/n)${RESET}"
    read -r response

    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_info "Skipping package removal"
        return
    fi

    # Detect package manager
    if command_exists pacman; then
        PKG_MANAGER="pacman"
        PKG_REMOVE="sudo pacman -Rns --noconfirm"
    elif command_exists apt; then
        PKG_MANAGER="apt"
        PKG_REMOVE="sudo apt remove -y"
    elif command_exists dnf; then
        PKG_MANAGER="dnf"
        PKG_REMOVE="sudo dnf remove -y"
    elif command_exists zypper; then
        PKG_MANAGER="zypper"
        PKG_REMOVE="sudo zypper remove -y"
    else
        print_error "No supported package manager found!"
        return
    fi

    # Core packages that were installed by the rice
    PACKAGES_TO_REMOVE=(
        "cava"
        "aylurs-gtk-shell"
    )

    # Optional packages - ask before removing
    OPTIONAL_PACKAGES=(
        "hyprpaper"
        "hyprlock"
        "hypridle"
        "wlogout"
        "cliphist"
    )

    echo -e ""
    echo -e "${NORD4}Remove audio visualizer and AGS? (y/n)${RESET}"
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        for pkg in "${PACKAGES_TO_REMOVE[@]}"; do
            $PKG_REMOVE "$pkg" 2>/dev/null || true
            print_info "Removed: $pkg"
        done
    fi

    echo -e ""
    echo -e "${NORD4}Remove Hyprland extras (hyprlock, hypridle, etc.)? (y/n)${RESET}"
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        for pkg in "${OPTIONAL_PACKAGES[@]}"; do
            $PKG_REMOVE "$pkg" 2>/dev/null || true
            print_info "Removed: $pkg"
        done
    fi

    print_success "Package removal completed"
}

# ══════════════════════════════════════════════════════════════════════════════
# CLEAN UP
# ══════════════════════════════════════════════════════════════════════════════

cleanup() {
    print_status "Cleaning up..."

    # Remove orphaned packages (Arch only)
    if command_exists pacman; then
        ORPHANS=$(pacman -Qtdq 2>/dev/null)
        if [ -n "$ORPHANS" ]; then
            echo -e ""
            echo -e "${NORD4}Remove orphaned packages? (y/n)${RESET}"
            read -r response

            if [[ "$response" =~ ^[Yy]$ ]]; then
                sudo pacman -Rns --noconfirm $ORPHANS 2>/dev/null || true
                print_success "Orphaned packages removed"
            fi
        fi
    fi

    # Clear cache
    if [ -d "$HOME/.cache/ags" ]; then
        rm -rf "$HOME/.cache/ags"
        print_info "Cleared AGS cache"
    fi

    print_success "Cleanup completed"
}

# ══════════════════════════════════════════════════════════════════════════════
# DELETE BACKUPS (OPTIONAL)
# ══════════════════════════════════════════════════════════════════════════════

delete_backups() {
    BACKUPS=$(find "$HOME/.config" -maxdepth 1 -name "hyprland-backup-*" -type d 2>/dev/null)

    if [ -z "$BACKUPS" ]; then
        return
    fi

    echo -e ""
    echo -e "${NORD4}Would you like to delete all backup files? (y/n)${RESET}"
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        for backup in $BACKUPS; do
            rm -rf "$backup"
            print_info "Deleted: $(basename "$backup")"
        done
        print_success "All backups deleted"
    else
        print_info "Backups preserved"
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
# POST UNINSTALL
# ══════════════════════════════════════════════════════════════════════════════

post_uninstall() {
    echo -e ""
    echo -e "${NORD14}+===================================================================+${RESET}"
    echo -e "${NORD14}|${RESET}                  ${NORD4}UNINSTALLATION COMPLETE!${RESET}                      ${NORD14}|${RESET}"
    echo -e "${NORD14}+===================================================================+${RESET}"
    echo -e ""
    echo -e "${NORD4}The following has been done:${RESET}"
    echo -e ""
    echo -e "  ${CHECK} Stopped running processes"
    echo -e "  ${CHECK} Removed configuration files"
    echo -e "  ${CHECK} Offered backup restoration"
    echo -e "  ${CHECK} Optionally removed packages"
    echo -e ""
    echo -e "${NORD4}Next Steps:${RESET}"
    echo -e ""
    echo -e "  1. Log out and select a different session"
    echo -e "  2. Or reinstall with: ${NORD8}./install.sh${RESET}"
    echo -e ""
    echo -e "${NORD8}Thank you for trying Hyprland Nord Rice!${RESET}"
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

    echo -e "${NORD11}WARNING: This will remove the Hyprland Nord Rice configuration.${RESET}"
    echo -e ""
    echo -e "${NORD4}This script will:${RESET}"
    echo -e "  ${ARROW} Stop running processes (waybar, ags, cava, etc.)"
    echo -e "  ${ARROW} Remove all configuration files"
    echo -e "  ${ARROW} Offer to restore backed-up configurations"
    echo -e "  ${ARROW} Optionally remove installed packages"
    echo -e ""
    echo -e "${NORD4}Are you sure you want to continue? (y/n)${RESET}"
    read -r response

    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_info "Uninstallation cancelled."
        exit 0
    fi

    echo -e ""

    stop_processes
    remove_configs
    restore_backup
    remove_packages
    cleanup
    delete_backups
    post_uninstall
}

# Run main function
main "$@"
