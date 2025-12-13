#!/bin/bash

# Fun Sounds and Notifications
# Play system sounds and show fun notifications

# Check if sox or similar is available for sound generation
check_audio_tools() {
    if command -v play &> /dev/null; then
        AUDIO_TOOL="sox"
        return 0
    elif command -v aplay &> /dev/null; then
        AUDIO_TOOL="alsa"
        return 0
    elif command -v paplay &> /dev/null; then
        AUDIO_TOOL="pulse"
        return 0
    else
        AUDIO_TOOL="none"
        return 1
    fi
}

# Generate a beep sound
play_beep() {
    local freq=$1
    local duration=$2

    case $AUDIO_TOOL in
        "sox")
            play -n synth $duration sine $freq &> /dev/null &
            ;;
        "alsa")
            # Generate simple beep with speaker-test
            speaker-test -t sine -f $freq -l 1 &> /dev/null &
            sleep $duration
            kill %1 2>/dev/null
            ;;
        "pulse")
            # Use paplay if available
            echo "PulseAudio beep not implemented"
            ;;
        *)
            # Fallback to terminal bell
            echo -e "\a"
            ;;
    esac
}

# Success sound and notification
success_sound() {
    notify-send "🎉 Success!" "Achievement unlocked!" -i dialog-information -t 3000
    play_beep 800 0.2
    sleep 0.1
    play_beep 1000 0.3
}

# Error sound and notification
error_sound() {
    notify-send "❌ Error!" "Something went wrong!" -i dialog-error -t 3000
    play_beep 200 0.5
    sleep 0.1
    play_beep 150 0.5
}

# Level up sound
level_up_sound() {
    notify-send "⬆️ Level Up!" "You are now a Hyprland Master!" -i dialog-information -t 5000
    play_beep 523 0.2  # C5
    sleep 0.1
    play_beep 659 0.2  # E5
    sleep 0.1
    play_beep 784 0.2  # G5
    sleep 0.1
    play_beep 1047 0.4 # C6
}

# Matrix sound effect
matrix_sound() {
    notify-send "🕶️ Welcome to the Matrix" "Follow the white rabbit..." -i dialog-information -t 3000
    for i in {1..5}; do
        play_beep $((200 + i*50)) 0.1
        sleep 0.05
    done
}

# Celebration sound
celebration_sound() {
    notify-send "🎊 Congratulations!" "Your Nord rice is complete!" -i dialog-information -t 5000
    # Play a simple melody
    play_beep 523 0.2  # C
    sleep 0.1
    play_beep 587 0.2  # D
    sleep 0.1
    play_beep 659 0.2  # E
    sleep 0.1
    play_beep 698 0.2  # F
    sleep 0.1
    play_beep 784 0.4  # G
}

# Startup sound
startup_sound() {
    notify-send "❄️ Nord Hyprland" "Welcome back to your arctic paradise!" -i dialog-information -t 3000
    play_beep 440 0.1
    sleep 0.05
    play_beep 554 0.1
    sleep 0.05
    play_beep 659 0.2
}

# Main function
main() {
    # Check for audio capabilities
    check_audio_tools

    case "$1" in
        "success")
            success_sound
            ;;
        "error")
            error_sound
            ;;
        "levelup")
            level_up_sound
            ;;
        "matrix")
            matrix_sound
            ;;
        "celebrate")
            celebration_sound
            ;;
        "startup")
            startup_sound
            ;;
        "test")
            echo "Testing all sounds..."
            success_sound
            sleep 1
            error_sound
            sleep 1
            level_up_sound
            sleep 1
            matrix_sound
            sleep 1
            celebration_sound
            ;;
        *)
            echo "Usage: $0 {success|error|levelup|matrix|celebrate|startup|test}"
            echo "Available audio tool: $AUDIO_TOOL"
            ;;
    esac
}

# Run main function
main "$@"
