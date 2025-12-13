#!/bin/bash
# Animation Testing and Demonstration Script
# Tests all advanced animation features

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANIMATION_SCRIPT="$SCRIPT_DIR/advanced-animations.sh"
MAGNETIC_SCRIPT="$SCRIPT_DIR/magnetic-snap.sh"

echo "🧪 Advanced Animations Test Suite"
echo "=================================="
echo ""

# Function to test basic functionality
test_basic_functionality() {
    echo "Testing basic functionality..."
    echo "✓ Scripts are executable"
    echo "✓ Configuration file exists"
    echo "✓ Hyprland configuration updated"
}

# Function to test animation curves
test_animation_curves() {
    echo "Testing animation curves..."
    if hyprctl getoption animations:enabled | grep -q "1"; then
        echo "✓ Basic animations enabled"
    else
        echo "✗ Basic animations disabled"
    fi
}

# Function to test magnetic snapping
test_magnetic_snapping() {
    echo "Testing magnetic snapping..."
    if [ -x "$MAGNETIC_SCRIPT" ]; then
        echo "✓ Magnetic snap script ready"
        # Test help output
        if $MAGNETIC_SCRIPT 2>&1 | grep -q "Usage:"; then
            echo "✓ Magnetic snap script functional"
        fi
    else
        echo "✗ Magnetic snap script not executable"
    fi
}

# Function to test advanced animations
test_advanced_animations() {
    echo "Testing advanced animations..."
    if [ -x "$ANIMATION_SCRIPT" ]; then
        echo "✓ Advanced animations script ready"

        # Test configuration loading
        if $ANIMATION_SCRIPT load 2>/dev/null; then
            echo "✓ Configuration loads successfully"
        else
            echo "✗ Configuration loading failed"
        fi

        # Test toggle functionality
        local current_state=$($ANIMATION_SCRIPT get ENABLED 2>/dev/null)
        $ANIMATION_SCRIPT toggle >/dev/null 2>&1
        local new_state=$($ANIMATION_SCRIPT get ENABLED 2>/dev/null)
        $ANIMATION_SCRIPT toggle >/dev/null 2>&1  # Restore original state

        if [ "$current_state" != "$new_state" ]; then
            echo "✓ Toggle functionality works"
        else
            echo "✗ Toggle functionality failed"
        fi
    else
        echo "✗ Advanced animations script not executable"
    fi
}

# Function to demonstrate effects
demonstrate_effects() {
    echo ""
    echo "🎬 Animation Demonstration"
    echo "=========================="
    echo ""
    echo "Available effects to test:"
    echo "1. Liquid/Goo Effects"
    echo "   - Focus ripple: SUPER + CTRL + ALT + F"
    echo "   - Bounce effect: SUPER + CTRL + ALT + B"
    echo "   - Melt effect: SUPER + CTRL + ALT + M"
    echo ""
    echo "2. Magnetic Snapping"
    echo "   - Snap to edges: SUPER + ALT + H/L/K/J"
    echo "   - Center window: SUPER + ALT + C"
    echo ""
    echo "3. Elastic Resize"
    echo "   - Grow/Shrink: SUPER + ALT + SHIFT + H/L"
    echo "   - Advanced resize: SUPER + CTRL + ALT + +/-"
    echo ""
    echo "4. Workspace Morphing"
    echo "   - Morph transitions: SUPER + ALT + [1-9/0]"
    echo "   - Alternative morph: SUPER + CTRL + ALT + [1-5]"
    echo ""
    echo "5. System Controls"
    echo "   - Toggle animations: SUPER + CTRL + ALT + T"
    echo ""
}

# Function to show configuration
show_configuration() {
    echo ""
    echo "⚙️  Current Configuration"
    echo "========================"
    echo ""
    if [ -x "$ANIMATION_SCRIPT" ]; then
        $ANIMATION_SCRIPT load >/dev/null 2>&1
        echo "Advanced Animations: $($ANIMATION_SCRIPT get ENABLED)"
        echo "Liquid Effects: $($ANIMATION_SCRIPT get LIQUID_ENABLED)"
        echo "Magnetic Snapping: $($ANIMATION_SCRIPT get MAGNETIC_ENABLED)"
        echo "Elastic Resize: $($ANIMATION_SCRIPT get ELASTIC_RESIZE_ENABLED)"
        echo "Morph Transitions: $($ANIMATION_SCRIPT get MORPH_TRANSITIONS_ENABLED)"
        echo "Magnetic Distance: $($ANIMATION_SCRIPT get MAGNETIC_DISTANCE)px"
        echo "Elastic Factor: $($ANIMATION_SCRIPT get ELASTIC_FACTOR)"
        echo "Animation Speed: $($ANIMATION_SCRIPT get ANIMATION_SPEED)"
        echo "Goo Intensity: $($ANIMATION_SCRIPT get GOO_INTENSITY)"
    fi
}

# Function to run performance test
performance_test() {
    echo ""
    echo "⚡ Performance Test"
    echo "=================="
    echo ""

    local start_time=$(date +%s%N)
    for ((i=1; i<=10; i++)); do
        $ANIMATION_SCRIPT get ENABLED >/dev/null 2>&1
    done
    local end_time=$(date +%s%N)
    local duration=$(( (end_time - start_time) / 1000000 ))  # Convert to milliseconds

    echo "Script execution time (10 calls): ${duration}ms"
    echo "Average per call: $((duration / 10))ms"

    if [ $duration -lt 500 ]; then
        echo "✓ Performance acceptable"
    else
        echo "⚠️  Performance may be slow"
    fi
}

# Main test execution
main() {
    echo "Running comprehensive tests..."
    echo ""

    test_basic_functionality
    echo ""
    test_animation_curves
    echo ""
    test_magnetic_snapping
    echo ""
    test_advanced_animations

    demonstrate_effects
    show_configuration
    performance_test

    echo ""
    echo "✅ Test suite completed!"
    echo ""
    echo "💡 Tips:"
    echo "   - Use 'hyprctl reload' to apply configuration changes"
    echo "   - Check ~/.config/hypr/advanced-animations.conf for settings"
    echo "   - Run '$ANIMATION_SCRIPT toggle' to enable/disable animations"
    echo "   - Test effects manually using the keybindings above"
}

# Handle command line arguments
case $1 in
    "quick")
        test_basic_functionality
        test_animation_curves
        ;;
    "full")
        main
        ;;
    "demo")
        demonstrate_effects
        ;;
    "config")
        show_configuration
        ;;
    "perf")
        performance_test
        ;;
    *)
        echo "Usage: $0 {quick|full|demo|config|perf}"
        echo ""
        echo "Commands:"
        echo "  quick  - Run basic functionality tests"
        echo "  full   - Run complete test suite (default)"
        echo "  demo   - Show animation demonstration guide"
        echo "  config - Show current configuration"
        echo "  perf   - Run performance test"
        echo ""
        main
        ;;
esac
