#!/usr/bin/env bash

# Settings Menu for Niri + NixOS
# Usage: settings-menu.sh

# Function to show audio settings
audio_menu() {
    local options=(
        "🔊 Volume Control (pavucontrol)"
        "🎵 Audio Devices"
        "🔇 Toggle Mute"
        "📢 Increase Volume (+5%)"
        "📉 Decrease Volume (-5%)"
    )
    
    local choice
    choice=$(printf '%s\n' "${options[@]}" | fuzzel --dmenu --prompt="Audio Settings: " --width=40 --lines=6)
    
    case "$choice" in
        *"Volume Control"*) pavucontrol & ;;
        *"Audio Devices"*) 
            pactl list sinks short | fuzzel --dmenu --prompt="Audio Devices: " --width=60
            ;;
        *"Toggle Mute"*) 
            pactl set-sink-mute @DEFAULT_SINK@ toggle
            notify-send "Audio" "Audio mute toggled" -i "audio-volume-muted"
            ;;
        *"Increase Volume"*) 
            pactl set-sink-volume @DEFAULT_SINK@ +5%
            notify-send "Audio" "Volume increased" -i "audio-volume-high"
            ;;
        *"Decrease Volume"*) 
            pactl set-sink-volume @DEFAULT_SINK@ -5%
            notify-send "Audio" "Volume decreased" -i "audio-volume-low"
            ;;
    esac
}

# Function to show display settings
display_menu() {
    local options=(
        "🖥️ Display Configuration"
        "💡 Brightness Control"
        "🌅 Night Light Settings"
        "🔆 Increase Brightness (+10%)"
        "🔅 Decrease Brightness (-10%)"
    )
    
    local choice
    choice=$(printf '%s\n' "${options[@]}" | fuzzel --dmenu --prompt="Display Settings: " --width=40 --lines=6)
    
    case "$choice" in
        *"Display Configuration"*) 
            notify-send "Settings" "Edit ~/.config/niri/config.kdl for display settings" -i "preferences-desktop-display"
            ghostty -e nvim ~/.config/niri/config.kdl &
            ;;
        *"Brightness Control"*) 
            local current=$(brightnessctl get)
            local max=$(brightnessctl max)
            local percent=$((current * 100 / max))
            notify-send "Brightness" "Current: ${percent}%" -i "display-brightness"
            ;;
        *"Night Light Settings"*) ~/.config/niri/scripts/system-controls.sh ;;
        *"Increase Brightness"*) 
            brightnessctl set +10%
            notify-send "Brightness" "Brightness increased" -i "display-brightness"
            ;;
        *"Decrease Brightness"*) 
            brightnessctl set 10%-
            notify-send "Brightness" "Brightness decreased" -i "display-brightness"
            ;;
    esac
}

# Function to show network settings
network_menu() {
    local options=(
        "📶 WiFi Networks"
        "🔵 Bluetooth Devices"
        "🌐 Network Manager"
        "📡 Toggle WiFi"
        "🔵 Toggle Bluetooth"
    )
    
    local choice
    choice=$(printf '%s\n' "${options[@]}" | fuzzel --dmenu --prompt="Network Settings: " --width=40 --lines=6)
    
    case "$choice" in
        *"WiFi Networks"*) 
            nmcli device wifi list | fuzzel --dmenu --prompt="WiFi Networks: " --width=60
            ;;
        *"Bluetooth Devices"*) 
            bluetoothctl devices | fuzzel --dmenu --prompt="Bluetooth Devices: " --width=60
            ;;
        *"Network Manager"*) nm-connection-editor & ;;
        *"Toggle WiFi"*) ~/.config/niri/scripts/system-controls.sh ;;
        *"Toggle Bluetooth"*) ~/.config/niri/scripts/system-controls.sh ;;
    esac
}

# Function to show system info
system_info() {
    local info=(
        "💻 $(uname -n)"
        "🐧 $(uname -r)"
        "⚡ $(uptime -p)"
        "💾 $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
        "💽 $(df -h / | awk 'NR==2 {print $3 "/" $2}')"
        "🌡️ $(sensors 2>/dev/null | grep -E 'Core|temp' | head -1 | awk '{print $3}' || echo 'N/A')"
    )
    
    printf '%s\n' "${info[@]}" | fuzzel --dmenu --prompt="System Info: " --width=50 --lines=8
}

# Main settings menu
main_menu() {
    local options=(
        "🔊 Audio Settings"
        "🖥️ Display Settings"
        "📶 Network Settings"
        "⌨️ Input Settings"
        "🔔 Notification Settings"
        "🎨 Appearance"
        "ℹ️ System Information"
        "⚙️ Edit Niri Config"
        "🏠 Edit Home Config"
        "🔧 System Settings (GUI)"
    )
    
    local choice
    choice=$(printf '%s\n' "${options[@]}" | fuzzel --dmenu --prompt="Settings: " --width=40 --lines=10)
    
    case "$choice" in
        *"Audio Settings"*) audio_menu ;;
        *"Display Settings"*) display_menu ;;
        *"Network Settings"*) network_menu ;;
        *"Input Settings"*) 
            notify-send "Settings" "Configure input in Niri config" -i "preferences-desktop-keyboard"
            ghostty -e nvim ~/.config/niri/config.kdl &
            ;;
        *"Notification Settings"*) 
            ghostty -e nvim ~/.config/swaync/config.json &
            ;;
        *"Appearance"*) ~/.config/niri/scripts/theme-menu.sh ;;
        *"System Information"*) system_info ;;
        *"Edit Niri Config"*) ghostty -e nvim ~/.config/niri/config.kdl & ;;
        *"Edit Home Config"*) ghostty -e nvim /home/abbes/nixverse/hosts/workstation/home.nix & ;;
        *"System Settings"*) 
            if command -v gnome-control-center >/dev/null; then
                gnome-control-center &
            else
                notify-send "Settings" "No GUI settings app available" -i "dialog-information"
            fi
            ;;
    esac
}

# Run the main menu
main_menu
