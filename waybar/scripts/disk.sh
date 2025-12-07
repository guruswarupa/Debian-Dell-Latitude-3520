#!/bin/bash

# Use df with POSIX output for speed
disk_info=$(df -hP / | awk 'NR==2 {print $1, $2, $3, $4, $5, $6}')

read fs size used avail usep mount <<< "$disk_info"

# Remove % sign for numeric display
use_num=$(echo "$usep" | tr -d '%')

# Tooltip (escaped newlines for JSON)
tooltip="Filesystem: $fs\\nSize: $size\\nUsed: $used\\nAvailable: $avail\\nUsage: $usep\\nMount: $mount"

printf '{"text": "  %s%%", "tooltip": "%s"}' "$use_num" "$tooltip"
