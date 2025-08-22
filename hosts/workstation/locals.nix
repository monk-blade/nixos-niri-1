# Local configuration variables for this workstation
# This file contains host-specific settings that can be imported by other modules

{ pkgs, ... }:

{
  # Wallpaper configuration
  wallpaper = ../../dotfiles/.config/backgrounds/texture.jpg;
  
  # Host-specific settings
  hostname = "workstation";
  
  # User preferences
  user = {
    name = "abbes";
    description = "Abbes";
  };
  
  # Display configuration
  display = {
    # Add display-specific settings here if needed
    # e.g., resolution, scaling, etc.
  };
  
  # Hardware-specific settings
  hardware = {
    # Add hardware-specific settings here
    # e.g., GPU type, special drivers, etc.
  };
}