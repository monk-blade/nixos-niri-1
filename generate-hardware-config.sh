#!/usr/bin/env bash

# Script to generate hardware configuration for NixOS
# Run this script after booting from NixOS installer

set -e

echo "=== NixOS Hardware Configuration Generator ==="
echo ""
echo "This script will generate hardware-configuration.nix for your system."
echo "Make sure you have:"
echo "1. Booted from NixOS installer"
echo "2. Partitioned and mounted your disks to /mnt"
echo "3. Have internet connection"
echo ""

read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# Check if /mnt exists and is mounted
if ! mountpoint -q /mnt; then
    echo "Error: /mnt is not mounted. Please mount your root filesystem first."
    echo "Example:"
    echo "  sudo mount /dev/sdX1 /mnt"
    echo "  sudo mkdir -p /mnt/boot"
    echo "  sudo mount /dev/sdX2 /mnt/boot"
    exit 1
fi

# Generate hardware configuration
echo "Generating hardware configuration..."
sudo nixos-generate-config --root /mnt --dir ./hosts/workstation/

echo ""
echo "Hardware configuration generated!"
echo ""
echo "Next steps:"
echo "1. Review and customize ./hosts/workstation/hardware-configuration.nix"
echo "2. Update UUIDs and partition information"
echo "3. Adjust CPU settings (Intel vs AMD)"
echo "4. Run: sudo nixos-install --flake .#workstation"
echo ""
echo "The generated hardware-configuration.nix will replace the template."
