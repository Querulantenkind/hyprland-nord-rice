#!/bin/bash

# Matrix Rain Effect
# Terminal-based Matrix digital rain animation

# Nord colors for matrix effect
GREEN='\033[38;2;163;190;140m'
DARK_GREEN='\033[38;2;136;192;208m'
BLUE='\033[38;2;129;161;193m'
RESET='\033[0m'

# Matrix characters (mix of numbers, letters, symbols)
MATRIX_CHARS="01アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲンabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()_+-=[]{}|;:,.<>?~"

# Get terminal size
COLS=$(tput cols)
LINES=$(tput lines)

# Initialize arrays for rain drops
declare -a drops
declare -a lengths
declare -a speeds

# Initialize rain drops
for ((i=0; i<COLS; i++)); do
    drops[$i]=0
    lengths[$i]=$((RANDOM % 15 + 5))
    speeds[$i]=$((RANDOM % 3 + 1))
done

# Function to get random matrix character
get_random_char() {
    echo -n "${MATRIX_CHARS:$((RANDOM % ${#MATRIX_CHARS})):1}"
}

# Clear screen and hide cursor
clear
tput civis

# Main animation loop
while true; do
    # Move cursor to top
    tput cup 0 0

    # Draw the matrix rain
    for ((y=0; y<LINES; y++)); do
        for ((x=0; x<COLS; x++)); do
            if [ ${drops[$x]} -gt 0 ] && [ $((y - drops[$x] + lengths[$x])) -ge 0 ] && [ $((y - drops[$x] + lengths[$x])) -lt ${lengths[$x]} ]; then
                # Calculate fade effect
                fade_pos=$((y - drops[$x] + lengths[$x]))
                if [ $fade_pos -eq $((lengths[$x]-1)) ]; then
                    echo -ne "${GREEN}$(get_random_char)${RESET}"
                elif [ $fade_pos -eq $((lengths[$x]-2)) ]; then
                    echo -ne "${DARK_GREEN}$(get_random_char)${RESET}"
                else
                    echo -ne "${BLUE}$(get_random_char)${RESET}"
                fi
            else
                echo -n " "
            fi
        done
        echo
    done

    # Update rain drops
    for ((x=0; x<COLS; x++)); do
        if [ $((RANDOM % 100)) -lt 2 ]; then  # 2% chance to start new drop
            drops[$x]=$((RANDOM % LINES / 2))  # Start from top half
            lengths[$x]=$((RANDOM % 15 + 5))
            speeds[$x]=$((RANDOM % 3 + 1))
        fi

        drops[$x]=$((drops[$x] + speeds[$x]))
        if [ ${drops[$x]} -gt $((LINES + lengths[$x])) ]; then
            drops[$x]=0
        fi
    done

    # Small delay for animation speed
    sleep 0.08
done
