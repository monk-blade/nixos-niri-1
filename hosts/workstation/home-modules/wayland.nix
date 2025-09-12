{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # ========================================
    # WAYLAND COMPOSITOR & WINDOW MANAGEMENT
    # ========================================
    niri                    # Main compositor
    fuzzel                  # Application launcher
    waybar                  # Status bar
    swww                    # Wallpaper daemon
    swaybg                  # Backdrop wallpaper in overview mode
    imagemagick             # Wallpaper blur effects
    
    # ========================================
    # SCREEN UTILITIES
    # ========================================
    grim                    # Screenshot utility
    slurp                   # Screen area selection
    wl-clipboard            # Wayland clipboard utilities
    wf-recorder             # Screen recording for Wayland
    satty                   # Screenshot annotation and editing tool
    
    # ========================================
    # SCREEN LOCKER & IDLE MANAGEMENT
    # ========================================
    swaylock-effects        # Screen locker with effects
    swayidle                # Idle management
    gammastep               # Night light/blue light filter
    wlsunset                # Alternative sunset utility
    brightnessctl           # Brightness control
    
    # ========================================
    # NOTIFICATIONS
    # ========================================
    swaynotificationcenter  # SwayNC notification daemon
    libnotify               # Provides notify-send command
  ];

  # ========================================
  # WAYLAND CONFIGURATION FILES
  # ========================================
  home.file = {
    # Wayland & Window Manager configs
    ".config/niri".source = ../../../dotfiles/.config/niri;
    ".config/fuzzel".source = ../../../dotfiles/.config/fuzzel;
    ".config/waybar".source = ../../../dotfiles/.config/waybar;
    
    # SwayNC notification center
    ".config/swaync".source = ../../../dotfiles/.config/swaync;
    
    # Swaylock screen locker
    ".config/swaylock".source = ../../../dotfiles/.config/swaylock;
    
    # Backgrounds
    ".config/backgrounds".source = ../../../dotfiles/.config/backgrounds;
  };
}
