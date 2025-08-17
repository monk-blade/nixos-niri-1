# Minimal hardware configuration
# This is a generic configuration for the minimal setup
# For actual hardware, generate with: sudo nixos-generate-config

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Generic boot configuration
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Generic filesystem configuration
  # NOTE: These are placeholder values - replace with actual UUIDs
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  # No swap for minimal setup
  swapDevices = [ ];

  # Networking
  networking.useDHCP = lib.mkDefault true;
  
  # Generic CPU configuration
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  # Basic hardware settings
  hardware.enableRedistributableFirmware = true;
}
