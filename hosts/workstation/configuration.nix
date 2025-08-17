{ config, lib, pkgs, ... }:

{
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
  
  # Audio
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  
  # Basic hardware support
  hardware.opengl.enable = true;
}
