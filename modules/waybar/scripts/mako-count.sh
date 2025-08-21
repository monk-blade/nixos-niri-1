#!/bin/bash

# Check if mako is running
if ! pgrep -x "mako" > /dev/null; then
    echo '{"text": "!", "tooltip": "Mako not running", "class": "mako-not-running"}'
    exit 0
fi

# Get notification count from mako
count=$(makoctl list 2>/dev/null | jq length 2>/dev/null)

# Handle errors or empty responses
if [ -z "$count" ] || [ "$count" = "null" ] || ! [[ "$count" =~ ^[0-9]+$ ]]; then
    count=0
fi

# Output for waybar
if [ "$count" -eq 0 ]; then
    echo '{"text": "", "tooltip": "No notifications", "class": "empty"}'
else
    echo "{\"text\": \"$count\", \"tooltip\": \"$count notification(s)\", \"class\": \"notifications\"}"
fi
