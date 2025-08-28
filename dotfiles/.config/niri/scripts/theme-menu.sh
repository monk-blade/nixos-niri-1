#!/usr/bin/env bash

# Theme Menu for Niri + Stylix
# Usage: theme-menu.sh

STYLIX_CONFIG="/home/abbes/nixverse/hosts/workstation/stylix.nix"
LOCALS_CONFIG="/home/abbes/nixverse/hosts/workstation/locals.nix"

# Available themes (base16 schemes)
declare -A THEMES=(
    ["🌸 Tokyo Night"]="tokyo-night-dark"
    ["🐱 Catppuccin Mocha"]="catppuccin-mocha"
    ["🌲 Everforest"]="everforest"
    ["🟤 Gruvbox Dark"]="gruvbox-dark-hard"
    ["🌊 Kanagawa"]="kanagawa"
    ["🌙 Dracula"]="dracula"
    ["🔥 One Dark"]="onedark"
    ["🌺 Rose Pine"]="rose-pine"
    ["🌿 Nord"]="nord"
    ["⚡ Solarized Dark"]="solarized-dark"
    ["🎨 Material"]="material-darker"
)

# Function to get current theme
get_current_theme() {
    if [[ -f "$STYLIX_CONFIG" ]]; then
        local current=$(grep "base16Scheme.*=" "$STYLIX_CONFIG" | sed 's/.*base16Scheme.*=.*"\(.*\)".*/\1/')
        for theme_name in "${!THEMES[@]}"; do
            if [[ "${THEMES[$theme_name]}" == "$current" ]]; then
                echo "Current: $theme_name"
                return
            fi
        done
    fi
    echo "Current: Unknown"
}

# Function to apply theme
apply_theme() {
    local theme_key="$1"
    local theme_value="${THEMES[$theme_key]}"
    
    if [[ -z "$theme_value" ]]; then
        notify-send "Theme Error" "Invalid theme selected" -i "dialog-error"
        return 1
    fi
    
    # Update stylix configuration
    if [[ -f "$STYLIX_CONFIG" ]]; then
        sed -i "s/base16Scheme.*=.*\".*\"/base16Scheme = \"$theme_value\"/" "$STYLIX_CONFIG"
        
        # Rebuild home-manager configuration
        notify-send "Theme Manager" "Applying theme: ${theme_key#* }" -i "preferences-desktop-theme"
        
        if home-manager switch --flake /home/abbes/nixverse#abbes@workstation; then
            notify-send "Theme Manager" "Theme applied successfully!" -i "dialog-information"
            
            # Restart waybar to apply new theme
            pkill waybar
            sleep 1
            waybar &
            
            # Update wallpaper if swww is running
            if pgrep -f "swww-daemon" > /dev/null; then
                ~/.config/niri/scripts/set-wallpaper.sh
            fi
        else
            notify-send "Theme Manager" "Failed to apply theme" -i "dialog-error"
        fi
    else
        notify-send "Theme Error" "Stylix configuration not found" -i "dialog-error"
    fi
}

# Function to show wallpaper menu
wallpaper_menu() {
    local wallpapers_dir="/home/abbes/nixverse/dotfiles/.config/backgrounds"
    local wallpapers=()
    
    if [[ -d "$wallpapers_dir" ]]; then
        while IFS= read -r -d '' file; do
            wallpapers+=("🖼️ $(basename "$file")")
        done < <(find "$wallpapers_dir" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) -print0)
    fi
    
    if [[ ${#wallpapers[@]} -eq 0 ]]; then
        notify-send "Wallpaper" "No wallpapers found in $wallpapers_dir" -i "dialog-information"
        return
    fi
    
    local choice
    choice=$(printf '%s\n' "${wallpapers[@]}" | fuzzel --dmenu --prompt="Select Wallpaper: " --width=50 --lines=8)
    
    if [[ -n "$choice" ]]; then
        local wallpaper_name="${choice#🖼️ }"
        local wallpaper_path="$wallpapers_dir/$wallpaper_name"
        
        # Update locals.nix with new wallpaper
        if [[ -f "$LOCALS_CONFIG" ]]; then
            sed -i "s|wallpaper = .*|wallpaper = \"$wallpaper_path\";|" "$LOCALS_CONFIG"
            
            # Set wallpaper immediately if swww is running
            if pgrep -f "swww-daemon" > /dev/null; then
                swww img "$wallpaper_path" --transition-type=fade --transition-duration=1
            fi
            
            notify-send "Wallpaper" "Wallpaper changed to: $wallpaper_name" -i "preferences-desktop-wallpaper"
        fi
    fi
}

# Main theme menu
main_menu() {
    local options=(
        "$(get_current_theme)"
        "---"
    )
    
    # Add all themes
    for theme in "${!THEMES[@]}"; do
        options+=("$theme")
    done
    
    options+=(
        "---"
        "🖼️ Change Wallpaper"
        "🔄 Reload Theme"
        "⚙️ Edit Theme Config"
    )
    
    local choice
    choice=$(printf '%s\n' "${options[@]}" | fuzzel --dmenu --prompt="Theme Manager: " --width=50 --lines=15)
    
    case "$choice" in
        "Current:"*|"---") return ;;
        *"Change Wallpaper"*) wallpaper_menu ;;
        *"Reload Theme"*) 
            home-manager switch --flake /home/abbes/nixverse#abbes@workstation
            notify-send "Theme Manager" "Theme configuration reloaded" -i "view-refresh"
            ;;
        *"Edit Theme Config"*) 
            ghostty -e nvim "$STYLIX_CONFIG" &
            ;;
        *) apply_theme "$choice" ;;
    esac
}

# Run the main menu
main_menu
