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
    
    # Terminal & Shell
    ghostty
    foot
    cliphist
    dysk
    
    # Wayland & Window Manager
    niri
    swww
    # swaybg 
    imagemagick  # For wallpaper blur effects
    waypaper
    fuzzel  # Application launcher
    
    # mako  # Lightweight notification daemon
    swaynotificationcenter  # SwayNC notification daemon
    libnotify  # Provides notify-send command
    hyprlock  # Screen locker
    wl-clipboard  # Wayland clipboard utilities
    grim  # Screenshot utility
    slurp  # Screen area selection
    
    # Essential Development
    fnm  # Fast Node Manager
    
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
    
    # API & Network tools
    curl
    wget
    httpie  # Better curl alternative
    bruno  # API testing
    
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

    # Waybar and related tools
    waybar
    pavucontrol
    jq
    wlsunset
    
    # Network & Bluetooth Management
    networkmanagerapplet  # nm-connection-editor
    blueman  # Bluetooth manager

    # System Monitoring & Info
    nh  # NixOS Helper - better CLI for nixos-rebuild and nix commands
    
    # Battery & Power Management Tools
    powertop  # Power consumption analyzer
    acpi  # Battery status
    tlp  # Power management
    auto-cpufreq  # Automatic CPU frequency scaling

    # libreoffice-qt6-fresh

    # Social media apps
    slack
    discord

    # obs-studio
    
  ];

  # Link your existing dotfiles
  home.file = {
    # Shell & Terminal configs
    ".config/ghostty".source = ../../dotfiles/.config/ghostty;
    ".config/starship".source = ../../dotfiles/.config/starship;
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
    
    # Backgrounds
    ".config/backgrounds".source = ../../dotfiles/.config/backgrounds;
  };

  programs.nh.enable = true;
  
  # programs.virt-manager.enable = true;

  # Enable programs that need special handling
  programs = {
    # Git configuration
    git = {
      enable = true;
      userName = "abbesm0hamed";
      userEmail = "abbesmohamed717@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "nvim";
        pull.rebase = false;
        push.default = "simple";
      };
    };
    
    # SSH configuration for GitHub
    ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_ed25519";
        };
      };
    };
  };

  # Systemd user services
  systemd.user.services = {

    set-wallpaper = {
      Unit = {
        Description = "Set wallpaper using swww";
        After = [ "swww-daemon.service" ];
        Wants = [ "swww-daemon.service" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStartPre = "/bin/sh -c 'until ${pkgs.swww}/bin/swww query; do sleep 0.1; done'";
        ExecStart = "${pkgs.swww}/bin/swww img ${locals.wallpaper}";
        RemainAfterExit = true;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    # SwayNC notification daemon
    swaync = {
      Unit = {
        Description = "SwayNotificationCenter";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
        Restart = "on-failure";
        RestartSec = "1";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "zen";
    
    # Development environment
    TERM = "xterm-256color";
    COLORTERM = "truecolor";
    
    # Node.js and npm
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    
    # Python
    PYTHONDONTWRITEBYTECODE = "1";
    PYTHONUNBUFFERED = "1";
    
    # Rust
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";
    
    # Go
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
    
    # Path additions
    PATH = "$HOME/.npm-global/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH";
  };
}
