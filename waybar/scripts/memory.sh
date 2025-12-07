#!/bin/bash

mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
mem_available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
mem_used=$((mem_total - mem_available))

# Convert kB → GB
total_gb=$(awk "BEGIN {printf \"%.1f\", $mem_total/1024/1024}")
used_gb=$(awk "BEGIN {printf \"%.1f\", $mem_used/1024/1024}")
avail_gb=$(awk "BEGIN {printf \"%.1f\", $mem_available/1024/1024}")

percentage=$(awk "BEGIN {printf \"%d\", ($mem_used/$mem_total)*100}")

tooltip="Memory Usage\nUsed: ${used_gb} GB\nAvailable: ${avail_gb} GB\nTotal: ${total_gb} GB\nUsage: ${percentage}%"

printf '{"text": "󰍛 %sGB", "tooltip": "%s"}' "$used_gb" "$tooltip"
