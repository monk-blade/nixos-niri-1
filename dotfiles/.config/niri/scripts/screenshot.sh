#!/usr/bin/env bash

# Screenshot script for Niri
# Usage: screenshot.sh [area|window|screen]

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

case "${1:-area}" in
    "area")
        # Select area and screenshot
        grim -g "$(slurp)" "$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
        notify-send "Screenshot" "Area screenshot saved"
        ;;
    "window")
        # Screenshot focused window
        grim -g "$(niri msg focused-window | jq -r '.geometry | "\(.x),\(.y) \(.width)x\(.height)"')" "$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
        notify-send "Screenshot" "Window screenshot saved"
        ;;
    "screen")
        # Full screen screenshot
        grim "$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
        notify-send "Screenshot" "Screen screenshot saved"
        ;;
    *)
        echo "Usage: $0 [area|window|screen]"
        exit 1
        ;;
esac
