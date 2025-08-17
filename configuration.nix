{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader for VirtualBox
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # VirtualBox optimizations
  boot.initrd.checkJournalingFS = false;
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.x11 = true;

  # Network
  networking.hostName = "nixos-vm";
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "Africa/Tunis";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # X11 and Desktop Environment (adjust as needed)
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # User account
  users.users.yourusername = {
    isNormalUser = true;
    description = "Your Name";
    extraGroups = [ "networkmanager" "wheel" "vboxsf" ];
    shell = pkgs.fish;  # Set fish as default shell
    packages = with pkgs; [];
  };

  # System packages (minimal, let home-manager handle user packages)
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
  ];

  # Enable fish system-wide
  programs.fish.enable = true;

  system.stateVersion = "24.05";
}