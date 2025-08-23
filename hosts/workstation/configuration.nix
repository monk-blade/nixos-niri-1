{ config, lib, pkgs, ... }:

let
  versions = import ../../versions.nix;
in
{
  imports = [
    ../../globals.nix # Import shared settings
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



  # VirtualBox optimizations
  boot.initrd.checkJournalingFS = false;
  virtualisation.virtualbox.guest.enable = true;

  # Network
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  
  # DNS configuration for VM
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];
  networking.resolvconf.enable = true;
  
  # Ensure DNS is working in VM environment
  networking.dhcpcd.extraConfig = ''
    # Use static DNS servers
    static domain_name_servers=8.8.8.8 1.1.1.1
  '';

  # Time zone
  time.timeZone = "Africa/Tunis";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Minimal X11 setup (only enable if needed for compatibility)
  services.xserver.enable = lib.mkDefault false;  # Disable by default, enable if needed
  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.displayManager.lightdm.greeters.gtk.enable = true;  
  # services.xserver.desktopManager.xfce.enable = true;  # Disabled to save battery
  
  # Use Niri as primary compositor (Wayland-native)
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

  # Enable fish shell system-wide
  programs.fish.enable = true;

  # User account
  users.users.abbes = {
    isNormalUser = true;
    description = "abbes";
    extraGroups = [ "networkmanager" "wheel" "vboxsf" "docker" ];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };

  # Docker support (disabled on boot for battery savings)
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;  # Start manually when needed
    autoPrune.enable = true;
  };

  # Power Management for Battery Life
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 80;  # Limit CPU to 50% on battery
      
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;  # Battery charge limiting
      
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
    };
  };

  # Additional power optimizations
  services.thermald.enable = true;  # Thermal management
  services.auto-cpufreq.enable = true;  # Automatic CPU frequency scaling
  
  # Disable unnecessary services for battery
  services.printing.enable = lib.mkDefault false;
  services.avahi.enable = lib.mkDefault false;

  environment.sessionVariables = {
    # Enable Wayland for Chromium-based apps
    NIXOS_OZONE_WL = "1";
  };

  # System packages (minimal, let home-manager handle user packages)
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
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
      # Font Awesome for waybar icons
      font-awesome
      nerd-fonts.symbols-only
    ];
    
    fontconfig.enable = true;
  };

  system.stateVersion = versions.nixos;
}