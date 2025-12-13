#!/bin/bash

# Wofi Documentation Launcher
# Zentraler Zugriff auf integrierte Dokumentation

# Nord colors for output
NORD8='\033[38;2;136,192,208m'
NORD4='\033[38;2;216,222,233m'
NORD14='\033[38;2;163,190,140m'
RESET='\033[0m'

# Documentation categories
DOC_CATEGORIES=(
    "shortcuts|󰌌 Tastenkombinationen|Alle verfügbaren Keybinds und Shortcuts"
    "troubleshooting|󰀨 Fehlerbehebung|Häufige Probleme und Lösungen"
    "features|✨ Features Übersicht|Detaillierte Feature-Beschreibung"
    "installation|🚀 Installation|Schritt-für-Schritt Setup-Anleitung"
    "customization|🎨 Anpassung|Themes, Konfiguration, Personalisierung"
    "scripts|🔧 Scripts|Dokumentation aller Custom-Scripts"
)

# Function to show category menu
show_categories() {
    # Extract category names for wofi menu
    CATEGORY_NAMES=$(printf '%s\n' "${DOC_CATEGORIES[@]}" | cut -d'|' -f2)

    # Show menu with descriptions
    SELECTED=$(printf '%s\n' "${CATEGORY_NAMES[@]}" | wofi --dmenu \
        --prompt "📚 Dokumentation wählen:" \
        --width 500 \
        --height 300 \
        --location center \
        --gtk-dark \
        --cache-file /dev/null)

    echo "$SELECTED"
}

# Function to get documentation file path
get_doc_file() {
    local category="$1"
    local docs_dir="$HOME/.config/docs"

    case "$category" in
        *"Tastenkombinationen"*)
            echo "$docs_dir/shortcuts.md"
            ;;
        *"Fehlerbehebung"*)
            echo "$docs_dir/troubleshooting.md"
            ;;
        *"Features"*)
            echo "$docs_dir/features.md"
            ;;
        *"Installation"*)
            echo "$docs_dir/installation.md"
            ;;
        *"Anpassung"*)
            echo "$docs_dir/customization.md"
            ;;
        *"Scripts"*)
            echo "$docs_dir/scripts.md"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Function to display documentation
show_documentation() {
    local doc_file="$1"
    local category="$2"

    if [ -f "$doc_file" ]; then
        # Launch documentation viewer
        bash "$HOME/.config/wofi/scripts/docs-viewer.sh" "$doc_file" "$category"
    else
        # Fallback: show error and try to open with default viewer
        notify-send "❌ Dokumentation nicht gefunden" "Datei: $doc_file" -u critical

        # Try to open with default application
        if command -v xdg-open &> /dev/null; then
            xdg-open "$doc_file" 2>/dev/null &
        elif command -v firefox &> /dev/null; then
            firefox "$doc_file" 2>/dev/null &
        fi
    fi
}

# Function to show help
show_help() {
    cat << 'EOF'
📚 Hyprland Nord Rice - Dokumentation

Verfügbare Kategorien:
• Tastenkombinationen - Alle Keybinds und Shortcuts
• Fehlerbehebung     - Häufige Probleme und Lösungen
• Features Übersicht - Detaillierte Feature-Beschreibung
• Installation       - Schritt-für-Schritt Setup-Anleitung
• Anpassung          - Themes, Konfiguration, Personalisierung
• Scripts            - Dokumentation aller Custom-Scripts

Navigation:
• Pfeiltasten oder Maus zum Auswählen
• Enter zum Bestätigen
• Escape zum Abbrechen

Tastenkombinationen:
• SUPER + H         - Dokumentation öffnen
• SUPER + Space     - Haupt-Launcher (mit Docs-Option)

Für schnellen Zugriff: Drücke SUPER + H und wähle eine Kategorie!

EOF
}

# Main function
main() {
    # Check if help is requested
    if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        show_help | cat  # Use cat to preserve formatting
        exit 0
    fi

    # Check if specific category is requested
    if [ -n "$1" ]; then
        case "$1" in
            "shortcuts")
                DOC_FILE=$(get_doc_file "Tastenkombinationen")
                show_documentation "$DOC_FILE" "Tastenkombinationen"
                ;;
            "troubleshooting")
                DOC_FILE=$(get_doc_file "Fehlerbehebung")
                show_documentation "$DOC_FILE" "Fehlerbehebung"
                ;;
            "features")
                DOC_FILE=$(get_doc_file "Features")
                show_documentation "$DOC_FILE" "Features"
                ;;
            "installation")
                DOC_FILE=$(get_doc_file "Installation")
                show_documentation "$DOC_FILE" "Installation"
                ;;
            "customization")
                DOC_FILE=$(get_doc_file "Anpassung")
                show_documentation "$DOC_FILE" "Anpassung"
                ;;
            "scripts")
                DOC_FILE=$(get_doc_file "Scripts")
                show_documentation "$DOC_FILE" "Scripts"
                ;;
            *)
                echo "❌ Unbekannte Kategorie: $1"
                echo "Verfügbare Kategorien: shortcuts, troubleshooting, features, installation, customization, scripts"
                exit 1
                ;;
        esac
        exit 0
    fi

    # Interactive mode - show category menu
    SELECTED_CATEGORY=$(show_categories)

    if [ -n "$SELECTED_CATEGORY" ]; then
        DOC_FILE=$(get_doc_file "$SELECTED_CATEGORY")

        if [ -n "$DOC_FILE" ]; then
            show_documentation "$DOC_FILE" "$SELECTED_CATEGORY"
        else
            notify-send "❌ Fehler" "Kategorie '$SELECTED_CATEGORY' nicht gefunden" -u critical
        fi
    fi
}

# Run main function with all arguments
main "$@"
