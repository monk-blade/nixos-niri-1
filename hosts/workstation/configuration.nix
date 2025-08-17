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
    
    # VirtualBox guest additions
    virtualbox-guest-utils
  ];
  
  # VirtualBox optimizations
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.x11 = true;
  
  # Audio is handled by common config (PipeWire)
  # No conflicting pulseaudio settings here
  
  # Basic hardware support
  hardware.opengl.enable = true;
}
