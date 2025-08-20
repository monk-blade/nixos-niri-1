{ config, lib, pkgs, ... }:

let
  versions = import ./versions.nix;
in
{
  # Import modules
  imports = [
    ./globals.nix # Import shared settings
    ./modules/shell.nix
  ];
  
  # Basic info
  home.username = "abbes";
  home.homeDirectory = "/home/abbes";
  home.stateVersion = versions.homeManager;

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Install your packages here (keeping it minimal for fast setup)
  home.packages = with pkgs; [
    # browser
    brave
    
    # Terminal & Shell
    ghostty
    foot
    cliphist
    dysk
    
    # Wayland & Window Manager
    niri
    waybar
    swww
    mako  # Lightweight notification daemon
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
    
    # Version control & collaboration
    gh  # GitHub CLI
    lazygit  # TUI for git
    delta  # Better git diff
    
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
    
    # System Monitoring & Info
    nh  # NixOS Helper - better CLI for nixos-rebuild and nix commands
  ];

  # Link your existing dotfiles
  home.file = {
    # Shell & Terminal configs
    ".config/ghostty".source = ./dotfiles/.config/ghostty;
    ".config/alacritty".source = ./dotfiles/.config/alacritty;
    ".config/tmux".source = ./dotfiles/.config/tmux;
    ".config/starship".source = ./dotfiles/.config/starship;
    
    # Wayland & Window Manager configs
    ".config/niri".source = ./dotfiles/.config/niri;
    ".config/waybar".source = ./dotfiles/.config/waybar;
    ".config/mako".source = ./dotfiles/.config/mako;
    ".config/swaylock".source = ./dotfiles/.config/swaylock;
    
    # Development configs
    ".config/nvim".source = ./dotfiles/.config/nvim;
    
    # System tools configs
    ".config/btop".source = ./dotfiles/.config/btop;
    ".config/cava".source = ./dotfiles/.config/cava;
    ".config/fastfetch".source = ./dotfiles/.config/fastfetch;
    ".config/ranger".source = ./dotfiles/.config/ranger;
    ".config/yazi".source = ./dotfiles/.config/yazi;
    
    # Backgrounds
    ".config/backgrounds".source = ./dotfiles/.config/backgrounds;
  };

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
    
    # Note: Shell configuration (Fish, Starship, Zoxide, etc.) is now handled by ./modules/shell.nix
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "brave";
    
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
