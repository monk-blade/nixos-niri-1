#!/usr/bin/env bash
# wallpaper-setup.sh - Script to handle dual wallpaper setup for niri

# Configuration - adjust paths as needed
WORKSPACE_WALLPAPER="$HOME/.config/backgrounds/snaky.jpg"
BACKDROP_WALLPAPER="$HOME/.config/backgrounds/blurry-snaky.jpg"

# Wait a moment for the compositor to be ready
sleep 0.5

# Start backdrop wallpaper (swaybg for overview)
swaybg -i "$BACKDROP_WALLPAPER" -m fill &
SWAYBG_PID=$!

# Wait a moment
sleep 0.5

# Start swww daemon
swww-daemon --format xrgb &
SWWW_PID=$!

# Wait for swww daemon to be ready
sleep 1

# Set workspace wallpaper
swww img "$WORKSPACE_WALLPAPER" --transition-type wipe --transition-duration 0.5

# Optional: log the PIDs for debugging
echo "Wallpaper setup complete. swaybg PID: $SWAYBG_PID, swww PID: $SWWW_PID" >>~/.config/niri/wallpaper.log
