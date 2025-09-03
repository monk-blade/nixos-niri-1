#!/usr/bin/env bash

# Window switcher using niri and fuzzel
# Shows all open windows and allows quick switching

# Get all windows from niri
WINDOWS=$(niri msg windows | jq -r '.[] | "\(.title) - \(.app_id) (\(.id))"')

if [ -z "$WINDOWS" ]; then
    notify-send "Window Switcher" "No windows open"
    exit 0
fi

# Show window list in fuzzel
SELECTION=$(echo "$WINDOWS" | fuzzel --dmenu --prompt="Switch to: " --width=60)

if [ -n "$SELECTION" ]; then
    # Extract window ID from selection (last part in parentheses)
    WINDOW_ID=$(echo "$SELECTION" | grep -o '([0-9]*)' | tr -d '()')
    
    if [ -n "$WINDOW_ID" ]; then
        # Focus the selected window
        niri msg action focus-window --id="$WINDOW_ID"
    fi
fi
