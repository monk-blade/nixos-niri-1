{ config, lib, pkgs, inputs, ... }:
let
  versions = import ../../versions.nix;
  locals = import ./locals.nix { inherit pkgs; };
in
{
  # Import modules
  imports = [
    ../../globals.nix 
    ../../modules/shell.nix
    ../../modules/tmux.nix
    ../../modules/git.nix
    ./session-variables.nix
  ];
  
  # Basic info
  home.username = "abbes";
  home.homeDirectory = "/home/abbes";
  home.stateVersion = versions.homeManager;

  # Install your packages here (keeping it minimal for fast setup)
  home.packages = with pkgs; [
    # browser
    # brave
    chromium
    inputs.zen-browser.packages."${pkgs.system}".default

    # camera
    cheese
    libcamera
    v4l-utils
    
    # Terminal & Shell
    ghostty
    cliphist
    dysk
    
    # Wayland & Window Manager
    niri
    swww
    swaybg  # For backdrop wallpaper in overview mode 
    imagemagick  # For wallpaper blur effects
    fuzzel  # Application launcher
    switcheroo
    localsend
    
    # mako  # Lightweight notification daemon
    swaynotificationcenter  # SwayNC notification daemon
    libnotify  # Provides notify-send command
    swaylock-effects  # Screen locker with effects (better for wlroots/Niri)
    wl-clipboard  # Wayland clipboard utilities
    grim  # Screenshot utility
    slurp  # Screen area selection
    # davinci-resolve
    
    # Essential Development
    fnm  # Fast Node Manager
    windsurf
    
    # Languages & Runtimes
    nodejs_24  # Latest LTS Node.js
    python3
    python3Packages.pip
    python3Packages.virtualenv
    rustc
    cargo
    go
    
    # Container & Cloud tools
    docker
    docker-compose
    kubectl
    terraform

    # Database Management Tools
    dbeaver-bin         # Universal database tool (80+ databases)
    
    # API & Network tools
    httpie  # Better curl alternative
    # bruno  # API testing
    # postman
    yaak

    
    # Code quality & formatting
    shellcheck  # Shell script linting
    shfmt  # Shell script formatting
    
    # Performance & debugging
    hyperfine  # Benchmarking tool
    tokei  # Code statistics
    dust  # Better du
    procs  # Better ps
    
    # C/C++ Development (needed for Neovim plugins)
    gcc
    gnumake
    cmake

    # mostly for gaming
    xwayland-satellite

    # Waybar and related tools
    waybar
    pavucontrol
    jq
    wlsunset
    
    # Network & Bluetooth Management
    networkmanagerapplet  # nm-connection-editor
    blueman  # Bluetooth manager
    
    # System Control Tools (for system-controls.sh)
    gammastep  # Night light/blue light filter
    swayidle   # Idle management
    brightnessctl  # Brightness control
    lm_sensors  # Hardware sensors (temperature, etc.)
    pulseaudio

    # System Monitoring & Info
    nh  # NixOS Helper - better CLI for nixos-rebuild and nix commands
    
    # Qt6 support (essential for Qt-based applications)
    qt6.qtbase   # Core Qt6 framework (includes qtwayland)
    qt6.qttools  # Qt6 development tools

    # Hardware Detection Tools
    usbutils  # Provides lsusb command
    pciutils  # Provides lspci command
    lshw      # Hardware lister
    ethtool
    
    # Fingerprint Authentication
    fprintd  # Fingerprint daemon
    libfprint  # Fingerprint library
    
    # Battery & Power Management Tools
    powertop  # Power consumption analyzer
    acpi  # Battery status
    tlp  # Power management
    auto-cpufreq  # Automatic CPU frequency scaling
    
    # File Management
    nautilus  # GNOME Files
    
    # GTK theming and icon support for Nautilus
    adwaita-icon-theme    # Default GNOME icons (required for Nautilus)
    gtk3                  # GTK3 runtime
    gtk4                  # GTK4 runtime
    glib                  # GLib runtime (required for GTK apps)

    # libreoffice-qt6-fresh

    # Social media apps
    slack
    discord

    # PDF viewers and document tools
    zathura      # Lightweight PDF viewer with vim-like keybindings

    # Graphics and hardware acceleration
    vulkan-tools # Vulkan utilities
    
    # Add to home.packages
    # gimp        # Image editing
    # inkscape    # Vector graphics
    # obs-studio  # Screen recording (you have commented)    

    # Archive & Compression
    zip
    xz
    unzip
    p7zip

    # System Call Monitoring & Debugging
    strace                  # system call monitoring
    ltrace                  # library call monitoring
    lsof                    # list open files
  ];

  home.file = {
    # Shell & Terminal configs
    ".config/ghostty".source = ../../dotfiles/.config/ghostty;
    ".config/starship.toml".source = ../../dotfiles/.config/starship/starship.toml;
    ".config/lazygit".source = ../../dotfiles/.config/lazygit;
    
    # Wayland & Window Manager configs
    ".config/niri".source = ../../dotfiles/.config/niri;
    ".config/fuzzel".source = ../../dotfiles/.config/fuzzel;
    ".config/waybar".source = ../../dotfiles/.config/waybar;
    
    # Development configs
    ".config/nvim".source = ../../dotfiles/.config/nvim;
    
    # System tools configs
    ".config/btop".source = ../../dotfiles/.config/btop;
    ".config/cava".source = ../../dotfiles/.config/cava;
    ".config/fastfetch".source = ../../dotfiles/.config/fastfetch;
    ".config/ranger".source = ../../dotfiles/.config/ranger;
    
    # SwayNC notification center
    ".config/swaync".source = ../../dotfiles/.config/swaync;
    
    # Swaylock screen locker
    ".config/swaylock".source = ../../dotfiles/.config/swaylock;
    
    # Backgrounds
    ".config/backgrounds".source = ../../dotfiles/.config/backgrounds;
  };

  programs.nh.enable = true;
  
  # programs.virt-manager.enable = true;
}
