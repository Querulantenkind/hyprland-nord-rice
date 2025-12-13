#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                     PARTICLE EFFECTS SCRIPT - NORD THEME                   ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Configuration
SCREEN_WIDTH=$(xrandr | grep '*' | awk '{print $1}' | cut -d'x' -f1 | head -1)
SCREEN_HEIGHT=$(xrandr | grep '*' | awk '{print $1}' | cut -d'x' -f2 | head -1)
FPS=30
DURATION=10  # Default duration in seconds

# Nord Colors (matching theme)
NORD8="#88c0d0"      # Frost blue
NORD9="#81a1c1"      # Frost blue-gray
NORD7="#8fbcbb"      # Frost cyan
NORD14="#a3be8c"     # Aurora green
NORD13="#ebcb8b"     # Aurora yellow
NORD11="#bf616a"     # Aurora red
NORD15="#b48ead"     # Aurora purple

# Particle types
declare -A PARTICLE_TYPES=(
    ["snow"]="snowflake"
    ["aurora"]="aurora"
    ["stars"]="star"
    ["hearts"]="heart"
    ["confetti"]="confetti"
)

# Snow particle system
snow_effect() {
    local particle_count=50
    local duration=${1:-$DURATION}

    echo "Starting Snow Effect..."

    # Create temporary script for snow animation
    cat > /tmp/snow_particles.sh << 'EOF'
#!/bin/bash
SCREEN_WIDTH=$1
SCREEN_HEIGHT=$2
FPS=$3
DURATION=$4

# Colors
SNOW_COLORS=("#ffffff" "#e5e9f0" "#d8dee9" "#eceff4")

# Particle array [x,y,fall_speed,size,color_index]
particles=()
for ((i=0; i<50; i++)); do
    x=$((RANDOM % SCREEN_WIDTH))
    y=$((RANDOM % SCREEN_HEIGHT / 4))  # Start in top quarter
    fall_speed=$((RANDOM % 3 + 1))
    size=$((RANDOM % 3 + 1))
    color_index=$((RANDOM % 4))
    particles+=("$x,$y,$fall_speed,$size,$color_index")
done

frame=0
max_frames=$((FPS * DURATION))

while [ $frame -lt $max_frames ]; do
    clear

    # Update and draw particles
    for ((i=0; i<${#particles[@]}; i++)); do
        IFS=',' read -r x y fall_speed size color_index <<< "${particles[$i]}"

        # Update position
        y=$((y + fall_speed))

        # Reset if off screen
        if [ $y -gt $SCREEN_HEIGHT ]; then
            y=$((RANDOM % 50 - 50))  # Start above screen
            x=$((RANDOM % SCREEN_WIDTH))
            fall_speed=$((RANDOM % 3 + 1))
        fi

        # Draw particle
        color="${SNOW_COLORS[$color_index]}"
        case $size in
            1) symbol="·" ;;
            2) symbol="*" ;;
            3) symbol="❄" ;;
        esac

        # Position cursor and draw
        echo -ne "\033[${y};${x}H\033[38;2;$(printf "%d;%d;%d" 0x${color:1:2} 0x${color:3:2} 0x${color:5:2})m${symbol}\033[0m"

        # Update particle data
        particles[$i]="$x,$y,$fall_speed,$size,$color_index"
    done

    frame=$((frame + 1))
    sleep $(echo "scale=4; 1/$FPS" | bc)
done
EOF

    chmod +x /tmp/snow_particles.sh
    /tmp/snow_particles.sh "$SCREEN_WIDTH" "$SCREEN_HEIGHT" "$FPS" "$duration"
    rm /tmp/snow_particles.sh
}

# Aurora particle system
aurora_effect() {
    local duration=${1:-$DURATION}

    echo "Starting Aurora Effect..."

    cat > /tmp/aurora_particles.sh << 'EOF'
#!/bin/bash
SCREEN_WIDTH=$1
SCREEN_HEIGHT=$2
FPS=$3
DURATION=$4

# Aurora colors (Nord Aurora palette)
AURORA_COLORS=("#bf616a" "#d08770" "#ebcb8b" "#a3be8c" "#b48ead")

# Wave parameters
waves=()
for ((i=0; i<5; i++)); do
    amplitude=$((RANDOM % 20 + 10))
    frequency=$((RANDOM % 10 + 5))
    speed=$((RANDOM % 3 + 1))
    y_offset=$((i * 30 + 50))
    color_index=$i
    waves+=("$amplitude,$frequency,$speed,$y_offset,$color_index")
done

frame=0
max_frames=$((FPS * DURATION))

while [ $frame -lt $max_frames ]; do
    clear

    # Draw aurora waves
    for ((i=0; i<${#waves[@]}; i++)); do
        IFS=',' read -r amplitude frequency speed y_offset color_index <<< "${waves[$i]}"

        # Calculate wave
        for ((x=0; x<SCREEN_WIDTH; x+=2)); do
            # Sine wave with time-based movement
            time_offset=$((frame * speed))
            y_wave=$((y_offset + amplitude * $(echo "scale=2; s($((x * frequency + time_offset)) / 10)" | bc -l | sed 's/\..*//') 2>/dev/null || echo 0))

            # Only draw if within screen bounds
            if [ $y_wave -ge 0 ] && [ $y_wave -lt $SCREEN_HEIGHT ]; then
                color="${AURORA_COLORS[$color_index]}"
                echo -ne "\033[${y_wave};${x}H\033[38;2;$(printf "%d;%d;%d" 0x${color:1:2} 0x${color:3:2} 0x${color:5:2})m~\033[0m"
            fi
        done
    done

    frame=$((frame + 1))
    sleep $(echo "scale=4; 1/$FPS" | bc)
done
EOF

    chmod +x /tmp/aurora_particles.sh
    /tmp/aurora_particles.sh "$SCREEN_WIDTH" "$SCREEN_HEIGHT" "$FPS" "$duration"
    rm /tmp/aurora_particles.sh
}

# Star field effect
stars_effect() {
    local particle_count=100
    local duration=${1:-$DURATION}

    echo "Starting Star Field Effect..."

    cat > /tmp/star_particles.sh << 'EOF'
#!/bin/bash
SCREEN_WIDTH=$1
SCREEN_HEIGHT=$2
FPS=$3
DURATION=$4

# Star colors
STAR_COLORS=("#ffffff" "#e5e9f0" "#d8dee9" "#81a1c1" "#88c0d0")

# Stars array [x,y,brightness,twinkle_speed]
stars=()
for ((i=0; i<100; i++)); do
    x=$((RANDOM % SCREEN_WIDTH))
    y=$((RANDOM % SCREEN_HEIGHT))
    brightness=$((RANDOM % 5 + 1))
    twinkle_speed=$((RANDOM % 3 + 1))
    stars+=("$x,$y,$brightness,$twinkle_speed")
done

frame=0
max_frames=$((FPS * DURATION))

while [ $frame -lt $max_frames ]; do
    clear

    # Draw stars
    for ((i=0; i<${#stars[@]}; i++)); do
        IFS=',' read -r x y brightness twinkle_speed <<< "${stars[$i]}"

        # Calculate twinkle effect
        twinkle=$(( (frame * twinkle_speed) % 10 ))
        if [ $twinkle -lt 5 ]; then
            current_brightness=$brightness
        else
            current_brightness=$((brightness / 2))
        fi

        # Get color based on brightness
        color_index=$((current_brightness - 1))
        if [ $color_index -lt 0 ]; then color_index=0; fi
        if [ $color_index -ge 5 ]; then color_index=4; fi
        color="${STAR_COLORS[$color_index]}"

        # Draw star
        symbol="✦"
        echo -ne "\033[${y};${x}H\033[38;2;$(printf "%d;%d;%d" 0x${color:1:2} 0x${color:3:2} 0x${color:5:2})m${symbol}\033[0m"
    done

    frame=$((frame + 1))
    sleep $(echo "scale=4; 1/$FPS" | bc)
done
EOF

    chmod +x /tmp/star_particles.sh
    /tmp/star_particles.sh "$SCREEN_WIDTH" "$SCREEN_HEIGHT" "$FPS" "$duration"
    rm /tmp/star_particles.sh
}

# Success particles effect
success_effect() {
    local duration=${1:-3}

    echo "Starting Success Effect..."

    cat > /tmp/success_particles.sh << 'EOF'
#!/bin/bash
SCREEN_WIDTH=$1
SCREEN_HEIGHT=$2
FPS=$3
DURATION=$4

# Success colors (green theme)
SUCCESS_COLORS=("#a3be8c" "#ebcb8b" "#88c0d0")

# Particle array [x,y,vx,vy,lifetime,color]
particles=()

# Create burst of particles
for ((i=0; i<30; i++)); do
    # Start from center
    center_x=$((SCREEN_WIDTH / 2))
    center_y=$((SCREEN_HEIGHT / 2))

    # Random velocity
    angle=$((RANDOM % 360))
    speed=$((RANDOM % 5 + 2))
    vx=$(echo "scale=2; $speed * c($angle * 3.14159 / 180)" | bc -l | sed 's/\..*//')
    vy=$(echo "scale=2; $speed * s($angle * 3.14159 / 180)" | bc -l | sed 's/\..*//')

    lifetime=$((RANDOM % 60 + 30))  # 1-3 seconds at 30fps
    color_index=$((RANDOM % 3))

    particles+=("$center_x,$center_y,$vx,$vy,$lifetime,$color_index")
done

frame=0
max_frames=$((FPS * DURATION))

while [ $frame -lt $max_frames ] && [ ${#particles[@]} -gt 0 ]; do
    clear

    # Update and draw particles
    new_particles=()
    for ((i=0; i<${#particles[@]}; i++)); do
        IFS=',' read -r x y vx vy lifetime color_index <<< "${particles[$i]}"

        # Update position
        x=$((x + vx))
        y=$((y + vy))

        # Apply gravity
        vy=$((vy + 1))

        # Decrease lifetime
        lifetime=$((lifetime - 1))

        # Skip if off screen or dead
        if [ $lifetime -le 0 ] || [ $x -lt 0 ] || [ $x -gt $SCREEN_WIDTH ] || [ $y -gt $SCREEN_HEIGHT ]; then
            continue
        fi

        # Draw particle
        color="${SUCCESS_COLORS[$color_index]}"
        symbol="✦"
        echo -ne "\033[${y};${x}H\033[38;2;$(printf "%d;%d;%d" 0x${color:1:2} 0x${color:3:2} 0x${color:5:2})m${symbol}\033[0m"

        # Keep particle alive
        new_particles+=("$x,$y,$vx,$vy,$lifetime,$color_index")
    done

    particles=("${new_particles[@]}")
    frame=$((frame + 1))
    sleep $(echo "scale=4; 1/$FPS" | bc)
done
EOF

    chmod +x /tmp/success_particles.sh
    /tmp/success_particles.sh "$SCREEN_WIDTH" "$SCREEN_HEIGHT" "$FPS" "$duration"
    rm /tmp/success_particles.sh
}

# Main function
main() {
    case "$1" in
        "snow"|"aurora"|"stars"|"success")
            local duration=${2:-$DURATION}
            case "$1" in
                "snow") snow_effect "$duration" ;;
                "aurora") aurora_effect "$duration" ;;
                "stars") stars_effect "$duration" ;;
                "success") success_effect "$duration" ;;
            esac
            ;;
        "random")
            local effects=("snow" "aurora" "stars")
            local random_effect=${effects[$((RANDOM % ${#effects[@]}))]}
            echo "Playing random effect: $random_effect"
            main "$random_effect"
            ;;
        "stop")
            # Kill any running particle effects
            pkill -f "particle.*\.sh"
            echo "Particle effects stopped"
            ;;
        *)
            echo "Usage: $0 {snow|aurora|stars|success|random|stop} [duration]"
            echo "  snow    - Snowflakes falling effect"
            echo "  aurora  - Aurora borealis wave effect"
            echo "  stars   - Twinkling star field"
            echo "  success - Success particle burst"
            echo "  random  - Random effect"
            echo "  stop    - Stop all effects"
            echo ""
            echo "Examples:"
            echo "  $0 snow 15        # Snow for 15 seconds"
            echo "  $0 aurora         # Aurora with default duration"
            echo "  $0 success 5      # Success burst for 5 seconds"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"

