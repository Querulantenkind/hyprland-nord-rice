#!/bin/bash

# Wofi Calculator Mode
# Nord-themed calculator for quick calculations

# Colors for output
NORD8='\033[38;2;136;192;208m'
NORD4='\033[38;2;216;222;233m'
NORD14='\033[38;2;163;190;140m'
RESET='\033[0m'

# Function to evaluate expression safely
calculate() {
    local expr="$1"

    # Remove spaces and validate input
    expr=$(echo "$expr" | tr -d ' ')

    # Basic validation - only allow numbers, operators, parentheses, and decimal points
    if ! echo "$expr" | grep -qE '^[-+*/0-9().]+$'; then
        echo "❌ Ungültiger Ausdruck"
        return 1
    fi

    # Use bc for calculation with floating point support
    result=$(echo "scale=4; $expr" | bc 2>/dev/null)

    if [ $? -eq 0 ] && [ -n "$result" ]; then
        # Format result
        if echo "$result" | grep -q '\.'; then
            # Remove trailing zeros after decimal
            result=$(echo "$result" | sed 's/\.0*$//' | sed 's/\.$//')
        fi

        echo -e "${NORD14}󰃬 ${result}${RESET}"
    else
        echo "❌ Fehler bei Berechnung"
    fi
}

# Main calculator loop
echo -e "${NORD8}Taschenrechner - Tippe Ausdruck oder 'exit' zum Beenden${RESET}"
echo -e "${NORD4}Beispiele: 2+3, 15*4, (10-3)/2, sqrt(16)${RESET}"
echo ""

while true; do
    echo -n "> "
    read -r input

    case "$input" in
        "exit"|"quit"|"q")
            break
            ;;
        "")
            continue
            ;;
        *)
            if calculate "$input"; then
                echo ""
            fi
            ;;
    esac
done
