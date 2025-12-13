#!/bin/bash

# Easter Eggs Collection
# Random fun messages and animations

# Nord colors
NORD8='\033[38;2;136;192;208m'
NORD14='\033[38;2;163;190;140m'
NORD11='\033[38;2;191;97;106m'
RESET='\033[0m'

# Array of easter egg messages
EASTER_EGGS=(
    "🌟 You found the secret menu! 🌟"
    "🎮 Achievement Unlocked: Power User 🎮"
    "❄️ Welcome to the Nord side ❄️"
    "🚀 To infinity and beyond! 🚀"
    "🎯 You are now a Hyprland Wizard! 🎯"
    "🧙‍♂️ Magic detected in sector 7-G 🧙‍♂️"
    "🎪 Welcome to the greatest show on Earth! 🎪"
    "🌈 Somewhere over the rainbow... 🌈"
    "🎭 All the world's a stage 🎭"
    "🦄 Unicorns and rainbows approved 🦄"
    "🎪 Welcome to the Hyprland Circus! 🎪"
    "🌟 You're a shooting star! 🌟"
    "🎯 Bullseye! You hit the easter egg! 🎯"
    "🧠 Your brain just got bigger 🧠"
    "🎨 Artistic configuration detected 🎨"
    "⚡ Lightning fast rice incoming! ⚡"
    "🔮 The crystal ball says: You're awesome! 🔮"
    "🎪 Step right up! Step right up! 🎪"
    "🌟 You're the star of the show! 🌟"
    "🎭 Bravo! Encore! 🎭"
)

# Random ASCII art
ASCII_ART=(
"
   .-~~-.
  /      \\
 |  Nord   |
  \\      /
   '-~~-'
"
"
  /\\_/\\
 ( o.o )
  > ^ <
"
"
 .-'~~~-.
.'         '.
|   Nord    |
|   Rice    |
|           |
 '._     _.'
    '---'
"
"
   .-.
  (   )
   '-'
  /   \\
 |     |
  \\   /
   '-'
"
)

# Function to show random easter egg
show_easter_egg() {
    local choice=$1

    case $choice in
        "message")
            local random_index=$((RANDOM % ${#EASTER_EGGS[@]}))
            echo -e "${NORD14}${EASTER_EGGS[$random_index]}${RESET}"
            ;;
        "ascii")
            local random_index=$((RANDOM % ${#ASCII_ART[@]}))
            echo -e "${NORD8}${ASCII_ART[$random_index]}${RESET}"
            ;;
        "both")
            local random_index=$((RANDOM % ${#EASTER_EGGS[@]}))
            echo -e "${NORD14}${EASTER_EGGS[$random_index]}${RESET}"
            echo
            local ascii_index=$((RANDOM % ${#ASCII_ART[@]}))
            echo -e "${NORD8}${ASCII_ART[$ascii_index]}${RESET}"
            ;;
        "matrix")
            echo -e "${NORD11}Launching Matrix Rain...${RESET}"
            sleep 1
            exec ~/.config/scripts/matrix-rain.sh
            ;;
    esac
}

# Main function
main() {
    case "$1" in
        "message"|"ascii"|"both"|"matrix")
            show_easter_egg "$1"
            ;;
        *)
            # Random choice
            local choices=("message" "ascii" "both")
            local random_choice=${choices[$((RANDOM % ${#choices[@]}))]}
            show_easter_egg "$random_choice"
            ;;
    esac
}

# Run main function
main "$@"
