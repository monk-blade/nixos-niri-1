#!/usr/bin/env bash

# Get notification count from mako
get_notification_count() {
    makoctl list | jq '.data[0] | length' 2>/dev/null || echo "0"
}

# Show notification history with fuzzel
show_notifications() {
    # Get notifications from mako
    notifications=$(makoctl list | jq -r '.data[0][] | "\(.summary.data // "No Title"): \(.body.data // "No Content")"' 2>/dev/null)
    
    if [ -z "$notifications" ]; then
        echo "No notifications" | fuzzel --dmenu --prompt="Notifications: " --width=60 --lines=1
        return
    fi
    
    # Add management options
    options="🗑️ Clear All Notifications
📋 Notification History
───────────────────────
$notifications"
    
    selected=$(echo -e "$options" | fuzzel --dmenu --prompt="Notifications: " --width=60 --lines=10)
    
    case "$selected" in
        "🗑️ Clear All Notifications")
            makoctl dismiss --all
            notify-send "Notifications" "All notifications cleared"
            ;;
        "📋 Notification History")
            # Show detailed history
            makoctl list | jq -r '.data[0][] | "Title: \(.summary.data // "No Title")\nBody: \(.body.data // "No Content")\nApp: \(.app_name.data // "Unknown")\nTime: \(.timestamp.data // "Unknown")\n───────────────────────"' | fuzzel --dmenu --prompt="History: " --width=80 --lines=15
            ;;
    esac
}

# Main logic
case "$1" in
    "count")
        get_notification_count
        ;;
    "show")
        show_notifications
        ;;
    *)
        # Default: return count for waybar
        count=$(get_notification_count)
        if [ "$count" -gt 0 ]; then
            echo "{\"text\": \"$count\", \"tooltip\": \"$count notifications\", \"class\": \"notifications\"}"
        else
            echo "{\"text\": \"\", \"tooltip\": \"No notifications\", \"class\": \"no-notifications\"}"
        fi
        ;;
esac
