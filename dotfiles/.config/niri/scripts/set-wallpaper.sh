#!/usr/bin/env bash

# Script to set wallpaper using swww
# This script sets the wallpaper from the configured path

# Default wallpaper path (can be overridden by environment variable)
WALLPAPER_PATH="${WALLPAPER_PATH:-/home/abbes/nixverse/dotfiles/.config/backgrounds/texture.jpg}"

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting wallpaper setup..."

# Wait a bit for the compositor to be ready
sleep 3

# Check if swww daemon is running, if not start it
if ! pgrep -x "swww-daemon" > /dev/null; then
    log "Starting swww daemon..."
    swww-daemon &
    sleep 3
else
    log "swww daemon already running"
fi

# Verify swww daemon is responding
for i in {1..10}; do
    if swww query &>/dev/null; then
        log "swww daemon is ready"
        break
    fi
    log "Waiting for swww daemon to be ready... (attempt $i/10)"
    sleep 1
done

# Set the wallpaper
if [ -f "$WALLPAPER_PATH" ]; then
    log "Setting wallpaper: $WALLPAPER_PATH"
    if swww img "$WALLPAPER_PATH" --transition-type fade --transition-duration 1; then
        log "Wallpaper set successfully"
    else
        log "Error: Failed to set wallpaper"
    fi
else
    log "Error: Wallpaper file not found at $WALLPAPER_PATH"
fi
