#!/usr/bin/env bash

# Power menu options
options="🔒 Lock\n🚪 Logout\n💤 Suspend\n🔄 Reboot\n⚡ Shutdown"

# Show fuzzel menu and get selection
selected=$(echo -e "$options" | fuzzel --dmenu --prompt="Power: " --width=30 --lines=5)

case $selected in
    "🔒 Lock")
        hyprlock
        ;;
    "🚪 Logout")
        niri msg action quit
        ;;
    "💤 Suspend")
        systemctl suspend
        ;;
    "🔄 Reboot")
        systemctl reboot
        ;;
    "⚡ Shutdown")
        systemctl poweroff
        ;;
esac
