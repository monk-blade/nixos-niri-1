{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # ========================================
    # TERMINAL & SHELL UTILITIES
    # ========================================
    ghostty                 # Terminal emulator
    cliphist                # Clipboard history
    dysk                    # Better disk usage display
    
    # Performance & system monitoring
    dust                    # Better du
    procs                   # Better ps
    hyperfine               # Benchmarking tool
    tokei                   # Code statistics

    # ========================================
    # SYSTEM ADMINISTRATION
    # ========================================
    
    # Network management
    networkmanagerapplet    # nm-connection-editor
    
    # Bluetooth management
    blueman                 # Bluetooth manager
    
    # Audio control
    pavucontrol             # PulseAudio volume control
    pulseaudio              # Audio system
    
    # Hardware monitoring & control
    lm_sensors              # Hardware sensors (temperature, etc.)
    powertop                # Power consumption analyzer
    acpi                    # Battery status
    tlp                     # Power management (conflicts with auto-cpufreq)
    
    # Hardware detection
    usbutils                # Provides lsusb command
    pciutils                # Provides lspci command
    lshw                    # Hardware lister
    ethtool                 # Ethernet tool

    
    wlr-randr
    drm_info
    wayland-utils
    wdisplays
    
    # Fingerprint authentication
    fprintd                 # Fingerprint daemon
    libfprint               # Fingerprint library

    thunderbird
  ];

  # ========================================
  # SYSTEM CONFIGURATION FILES
  # ========================================
  home.file = {
    # Shell & Terminal configs
    ".config/ghostty".source = ../../../../dotfiles/.config/ghostty;
    ".config/starship.toml".source = ../../../../dotfiles/.config/starship/starship.toml;
    ".config/lazygit".source = ../../../../dotfiles/.config/lazygit;
    
    # Development configs
    ".config/nvim".source = ../../../../dotfiles/.config/nvim;
    
    # System tools configs
    ".config/btop".source = ../../../../dotfiles/.config/btop;
    ".config/cava".source = ../../../../dotfiles/.config/cava;
    ".config/fastfetch".source = ../../../../dotfiles/.config/fastfetch;
    ".config/ranger".source = ../../../../dotfiles/.config/ranger;
  };

  # ========================================
  # PROGRAMS CONFIGURATION
  # ========================================
  programs.nh.enable = true;
}
