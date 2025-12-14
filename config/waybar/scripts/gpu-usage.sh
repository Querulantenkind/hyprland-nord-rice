#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                      GPU USAGE WIDGET - NORD THEME                        ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
#
# Shows GPU usage for NVIDIA or AMD GPUs

# Try NVIDIA first
if command -v nvidia-smi &> /dev/null; then
    # NVIDIA GPU
    gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -1)
    gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -1)
    gpu_mem_used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits 2>/dev/null | head -1)
    gpu_mem_total=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null | head -1)
    gpu_name=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)
    gpu_power=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits 2>/dev/null | head -1)
    
    if [ -n "$gpu_usage" ]; then
        # Determine class based on usage
        if [ "$gpu_usage" -gt 80 ]; then
            class="critical"
        elif [ "$gpu_usage" -gt 50 ]; then
            class="warning"
        else
            class="normal"
        fi
        
        tooltip="$gpu_name\n"
        tooltip+="Usage: ${gpu_usage}%\n"
        tooltip+="Temperature: ${gpu_temp}°C\n"
        tooltip+="Memory: ${gpu_mem_used}MB / ${gpu_mem_total}MB\n"
        tooltip+="Power: ${gpu_power}W"
        
        echo "{\"text\": \"${gpu_usage}%\", \"tooltip\": \"$tooltip\", \"class\": \"$class\"}"
        exit 0
    fi
fi

# Try AMD (using radeontop or /sys)
if [ -f /sys/class/drm/card0/device/gpu_busy_percent ]; then
    gpu_usage=$(cat /sys/class/drm/card0/device/gpu_busy_percent 2>/dev/null)
    gpu_temp=$(cat /sys/class/drm/card0/device/hwmon/hwmon*/temp1_input 2>/dev/null | head -1)
    
    if [ -n "$gpu_temp" ]; then
        gpu_temp=$((gpu_temp / 1000))
    fi
    
    if [ -n "$gpu_usage" ]; then
        if [ "$gpu_usage" -gt 80 ]; then
            class="critical"
        elif [ "$gpu_usage" -gt 50 ]; then
            class="warning"
        else
            class="normal"
        fi
        
        tooltip="AMD GPU\n"
        tooltip+="Usage: ${gpu_usage}%\n"
        [ -n "$gpu_temp" ] && tooltip+="Temperature: ${gpu_temp}°C"
        
        echo "{\"text\": \"${gpu_usage}%\", \"tooltip\": \"$tooltip\", \"class\": \"$class\"}"
        exit 0
    fi
fi

# Try Intel integrated GPU
if [ -d /sys/class/drm/card0/gt ]; then
    # Intel GPU metrics if available
    echo '{"text": "", "tooltip": "Intel iGPU", "class": "normal"}'
    exit 0
fi

# No GPU found or not accessible
echo '{"text": "", "tooltip": "No GPU info available", "class": "unavailable"}'

