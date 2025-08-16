# This is a template hardware configuration.
# You should generate the actual one using: sudo nixos-generate-config
# Then copy the generated hardware-configuration.nix here and customize as needed.

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../modules/hardware/graphics.nix
  ];

  # Boot configuration - CUSTOMIZE THESE FOR YOUR SYSTEM
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ]; # Change to "kvm-amd" for AMD
  boot.extraModulePackages = [ ];

  # Filesystems - REPLACE WITH YOUR ACTUAL PARTITIONS
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-ROOT-UUID";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-BOOT-UUID";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  # Swap - REPLACE WITH YOUR ACTUAL SWAP PARTITION OR REMOVE IF NOT USING
  swapDevices = [
    { device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-SWAP-UUID"; }
  ];

  # Networking
  networking.useDHCP = lib.mkDefault true;
  
  # CPU configuration
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # For AMD: hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  # Power management
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  
  # Hardware specific settings
  hardware.enableAllFirmware = true;
}
