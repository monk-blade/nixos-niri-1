{ config, lib, pkgs, ... }:

let
  versions = import ./versions.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ./stylix.nix
  ];

  # Bootloader for VirtualBox
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  system.autoUpgrade = {
    enable = false;  # Set to true if you want automatic updates
  };
  
  # Enable flakes and nix command
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
    };
    
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d --max-freed 5G";  # Also limit by space freed
    };  
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # VirtualBox optimizations
  boot.initrd.checkJournalingFS = false;
  virtualisation.virtualbox.guest.enable = true;

  # Network
  networking.hostName = "abbes";
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "Africa/Tunis";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # X11 and Desktop Environment (adjust as needed)
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.greeters.gtk.enable = true;  
  services.xserver.desktopManager.xfce.enable = true;
  programs.niri.enable = true;

  # Enable Wayland protocols
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };

  # Enable sound with PipeWire (modern audio system)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User account
  users.users.abbes = {
    isNormalUser = true;
    description = "abbes";
    extraGroups = [ "networkmanager" "wheel" "vboxsf" "docker" ];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };

  # Docker support
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  # System packages (minimal, let home-manager handle user packages)
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    home-manager  # Enable standalone home-manager command
  ];

  # Fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.space-mono
      victor-mono
      noto-fonts-emoji
      amiri
      # Optional: add some common fallbacks
      noto-fonts
      liberation_ttf
    ];
    
    fontconfig.enable = true;
  };

  # Enable fish system-wide
  programs.fish.enable = true;

  system.stateVersion = versions.nixos;
}