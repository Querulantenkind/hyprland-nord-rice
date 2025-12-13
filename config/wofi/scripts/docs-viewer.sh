#!/bin/bash

# Wofi Documentation Viewer
# Zeigt Markdown-Dokumentation in Wofi-Menü an

# Nord colors for output
NORD8='\033[38;2;136,192,208m'
NORD4='\033[38;2;216,222,233m'
NORD14='\033[38;2;163,190,140m'
NORD11='\033[38;2;191,97,106m'
RESET='\033[0m'

# Global variables
DOC_FILE=""
CATEGORY=""
SEARCH_TERM=""

# Function to convert markdown to wofi-readable format
convert_markdown() {
    local file="$1"

    if [ ! -f "$file" ]; then
        echo "❌ Datei nicht gefunden: $file"
        return 1
    fi

    # Convert markdown to simple text format
    # This is a basic converter - focuses on headers, lists, and code blocks
    sed \
        -e 's/^# /📖 /g' \
        -e 's/^## /📑 /g' \
        -e 's/^### /📄 /g' \
        -e 's/^#### /📃 /g' \
        -e 's/^\* /- /g' \
        -e 's/^\- /- /g' \
        -e 's/^```.*$/┌─ Code Block ──────────────────────────────────┐/g' \
        -e 's/^```$/└─────────────────────────────────────────────┘/g' \
        -e 's/`/"/g' \
        -e 's/\*\*//g' \
        -e 's/\*//g' \
        -e 's/_//g' \
        -e 's/|/ /g' \
        "$file"
}

# Function to show documentation content
show_documentation() {
    local file="$1"
    local category="$2"

    # Convert markdown and create menu content
    local content=$(convert_markdown "$file")

    if [ $? -ne 0 ]; then
        notify-send "❌ Dokumentation-Fehler" "Konnte Datei nicht laden: $file" -u critical
        return 1
    fi

    # Add header
    local header="📚 $category"
    local header_separator=$(printf '─%.0s' $(seq 1 $((${#header} + 4))))

    # Create menu options
    local menu_content="$header
$header_separator

$content

$header_separator
🔙 Zurück zur Kategorien-Auswahl
❌ Schließen"

    # Show in wofi with larger window for documentation
    local selected=$(echo "$menu_content" | wofi --dmenu \
        --prompt "📖 $category (Scrollen mit Pfeiltasten):" \
        --width 800 \
        --height 600 \
        --location center \
        --gtk-dark \
        --cache-file /dev/null \
        --allow-markup \
        --insensitive)

    # Handle selection
    case "$selected" in
        *"Zurück zur Kategorien-Auswahl"*)
            # Return to main launcher
            exec "$HOME/.config/wofi/scripts/docs-launcher.sh"
            ;;
        *"Schließen"*)
            # Close documentation
            exit 0
            ;;
        "")
            # Empty selection (Escape pressed)
            exit 0
            ;;
        *)
            # Content selected - could implement section jumping here
            # For now, just show the selection
            notify-send "📖 $category" "$selected" -t 3000
            ;;
    esac
}

# Function to search within documentation
search_documentation() {
    local file="$1"
    local category="$2"

    # Get search term
    SEARCH_TERM=$(echo "" | wofi --dmenu \
        --prompt "🔍 Suche in $category:" \
        --width 400 \
        --height 50 \
        --location center \
        --gtk-dark)

    if [ -n "$SEARCH_TERM" ]; then
        # Search for term in file (case insensitive)
        local results=$(grep -i "$SEARCH_TERM" "$file" | head -10)

        if [ -n "$results" ]; then
            # Show search results
            local result_menu="🔍 Suchergebnisse für '$SEARCH_TERM' in $category:

$results

$header_separator
🔙 Neue Suche
📖 Volle Dokumentation anzeigen
❌ Schließen"

            local selected=$(echo "$result_menu" | wofi --dmenu \
                --prompt "🔍 Suchergebnisse:" \
                --width 700 \
                --height 400 \
                --location center \
                --gtk-dark)

            case "$selected" in
                *"Neue Suche"*)
                    search_documentation "$file" "$category"
                    ;;
                *"Volle Dokumentation"*)
                    show_documentation "$file" "$category"
                    ;;
                *"Schließen"*)
                    exit 0
                    ;;
                "")
                    exit 0
                    ;;
                *)
                    notify-send "🔍 Suchergebnis" "$selected" -t 5000
                    ;;
            esac
        else
            notify-send "🔍 Keine Ergebnisse" "Keine Treffer für '$SEARCH_TERM' in $category" -u low
            # Return to search
            search_documentation "$file" "$category"
        fi
    fi
}

# Function to show viewer options
show_viewer_menu() {
    local file="$1"
    local category="$2"

    local menu="📖 $category - Optionen

🔍 In Dokumentation suchen
📄 Dokumentation anzeigen
📋 Inhalt kopieren
🌐 In Browser öffnen
❌ Schließen"

    local selected=$(echo "$menu" | wofi --dmenu \
        --prompt "📖 $category:" \
        --width 400 \
        --height 200 \
        --location center \
        --gtk-dark)

    case "$selected" in
        *"suchen"*)
            search_documentation "$file" "$category"
            ;;
        *"anzeigen"*)
            show_documentation "$file" "$category"
            ;;
        *"kopieren"*)
            if command -v wl-copy &> /dev/null; then
                cat "$file" | wl-copy
                notify-send "📋 Kopiert" "$category wurde in die Zwischenablage kopiert" -t 2000
            else
                notify-send "❌ Fehler" "wl-copy nicht verfügbar" -u critical
            fi
            show_viewer_menu "$file" "$category"
            ;;
        *"Browser"*)
            if command -v firefox &> /dev/null; then
                firefox "$file" &
                notify-send "🌐 Geöffnet" "$category wurde im Browser geöffnet" -t 2000
            elif command -v xdg-open &> /dev/null; then
                xdg-open "$file" &
                notify-send "🌐 Geöffnet" "$category wurde mit Standardanwendung geöffnet" -t 2000
            else
                notify-send "❌ Fehler" "Keine Anwendung zum Öffnen verfügbar" -u critical
            fi
            show_viewer_menu "$file" "$category"
            ;;
        *"Schließen"*)
            exit 0
            ;;
        "")
            exit 0
            ;;
    esac
}

# Function to validate arguments
validate_args() {
    if [ $# -lt 1 ]; then
        echo "❌ Verwendung: $0 <dokumentations_datei> [kategorie]"
        echo "Beispiel: $0 ~/.config/docs/shortcuts.md 'Tastenkombinationen'"
        exit 1
    fi

    DOC_FILE="$1"
    CATEGORY="${2:-Dokumentation}"

    if [ ! -f "$DOC_FILE" ]; then
        echo "❌ Dokumentationsdatei nicht gefunden: $DOC_FILE"
        exit 1
    fi
}

# Function to show help
show_help() {
    cat << 'EOF'
📖 Wofi Documentation Viewer

Zeigt Markdown-Dokumentation in einem interaktiven Wofi-Menü an.

Verwendung:
    docs-viewer.sh <datei> [kategorie]

Beispiele:
    docs-viewer.sh ~/.config/docs/shortcuts.md "Tastenkombinationen"
    docs-viewer.sh ~/.config/docs/features.md

Features:
• Markdown-zu-Text Konvertierung
• Durchsuchbare Dokumentation
• Inhalt kopieren
• In Browser öffnen
• Navigation zwischen Abschnitten

Tastenkombinationen:
• Pfeiltasten: Navigieren
• Enter: Auswählen
• Escape: Schließen

Integration:
• Automatisch über docs-launcher.sh aufgerufen
• Verfügbar über SUPER + H

EOF
}

# Main function
main() {
    # Check for help
    if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        show_help
        exit 0
    fi

    # Validate arguments
    validate_args "$@"

    # Show viewer menu
    show_viewer_menu "$DOC_FILE" "$CATEGORY"
}

# Run main function
main "$@"
