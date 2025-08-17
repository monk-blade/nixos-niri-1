{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  # System hostname
  networking.hostName = "nixos-workstation";
  
  # Basic desktop environment - using GNOME for simplicity
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  
  # Essential packages only (others handled by home-manager)
  environment.systemPackages = with pkgs; [
    # Basic applications
    firefox
    
    # Basic system tools
    curl
    wget
    tree
    htop
  ];
  
  # VirtualBox optimizations
  virtualisation.virtualbox.guest.enable = true;
  
  # Audio is handled by common config (PipeWire)
  # No conflicting pulseaudio settings here
  
  # Hardware support for Wayland (using modern graphics options)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  # Wayland support
  environment.sessionVariables = {
    # Enable Wayland for supported applications
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
