# NixOS Installation Guide

## Fixed Issues

✅ **Removed duplicate packages:**
- Docker enable statements
- Niri enable statements  
- Alacritty in multiple places
- Git configurations

✅ **Fixed display manager conflict:**
- Removed GDM, using greetd with niri

✅ **Added graphics support:**
- Created `modules/hardware/graphics.nix` with OpenGL and drivers
- Added hardware acceleration support

✅ **Enabled essential applications:**
- Firefox, Thunderbird, GIMP, LibreOffice
- VLC, Spotify
- Development tools
- File managers and utilities

## Installation Steps

### 1. Boot NixOS Installer
Boot from NixOS installer USB/DVD

### 2. Partition Your Disk
Example for UEFI system:
```bash
# Create partitions (adjust /dev/sdX to your disk)
sudo parted /dev/sdX -- mklabel gpt
sudo parted /dev/sdX -- mkpart primary 512MiB -8GiB
sudo parted /dev/sdX -- mkpart primary linux-swap -8GiB 100%
sudo parted /dev/sdX -- mkpart ESP fat32 1MiB 512MiB
sudo parted /dev/sdX -- set 3 esp on

# Format partitions
sudo mkfs.ext4 -L nixos /dev/sdX1
sudo mkswap -L swap /dev/sdX2
sudo mkfs.fat -F 32 -n boot /dev/sdX3
```

### 3. Mount Filesystems
```bash
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
sudo swapon /dev/sdX2
```

### 4. Clone Configuration
```bash
cd /mnt
git clone https://github.com/your-username/nixverse.git
cd nixverse
```

### 5. Generate Hardware Configuration
```bash
./generate-hardware-config.sh
```

### 6. Customize Hardware Configuration
Edit `hosts/workstation/hardware-configuration.nix`:
- Update UUIDs to match your partitions
- Adjust CPU settings (Intel vs AMD)
- Modify graphics drivers if needed

### 7. Install NixOS
```bash
sudo nixos-install --flake .#workstation
```

### 8. Set Root Password
```bash
sudo nixos-enter
passwd
exit
```

### 9. Reboot
```bash
reboot
```

## Post-Installation

After first boot:

1. **Set user password:**
   ```bash
   sudo passwd abbes
   ```

2. **Update the system:**
   ```bash
   sudo nixos-rebuild switch --flake .#workstation
   ```

3. **Update home-manager:**
   ```bash
   home-manager switch --flake .#workstation
   ```

## Troubleshooting

### Black Screen Issues
- The graphics configuration should fix this
- If still having issues, try adding your specific GPU drivers to `modules/hardware/graphics.nix`

### Display Manager Issues  
- greetd should start automatically
- If having issues, check: `systemctl status greetd`

### Niri Not Starting
- Check: `systemctl --user status niri`
- Logs: `journalctl --user -u niri`

## Configuration Structure

```
nixverse/
├── flake.nix                    # Main flake configuration
├── hosts/
│   ├── common/                  # Shared configuration
│   └── workstation/
│       ├── configuration.nix    # Workstation-specific config
│       └── hardware-configuration.nix  # Hardware settings
├── modules/
│   ├── desktop/niri.nix        # Niri window manager
│   ├── development/            # Development tools
│   ├── services/docker.nix     # Docker configuration
│   └── hardware/graphics.nix   # Graphics drivers
└── home/
    ├── workstation.nix         # Home-manager config
    └── desktop/applications.nix # Desktop applications
```
