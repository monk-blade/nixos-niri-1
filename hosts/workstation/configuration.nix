{ config, lib, pkgs, niri, ... }:

{
  imports = [
    ../../modules/desktop/niri.nix
    ../../modules/development
    ../../modules/services/docker.nix
  ];

  # Enable X11 for compatibility (some apps may need it)
  services.xserver.enable = true;
  
  # Additional workstation packages
  environment.systemPackages = with pkgs; [
    # Desktop applications
    firefox
    thunderbird
    gimp
    libreoffice
    
    # Media
    vlc
    spotify
    
    # System tools
    gparted
    
    # Your custom packages
    zen-browser
  ];

  # Docker is enabled via modules/services/docker.nix
  
  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  
  # Printing
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
}
