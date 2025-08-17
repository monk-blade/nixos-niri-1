{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/sda2/7d5b55bb-a233-43db-b337-00a885014ca0";
    fsType = "ext4";
  };

  swapDevices = [ ];

  # VirtualBox specific
  virtualisation.virtualbox.guest.enable = true;
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}