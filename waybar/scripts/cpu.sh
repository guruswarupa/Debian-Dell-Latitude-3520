#!/bin/bash

# --- CPU MODEL ---
model=$(lscpu | grep "Model name" | sed 's/Model name:\s*//')

# --- CPU CORES / THREADS ---
cores=$(nproc --all)
threads=$(lscpu | awk -F: '/Thread\(s\) per core/ {gsub(/ /,"",$2); print $2}')

# --- CPU TEMP ---
temp="N/A"
for zone in /sys/class/thermal/thermal_zone*/temp; do
    if [ -f "$zone" ]; then
        raw=$(cat "$zone")
        if [ "$raw" -gt 0 ]; then
            temp=$((raw / 1000))
            break
        fi
    fi
done

# --- TOTAL CPU USAGE ---
cpu_idle=$(awk -v RS="" '{print $0}' /proc/stat | awk '/cpu / {print $5}')
sleep 0.1
cpu_idle2=$(awk -v RS="" '{print $0}' /proc/stat | awk '/cpu / {print $5}')

cpu_total=$(awk -v RS="" '{print $0}' /proc/stat | awk '/cpu / {print $2+$3+$4+$5+$6+$7+$8}')
sleep 0.1
cpu_total2=$(awk -v RS="" '{print $0}' /proc/stat | awk '/cpu / {print $2+$3+$4+$5+$6+$7+$8}')

idle_diff=$((cpu_idle2 - cpu_idle))
total_diff=$((cpu_total2 - cpu_total))

usage=$((100 * (total_diff - idle_diff) / total_diff))

# --- Tooltip ---
tooltip="CPU: $model\\nCores: $cores\\nThreads per Core: $threads\\nTemp: ${temp}°C\\nUsage: ${usage}%"

# --- Output ---
printf '{"text": "  %s%%", "tooltip": "%s"}' "$usage" "$tooltip"
