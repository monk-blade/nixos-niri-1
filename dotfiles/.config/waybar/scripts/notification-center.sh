#!/bin/bash

# Notification Center Script for Mako
# Shows notification history in a user-friendly way

# Check if required tools are available
if ! command -v makoctl &> /dev/null; then
    notify-send "Error" "makoctl not found. Please install mako."
    exit 1
fi

if ! command -v jq &> /dev/null; then
    notify-send "Error" "jq not found. Please install jq for JSON parsing."
    exit 1
fi

# Function to show notification history
show_notification_history() {
    local notifications
    notifications=$(makoctl history)
    
    if [ -z "$notifications" ] || [ "$notifications" = "null" ]; then
        notify-send "Notification Center" "No notification history available."
        return
    fi
    
    # Parse and format notifications
    local formatted_history
    formatted_history=$(echo "$notifications" | jq -r '
        .data[0][] | 
        "🕒 " + (.timestamp | strftime("%H:%M")) + 
        " | " + .app_name + 
        "\n📝 " + .summary + 
        (if .body != "" then "\n💬 " + .body else "" end) + 
        "\n" + ("─" * 50) + "\n"
    ' 2>/dev/null)
    
    if [ -z "$formatted_history" ]; then
        notify-send "Notification Center" "No notifications in history."
        return
    fi
    
    # Show in terminal or notification
    if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
        # Try to show in a terminal window
        if command -v ghostty &> /dev/null; then
            echo "$formatted_history" | ghostty --title="Notification History" --command="sh -c 'cat; read -p \"Press Enter to close...\"'"
        elif command -v alacritty &> /dev/null; then
            echo "$formatted_history" | alacritty --title="Notification History" -e sh -c 'cat; read -p "Press Enter to close..."'
        elif command -v foot &> /dev/null; then
            echo "$formatted_history" | foot --title="Notification History" sh -c 'cat; read -p "Press Enter to close..."'
        else
            # Fallback: show in notification (limited but better than nothing)
            local short_history
            short_history=$(echo "$formatted_history" | head -n 20)
            notify-send -t 10000 "Notification History" "$short_history"
        fi
    else
        # Console mode
        echo "=== NOTIFICATION HISTORY ==="
        echo "$formatted_history"
        echo "==========================="
    fi
}

# Function to show current notifications
show_current_notifications() {
    local current_notifications
    current_notifications=$(makoctl list)
    
    if [ -z "$current_notifications" ] || [ "$current_notifications" = "[]" ]; then
        notify-send "Notification Center" "No current notifications."
        return
    fi
    
    local count
    count=$(echo "$current_notifications" | jq length)
    
    local formatted_current
    formatted_current=$(echo "$current_notifications" | jq -r '
        .[] | 
        "📱 " + .app_name + 
        "\n📝 " + .summary + 
        (if .body != "" then "\n💬 " + .body else "" end) + 
        "\n" + ("─" * 30) + "\n"
    ')
    
    notify-send -t 8000 "Current Notifications ($count)" "$formatted_current"
}

# Main logic
case "${1:-history}" in
    "current")
        show_current_notifications
        ;;
    "history"|*)
        show_notification_history
        ;;
esac
