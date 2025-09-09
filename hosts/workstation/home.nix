{ config, lib, pkgs, inputs, ... }:
let
  versions = import ../../versions.nix;
  locals = import ./locals.nix { inherit pkgs; };
in
{
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

  # ============================================================================
  # PACKAGE CONFIGURATION
  # ============================================================================
  home.packages = with pkgs; [
    
    # ========================================
    # WEB BROWSERS
    # ========================================
    chromium
    inputs.zen-browser.packages."${pkgs.system}".default

    # ========================================
    # WAYLAND COMPOSITOR & WINDOW MANAGEMENT
    # ========================================
    niri                    # Main compositor
    fuzzel                  # Application launcher
    waybar                  # Status bar
    swww                    # Wallpaper daemon
    swaybg                  # Backdrop wallpaper in overview mode
    imagemagick             # Wallpaper blur effects
    
    # Screen utilities
    grim                    # Screenshot utility
    slurp                   # Screen area selection
    wl-clipboard            # Wayland clipboard utilities
    
    # Screen locker & idle management
    swaylock-effects        # Screen locker with effects
    swayidle                # Idle management
    gammastep               # Night light/blue light filter
    wlsunset                # Alternative sunset utility
    brightnessctl           # Brightness control
    
    # Notifications
    swaynotificationcenter  # SwayNC notification daemon
    libnotify               # Provides notify-send command

    # ========================================
    # TERMINAL & SHELL UTILITIES
    # ========================================
    ghostty                 # Terminal emulator
    cliphist                # Clipboard history
    dysk                    # Better disk usage display
    
    # Performance & system monitoring
    dust                    # Better du
    procs                   # Better ps
    hyperfine               # Benchmarking tool
    tokei                   # Code statistics

    # ========================================
    # DEVELOPMENT ENVIRONMENT
    # ========================================
    
    # Editors & IDEs
    windsurf                # AI-powered editor
    
    # Version managers & package managers
    fnm                     # Fast Node Manager
    pnpm                    # Fast npm alternative
    yarn                    # Node package manager
    
    # Programming languages & runtimes
    nodejs_22               # Node.js runtime
    python3                 # Python interpreter
    python3Packages.pip     # Python package manager
    python3Packages.virtualenv  # Python virtual environments
    rustc                   # Rust compiler
    cargo                   # Rust package manager
    go                      # Go programming language
    
    # Native development dependencies
    libjpeg                 # JPEG library
    cairo                   # 2D graphics library
    pango                   # Text rendering
    pixman                  # Pixel manipulation
    libuuid                 # UUID library
    giflib                  # GIF library
    libimagequant           # Image quantization
    librsvg                 # SVG rendering
    pkg-config              # Package configuration
    
    # C/C++ Development (needed for native modules)
    gcc                     # GNU Compiler Collection
    gnumake                 # GNU Make
    cmake                   # Cross-platform build system
    
    # Code quality & formatting
    shellcheck              # Shell script linting
    shfmt                   # Shell script formatting
    
    # System debugging & monitoring
    strace                  # System call monitoring
    ltrace                  # Library call monitoring
    lsof                    # List open files

    # ========================================
    # DEVOPS & CLOUD TOOLS
    # ========================================
    docker                  # Container runtime
    docker-compose          # Multi-container orchestration
    kubectl                 # Kubernetes CLI
    terraform               # Infrastructure as code
    
    # API & network testing
    httpie                  # Better curl alternative
    yaak                    # API testing tool

    # ========================================
    # DATABASE & DATA MANAGEMENT
    # ========================================
    dbeaver-bin             # Universal database tool (80+ databases)

    # ========================================
    # DESKTOP APPLICATIONS
    # ========================================
    
    # File management
    nautilus                # GNOME Files manager
    
    # Communication & social
    slack                   # Team communication
    discord                 # Gaming/community chat
    
    # Document viewers
    zathura                 # Lightweight PDF viewer with vim-like keybindings
    
    # Utilities
    switcheroo              # App switcher
    localsend               # Local file sharing

    # ========================================
    # MULTIMEDIA & CAMERA
    # ========================================
    cheese                  # Camera application
    libcamera               # Camera library
    v4l-utils               # Video4Linux utilities

    # ========================================
    # SYSTEM ADMINISTRATION
    # ========================================
    
    
    # Network management
    networkmanagerapplet    # nm-connection-editor
    
    # Bluetooth management
    blueman                 # Bluetooth manager
    
    # Audio control
    pavucontrol             # PulseAudio volume control
    pulseaudio              # Audio system
    
    # Hardware monitoring & control
    lm_sensors              # Hardware sensors (temperature, etc.)
    powertop                # Power consumption analyzer
    acpi                    # Battery status
    tlp                     # Power management (conflicts with auto-cpufreq)
    
    # Hardware detection
    usbutils                # Provides lsusb command
    pciutils                # Provides lspci command
    lshw                    # Hardware lister
    ethtool                 # Ethernet tool
    
    # Fingerprint authentication
    fprintd                 # Fingerprint daemon
    libfprint               # Fingerprint library

    # ========================================
    # GRAPHICS & UI FRAMEWORKS
    # ========================================
    
    # Qt6 support (essential for Qt-based applications)
    qt6.qtbase              # Core Qt6 framework (includes qtwayland)
    qt6.qttools             # Qt6 development tools
    
    # GTK support
    adwaita-icon-theme      # Default GNOME icons (required for Nautilus)
    gtk3                    # GTK3 runtime
    gtk4                    # GTK4 runtime
    glib                    # GLib runtime (required for GTK apps)
    
    # Graphics acceleration
    vulkan-tools            # Vulkan utilities

    # ========================================
    # GAMING & COMPATIBILITY
    # ========================================
    xwayland-satellite      # XWayland integration for gaming

    # ========================================
    # ARCHIVE & COMPRESSION
    # ========================================
    zip                     # ZIP compression
    xz                      # XZ compression
    unzip                   # ZIP extraction
    p7zip                   # 7-Zip compression

    # ========================================
    # UTILITIES & HELPERS
    # ========================================
    jq                      # JSON processor
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
