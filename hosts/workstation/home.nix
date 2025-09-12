{ config, lib, pkgs, inputs, ... }:
let
  versions = import ../../versions.nix;
  locals = import ./locals.nix { inherit pkgs; };
in
{
  imports = [
    ../../globals.nix
    ./session-variables.nix
    
    # Home modules
    ./modules/development
    ./modules/desktop.nix
    ./modules/wayland.nix
    ./modules/multimedia.nix
    ./modules/system
  ];
  
  # Basic info
  home.username = "abbes";
  home.homeDirectory = "/home/abbes";
  home.stateVersion = versions.homeManager;

  # ============================================================================
  # PACKAGE CONFIGURATION
  # ============================================================================
  # Packages are now organized in modular files:
  # - development.nix: Programming languages, dev tools, IDEs
  # - desktop.nix: GUI applications, browsers, desktop utilities
  # - wayland.nix: Compositor stack, Wayland-specific tools
  # - multimedia.nix: Audio/video players and processing tools
  # - system.nix: System administration and monitoring tools
  
  home.packages = with pkgs; [
    
    # ========================================
    # ADDITIONAL PACKAGES
    # ========================================
    # Add any additional packages that don't fit in the modules above
  ];

  # ============================================================================
  # CONFIGURATION FILES
  # ============================================================================
  # Configuration files are now managed in their respective modules:
  # - wayland.nix: Niri, Waybar, Fuzzel, SwayNC, Swaylock, backgrounds
  # - system.nix: Ghostty, Starship, Lazygit, Neovim, btop, cava, fastfetch, ranger
  
  home.file = {
    # Additional configuration files that don't fit in modules
  };

  # ============================================================================
  # PROGRAMS CONFIGURATION
  # ============================================================================
  # Program configurations are now managed in their respective modules:
  # - system.nix: programs.nh.enable = true;
  
  # programs.virt-manager.enable = true;
}
