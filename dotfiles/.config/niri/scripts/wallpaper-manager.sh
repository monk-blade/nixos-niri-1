#!/bin/bash

# Wallpaper Manager for Niri
# Handles wallpaper setup for both single and dual monitor configurations

WALLPAPER_PATH="$HOME/.config/backgrounds/snaky.jpg"
LOG_FILE="/tmp/wallpaper-manager.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

setup_wallpaper() {
    log "Setting up wallpaper..."
    
    # Kill any existing swww daemon
    pkill swww-daemon 2>/dev/null
    sleep 0.2
    
    # Start swww daemon
    swww-daemon &
    sleep 0.5
    
    # Apply wallpaper to all outputs
    swww img "$WALLPAPER_PATH" --transition-type any --transition-fps 60 --transition-duration 2
    
    log "Wallpaper applied successfully"
}

monitor_displays() {
    log "Starting display monitor..."
    
    # Monitor for display changes using niri msg
    while true do
        # Get current outputs
        current_outputs=$(niri msg outputs 2>/dev/null | grep -E "^Output" | wc -l)
        
        if [ "$current_outputs" != "$previous_outputs" ]; then
            log "Display configuration changed (outputs: $current_outputs)"
            sleep 1  # Wait for display to stabilize
            setup_wallpaper
            previous_outputs=$current_outputs
        fi
        
        sleep 2
    done
}

# Initial setup
setup_wallpaper

# Get initial output count
previous_outputs=$(niri msg outputs 2>/dev/null | grep -E "^Output" | wc -l)

# Start monitoring in background
monitor_displays &

log "Wallpaper manager started (PID: $$)"
