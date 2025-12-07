#!/bin/bash

# Check if NVIDIA GPU exists and nvidia-smi works
if ! command -v nvidia-smi &>/dev/null; then
    exit 0   # Exit silently, module won't show
fi

# Test if nvidia-smi returns valid output
if ! nvidia-smi &>/dev/null; then
    exit 0   # Exit silently
fi

# ---------- GPU STATS ----------
util=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | tr -d ' ')
temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits | tr -d ' ')
mem_used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits | tr -d ' ')
mem_total=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | tr -d ' ')
name=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader | tr -d '"')

# ---------- TOOLTIP ----------
tooltip="Model: ${name}\\nUtilization: ${util}%\\nTemperature: ${temp}°C\\nMemory: ${mem_used}/${mem_total} MB"

# ---------- OUTPUT ----------
printf '{"text": " %s%% | %s°C", "tooltip": "%s"}' "$util" "$temp" "$tooltip"
