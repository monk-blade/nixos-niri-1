#!/bin/bash

# Get the count of notifications from mako
count=$(makoctl list | jq length 2>/dev/null || echo 0)

# Check if mako is running
if ! pgrep -x "mako" > /dev/null; then
    echo "󰂛"
    exit 0
fi

# Display notification icon with count
if [ "$count" -gt 0 ]; then
    if [ "$count" -gt 9 ]; then
        echo "󰂚 9+"
    else
        echo "󰂚 $count"
    fi
else
    echo "󰂜"
fi
