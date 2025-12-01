#!/usr/bin/env bash
# Wait until Hyprland signals it is fully ready
while ! hyprctl activewindow >/dev/null 2>&1; do
    sleep 0.1
done

# Start swww daemon if not already running
pgrep -x swww-daemon >/dev/null || swww-daemon &

# Set wallpaper
swww img /home/guru/Pictures/2025-Formula1-Red-Bull-Racing-RB21-001-2160.jpg
