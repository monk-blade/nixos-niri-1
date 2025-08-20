#!/bin/bash

# Get notification count from mako
count=$(makoctl list | jq length 2>/dev/null)

if [ -z "$count" ] || [ "$count" = "null" ]; then
    count=0
fi

# Output for waybar
if [ "$count" -eq 0 ]; then
    echo '{"text": "", "tooltip": "No notifications", "class": "empty"}'
else
    echo "{\"text\": \"$count\", \"tooltip\": \"$count notification(s)\", \"class\": \"notifications\"}"
fi
