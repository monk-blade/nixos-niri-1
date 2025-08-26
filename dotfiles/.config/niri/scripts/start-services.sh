#!/usr/bin/env bash
# Manual script to start essential services in VM environment

echo "Starting SwayNC notification daemon..."
if ! pgrep -x "swaync" > /dev/null; then
    swaync &
    echo "✓ SwayNC started"
else
    echo "✓ SwayNC already running"
fi

echo "Starting wallpaper daemon and setting wallpaper..."
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 1
    echo "✓ swww daemon started"
else
    echo "✓ swww daemon already running"
fi

# Set wallpaper
WALLPAPER="$HOME/.config/backgrounds/snaky.jpg"
if [ -f "$WALLPAPER" ]; then
    swww img "$WALLPAPER"
    echo "✓ Wallpaper set to $WALLPAPER"
else
    echo "⚠ Wallpaper file not found: $WALLPAPER"
fi

echo "All services started!"
