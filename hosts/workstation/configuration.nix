{ config, lib, pkgs, ... }:

let
  versions = import ../../versions.nix;
  locals = import ./locals.nix { inherit pkgs; };
in
{
  imports = [
    ../../globals.nix # Import shared settings
    ./hardware-configuration.nix
    ./stylix.nix
    ../../modules/dm.nix
  ];

  # ============================================================================
  # SYSTEM CONFIGURATION
  # ============================================================================

  # ========================================
  # BOOT & SYSTEM CONFIGURATION
  # ========================================
  
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  
  # LUKS disk encryption support
  boot.initrd.luks.devices = {
    # Example LUKS setup - uncomment and configure for real hardware
    # "luks-root" = {
    #   device = "/dev/disk/by-uuid/YOUR-LUKS-UUID-HERE";
    #   preLVM = true;
    # };
  };
  
  # Encryption & filesystem support
  boot.initrd.availableKernelModules = [ "aes" "xts" "sha256" "sha512" ];
  boot.supportedFilesystems = [ "ext4" "btrfs" "xfs" "ntfs" ];

  # System updates
  system.autoUpgrade = {
    enable = false;  # Set to true if you want automatic updates
  };


  # ========================================
  # NIX CONFIGURATION
  # ========================================
  
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
      # Improve build performance and stability
      max-jobs = "auto";
      cores = 0;  # Use all available cores
      keep-outputs = false;  # Don't keep build outputs (saves space)
      keep-derivations = false;  # Don't keep derivation files
    };
    
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    
    # Automatic store optimization
    optimise = {
      automatic = true;
      dates = [ "03:45" ];
    };  
  };



  # VirtualBox optimizations (disable for real hardware)
  # boot.initrd.checkJournalingFS = false;  # VM-specific
  # virtualisation.virtualbox.guest.enable = true;  # VM-specific

  # ========================================
  # HARDWARE CONFIGURATION
  # ========================================
  
  # Graphics and hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # For 32-bit applications and games
    
    # Mesa drivers for Intel/AMD/Nouveau graphics
    extraPackages = with pkgs; [
      mesa  # Use mesa instead of mesa.drivers
      # Intel hardware video acceleration
      intel-media-driver
      intel-vaapi-driver
      # VDPAU support
      libvdpau-va-gl
    ];
    
    # 32-bit driver support
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa  # Use mesa instead of mesa.drivers
      intel-media-driver
      intel-vaapi-driver
    ];
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;  # Don't auto-power on boot (saves battery)
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;  # Enable experimental features
      };
    };
  };

  # Camera support
  hardware.ipu6.enable = true;
  hardware.ipu6.platform = "ipu6";
  hardware.enableAllFirmware = true;

  # ========================================
  # NETWORKING & CONNECTIVITY
  # ========================================
  
  networking.hostName = locals.hostname;
  networking.networkmanager.enable = true;
  
  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];  # Add ports as needed: 22 80 443
    allowedUDPPorts = [ ];
    # allowPing = true;  # Uncomment if needed
  };
  
  # DNS will be handled automatically by NetworkManager
  # Optional: Custom DNS servers (uncomment if you want to override ISP DNS)
  # networking.nameservers = [ "8.8.8.8" "1.1.1.1" "1.0.0.1" "9.9.9.9" ];
  
  # Enable systemd-resolved for better DNS handling
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "8.8.8.8" "1.1.1.1" ];
    extraConfig = ''
      DNS=8.8.8.8 1.1.1.1 1.0.0.1
      FallbackDNS=9.9.9.9 149.112.112.112
    '';
  };

  # ========================================
  # LOCALIZATION & DISPLAY
  # ========================================
  
  # Time zone
  time.timeZone = "Africa/Tunis";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
  
  # ========================================
  # PROGRAMS CONFIGURATION
  # ========================================
  
  # System programs
  programs.niri.enable = true;        # Primary compositor
  programs.fish.enable = true;        # Fish shell system-wide
  programs.dconf.enable = true;       # GTK settings

  # ========================================
  # SERVICES CONFIGURATION
  # ========================================
  
  # Display & Desktop Services
  services.autorandr.enable = true;   # Auto display profiles
  
  # Enable Wayland protocols
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config = {
      common.default = "*";
      niri = {
        default = [ "wlr" "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      };
      firefox = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      };
    };
    wlr.enable = true;
  };

  # Audio Services
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth Services
  services.blueman.enable = true;

  # Authentication Services
  services.fprintd = {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-goodix;
  };

  # Power Management Services
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
      CPU_MAX_PERF_ON_BAT = 80;
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
    };
  };
  services.thermald.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    killUserProcesses = false;
  };

  # System Services
  services.printing.enable = lib.mkDefault true;
  services.avahi.enable = lib.mkDefault true;
  services.udisks2.enable = true;      # Auto-mount USB drives
  services.gvfs.enable = true;         # Virtual file system

  # Remote Access Services
  services.openssh = {
    enable = lib.mkDefault false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # ========================================
  # SECURITY CONFIGURATION
  # ========================================
  
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  
  # PAM configuration for fingerprint authentication
  security.pam.services = {
    sddm.fprintAuth = true;
    sudo.fprintAuth = true;
    swaylock.fprintAuth = true;
    polkit-1.fprintAuth = true;
  };

  # ========================================
  # VIRTUALIZATION & CONTAINERS
  # ========================================
  
  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };
  
  # Podman (disabled, using Docker)
  virtualisation.podman = {
    enable = false;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # VirtualBox
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  # ========================================
  # USER CONFIGURATION
  # ========================================
  
  users.users.abbes = {
    isNormalUser = true;
    description = "abbes";
    extraGroups = [
      "networkmanager"
      "wheel"
      "vboxsf"
      "vboxusers"
      "docker"
      "podman"
      "video"
      "audio"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };
  
  users.users.abbes.linger = true;

  # ========================================
  # SYSTEM PACKAGES & ENVIRONMENT
  # ========================================
  
  # System packages (minimal, let home-manager handle user packages)
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    nh                      # NixOS Helper - better CLI for nixos-rebuild
  ];

  # Fonts
  fonts = {
    packages = with pkgs; [
      # Terminal and UI specific fonts (SpaceMono for terminals, waybar, fuzzel, notifications)
      nerd-fonts.space-mono
      
      # System fonts - Inter for UI, Source Sans Pro for general text
      inter
      source-sans-pro
      source-serif-pro
      
      # Monospace alternatives
      victor-mono
      jetbrains-mono
      
      # Essential fonts
      noto-fonts              # Comprehensive Unicode support
      noto-fonts-cjk-sans     # Chinese, Japanese, Korean
      noto-fonts-emoji        # Emoji support
      
      # Arabic/RTL support
      amiri
      
      # Icon fonts
      font-awesome
      nerd-fonts.symbols-only
      
      # Fallback fonts
      liberation_ttf
      dejavu_fonts
    ];
    
    fontconfig = {
      enable = true;
      
      # Default font configuration
      defaultFonts = {
        # Use Inter for general UI text (clean, modern, readable)
        sansSerif = [ "Inter" "Noto Sans" "DejaVu Sans" ];
        
        # Use Source Serif Pro for documents and reading
        serif = [ "Source Serif Pro" "Noto Serif" "DejaVu Serif" ];
        
        # Use JetBrains Mono as default monospace (better than SpaceMono for general use)
        monospace = [ "JetBrains Mono" "SpaceMono Nerd Font" "DejaVu Sans Mono" ];
        
        # Emoji support
        emoji = [ "Noto Color Emoji" ];
      };
      
      # Additional fontconfig settings for better rendering
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <!-- Better font rendering -->
          <match target="font">
            <edit name="antialias" mode="assign">
              <bool>true</bool>
            </edit>
            <edit name="hinting" mode="assign">
              <bool>true</bool>
            </edit>
            <edit name="hintstyle" mode="assign">
              <const>hintslight</const>
            </edit>
            <edit name="rgba" mode="assign">
              <const>rgb</const>
            </edit>
          </match>
          
          <!-- Use SpaceMono specifically for terminal applications -->
          <match target="pattern">
            <test qual="any" name="family">
              <string>monospace</string>
            </test>
            <test name="prgname">
              <string>foot</string>
            </test>
            <edit name="family" mode="prepend" binding="strong">
              <string>SpaceMono Nerd Font</string>
            </edit>
          </match>
          
          <match target="pattern">
            <test qual="any" name="family">
              <string>monospace</string>
            </test>
            <test name="prgname">
              <string>ghostty</string>
            </test>
            <edit name="family" mode="prepend" binding="strong">
              <string>SpaceMono Nerd Font</string>
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };

  system.stateVersion = versions.nixos;
}
