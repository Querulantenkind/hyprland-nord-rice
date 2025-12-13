#!/bin/bash

# System monitor script for Waybar
# Shows CPU, RAM, and Disk usage

# Get CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

# Get RAM usage
RAM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
RAM_USED=$(free -h | grep Mem | awk '{print $3}')
RAM_PERCENT=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')

# Get Disk usage
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')

# Create notification with system info
notify-send "System Monitor" \
"CPU: ${CPU_USAGE}%\nRAM: ${RAM_USED}/${RAM_TOTAL} (${RAM_PERCENT}%)\nDisk: ${DISK_USAGE}%" \
-t 5000 \
-a "system-monitor"
