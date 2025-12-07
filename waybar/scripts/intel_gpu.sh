#!/bin/bash

model="Intel Iris Xe"

# --- TEMP ---
temp_file=$(find /sys/class/thermal -name "temp" | head -n1)
if [ -f "$temp_file" ]; then
    temp=$(( $(cat "$temp_file") / 1000 ))
else
    temp="N/A"
fi

# --- GPU USAGE via intel_gpu_top ---
if command -v intel_gpu_top &>/dev/null; then
    usage=$(intel_gpu_top -J -l 1 2>/dev/null | grep '"Busy"' | awk -F: '{gsub(/[", ]/,"",$2); print int($2)}')
    if [ -z "$usage" ]; then
        usage="0"
    fi
else
    usage="0"
fi

# --- TOOLTIP ---
tooltip="GPU: $model\\nUtilization: ${usage}%\\nTemperature: ${temp}°C"

# --- OUTPUT ---
printf '{"text": " %s%%", "tooltip": "%s"}' "$usage" "$tooltip"
