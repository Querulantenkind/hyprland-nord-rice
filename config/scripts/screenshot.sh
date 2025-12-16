#!/bin/bash

# ╔══════════════════════════════════════════════════════════════════════════╗
# ║                         Screenshot Script                                 ║
# ║                      For Hyprland + Wayland                               ║
# ╚══════════════════════════════════════════════════════════════════════════╝

# Abhängigkeiten: grim, slurp, wl-copy, jq, hyprctl, dunstify/notify-send

# ─────────────────────────────────────────────────────────────────────────────
# Konfiguration
# ─────────────────────────────────────────────────────────────────────────────

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
DATE_FORMAT="+%Y-%m-%d_%H-%M-%S"
FILENAME_PREFIX="screenshot"

# Erstelle Screenshot-Verzeichnis falls nicht vorhanden
mkdir -p "$SCREENSHOT_DIR"

# Nord-Farben für slurp
NORD_SELECTION="#88c0d0"
NORD_BG="#2e3440aa"

# ─────────────────────────────────────────────────────────────────────────────
# Funktionen
# ─────────────────────────────────────────────────────────────────────────────

notify() {
    local title="$1"
    local message="$2"
    local icon="$3"
    
    if command -v dunstify &> /dev/null; then
        dunstify -a "screenshot" -u low -i "${icon:-camera}" "$title" "$message" -t 3000
    elif command -v notify-send &> /dev/null; then
        notify-send -u low -i "${icon:-camera}" "$title" "$message"
    fi
}

notify_with_action() {
    local title="$1"
    local message="$2"
    local filepath="$3"
    
    if command -v dunstify &> /dev/null; then
        action=$(dunstify -a "screenshot" -u low -i "camera" "$title" "$message" \
            -A "open,Öffnen" \
            -A "folder,Ordner öffnen" \
            -A "edit,Bearbeiten" \
            -t 5000)
        
        case "$action" in
            "open")
                xdg-open "$filepath" &
                ;;
            "folder")
                xdg-open "$SCREENSHOT_DIR" &
                ;;
            "edit")
                if command -v gimp &> /dev/null; then
                    gimp "$filepath" &
                elif command -v swappy &> /dev/null; then
                    swappy -f "$filepath" &
                fi
                ;;
        esac
    else
        notify-send -u low -i "camera" "$title" "$message"
    fi
}

get_filename() {
    local suffix="$1"
    local timestamp=$(date "$DATE_FORMAT")
    echo "${SCREENSHOT_DIR}/${FILENAME_PREFIX}_${suffix}_${timestamp}.png"
}

# Screenshot des gesamten Bildschirms
screenshot_full() {
    local save_to_file="$1"
    local filename=$(get_filename "full")
    
    if [ "$save_to_file" = "true" ]; then
        grim "$filename"
        wl-copy < "$filename"
        notify_with_action "📷 Screenshot" "Vollbild gespeichert und in Zwischenablage kopiert" "$filename"
    else
        grim - | wl-copy
        notify "📷 Screenshot" "Vollbild in Zwischenablage kopiert"
    fi
}

# Screenshot eines ausgewählten Bereichs
screenshot_area() {
    local save_to_file="$1"
    local filename=$(get_filename "area")
    
    # slurp für Bereichsauswahl mit Nord-Farben
    local geometry=$(slurp -d -b "$NORD_BG" -c "$NORD_SELECTION" -s "${NORD_BG}40" -w 2)
    
    if [ -z "$geometry" ]; then
        notify "❌ Abgebrochen" "Screenshot abgebrochen"
        exit 1
    fi
    
    if [ "$save_to_file" = "true" ]; then
        grim -g "$geometry" "$filename"
        wl-copy < "$filename"
        notify_with_action "📷 Screenshot" "Bereich gespeichert und in Zwischenablage kopiert" "$filename"
    else
        grim -g "$geometry" - | wl-copy
        notify "📷 Screenshot" "Bereich in Zwischenablage kopiert"
    fi
}

# Screenshot des aktiven Fensters
screenshot_window() {
    local save_to_file="$1"
    local filename=$(get_filename "window")
    
    # Hole die Geometrie des aktiven Fensters via hyprctl
    local geometry=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
    
    if [ -z "$geometry" ] || [ "$geometry" = "null,null nullxnull" ]; then
        notify "❌ Fehler" "Kein aktives Fenster gefunden"
        exit 1
    fi
    
    if [ "$save_to_file" = "true" ]; then
        grim -g "$geometry" "$filename"
        wl-copy < "$filename"
        notify_with_action "📷 Screenshot" "Fenster gespeichert und in Zwischenablage kopiert" "$filename"
    else
        grim -g "$geometry" - | wl-copy
        notify "📷 Screenshot" "Fenster in Zwischenablage kopiert"
    fi
}

# Screenshot des aktuellen Monitors
screenshot_monitor() {
    local save_to_file="$1"
    local filename=$(get_filename "monitor")
    
    # Hole den Namen des aktiven Monitors
    local monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
    
    if [ -z "$monitor" ]; then
        notify "❌ Fehler" "Kein aktiver Monitor gefunden"
        exit 1
    fi
    
    if [ "$save_to_file" = "true" ]; then
        grim -o "$monitor" "$filename"
        wl-copy < "$filename"
        notify_with_action "📷 Screenshot" "Monitor gespeichert und in Zwischenablage kopiert" "$filename"
    else
        grim -o "$monitor" - | wl-copy
        notify "📷 Screenshot" "Monitor in Zwischenablage kopiert"
    fi
}

# Interaktives Menü mit wofi/rofi
screenshot_menu() {
    local options="󰹑  Vollbild (speichern)\n󰹑  Vollbild (Clipboard)\n󰩭  Bereich (speichern)\n󰩭  Bereich (Clipboard)\n󰖯  Fenster (speichern)\n󰖯  Fenster (Clipboard)\n󰍹  Monitor (speichern)\n󰍹  Monitor (Clipboard)"
    
    local choice
    if command -v wofi &> /dev/null; then
        choice=$(echo -e "$options" | wofi --dmenu --prompt "Screenshot" --cache-file=/dev/null)
    elif command -v rofi &> /dev/null; then
        choice=$(echo -e "$options" | rofi -dmenu -p "Screenshot")
    else
        notify "❌ Fehler" "Weder wofi noch rofi gefunden"
        exit 1
    fi
    
    case "$choice" in
        *"Vollbild (speichern)"*)
            screenshot_full true
            ;;
        *"Vollbild (Clipboard)"*)
            screenshot_full false
            ;;
        *"Bereich (speichern)"*)
            screenshot_area true
            ;;
        *"Bereich (Clipboard)"*)
            screenshot_area false
            ;;
        *"Fenster (speichern)"*)
            screenshot_window true
            ;;
        *"Fenster (Clipboard)"*)
            screenshot_window false
            ;;
        *"Monitor (speichern)"*)
            screenshot_monitor true
            ;;
        *"Monitor (Clipboard)"*)
            screenshot_monitor false
            ;;
        *)
            exit 0
            ;;
    esac
}

# Mit swappy bearbeiten (falls installiert)
screenshot_edit() {
    if ! command -v swappy &> /dev/null; then
        notify "❌ Fehler" "swappy ist nicht installiert"
        exit 1
    fi
    
    local geometry=$(slurp -d -b "$NORD_BG" -c "$NORD_SELECTION" -s "${NORD_BG}40" -w 2)
    
    if [ -z "$geometry" ]; then
        notify "❌ Abgebrochen" "Screenshot abgebrochen"
        exit 1
    fi
    
    grim -g "$geometry" - | swappy -f -
}

# Verzögerter Screenshot
screenshot_delayed() {
    local delay="${1:-5}"
    local mode="${2:-full}"
    
    notify "⏱️ Verzögert" "Screenshot in $delay Sekunden..."
    sleep "$delay"
    
    case "$mode" in
        "full")
            screenshot_full true
            ;;
        "area")
            screenshot_area true
            ;;
        "window")
            screenshot_window true
            ;;
        "monitor")
            screenshot_monitor true
            ;;
    esac
}

# Hilfe anzeigen
show_help() {
    cat << EOF
╔══════════════════════════════════════════════════════════════════════════╗
║                         Screenshot Script                                 ║
║                      Verwendung und Optionen                              ║
╚══════════════════════════════════════════════════════════════════════════╝

VERWENDUNG:
    screenshot.sh [OPTION] [ARGUMENTE]

OPTIONEN:
    full           Vollbild-Screenshot (in Clipboard)
    full-save      Vollbild-Screenshot (speichern + Clipboard)
    area           Bereich-Screenshot (in Clipboard)
    area-save      Bereich-Screenshot (speichern + Clipboard)
    window         Fenster-Screenshot (in Clipboard)
    window-save    Fenster-Screenshot (speichern + Clipboard)
    monitor        Monitor-Screenshot (in Clipboard)
    monitor-save   Monitor-Screenshot (speichern + Clipboard)
    menu           Interaktives Menü (wofi/rofi)
    edit           Bereich auswählen und in swappy bearbeiten
    delay [SEC] [MODE]
                   Verzögerter Screenshot (Standard: 5 Sekunden, full)
    help           Diese Hilfe anzeigen

BEISPIELE:
    screenshot.sh area          # Bereich in Clipboard
    screenshot.sh full-save     # Vollbild speichern
    screenshot.sh delay 3 area  # Bereich nach 3 Sekunden
    screenshot.sh menu          # Wofi-Menü öffnen

TASTENKÜRZEL (empfohlen für hyprland.conf):
    bind = , Print, exec, ~/.config/scripts/screenshot.sh full
    bind = SHIFT, Print, exec, ~/.config/scripts/screenshot.sh area
    bind = CTRL, Print, exec, ~/.config/scripts/screenshot.sh window
    bind = ALT, Print, exec, ~/.config/scripts/screenshot.sh menu
    bind = SUPER, Print, exec, ~/.config/scripts/screenshot.sh full-save

ABHÄNGIGKEITEN:
    - grim (Screenshot-Tool für Wayland)
    - slurp (Bereichsauswahl)
    - wl-copy (Clipboard)
    - jq (JSON-Parser)
    - dunstify oder notify-send (Benachrichtigungen)
    - wofi oder rofi (für Menü)
    - swappy (optional, für Bearbeitung)

Screenshots werden gespeichert in: $SCREENSHOT_DIR
EOF
}

# ─────────────────────────────────────────────────────────────────────────────
# Hauptprogramm
# ─────────────────────────────────────────────────────────────────────────────

# Prüfe Abhängigkeiten
for cmd in grim wl-copy; do
    if ! command -v "$cmd" &> /dev/null; then
        notify "❌ Fehler" "$cmd ist nicht installiert"
        exit 1
    fi
done

case "${1:-menu}" in
    "full")
        screenshot_full false
        ;;
    "full-save")
        screenshot_full true
        ;;
    "area")
        screenshot_area false
        ;;
    "area-save")
        screenshot_area true
        ;;
    "window")
        screenshot_window false
        ;;
    "window-save")
        screenshot_window true
        ;;
    "monitor")
        screenshot_monitor false
        ;;
    "monitor-save")
        screenshot_monitor true
        ;;
    "menu")
        screenshot_menu
        ;;
    "edit")
        screenshot_edit
        ;;
    "delay")
        screenshot_delayed "${2:-5}" "${3:-full}"
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        echo "Unbekannte Option: $1"
        echo "Verwende 'screenshot.sh help' für Hilfe"
        exit 1
        ;;
esac
