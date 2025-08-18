#!/bin/bash

# Get the count of notifications from mako
count=$(makoctl list | jq length 2>/dev/null || echo 0)

# Display notification icon with count
if [ "$count" -gt 0 ]; then
    echo " $count"
else
    echo ""
fi
