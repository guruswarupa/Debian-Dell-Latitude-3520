#!/bin/bash

# Check if NVIDIA exists
if command -v nvidia-smi &> /dev/null; then
    # Only show memory + temperature if utilization is 0
    read -r util mem_used mem_total <<< $(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits | awk -F ', ' '{print $1,$2,$3}')

    if [[ "$util" -eq 0 ]]; then
        echo "NVIDIA: ${mem_used}/${mem_total}MB | Temp: $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)°C"
    else
        echo "NVIDIA: ${util}% | ${mem_used}/${mem_total}MB"
    fi
else
    echo "GPU info N/A"
fi
