{ config, pkgs, ... }:

{
  # Basic info
  home.username = "abbes";
  home.homeDirectory = "/home/abbes";
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Install your packages here (keeping it minimal for fast setup)
  home.packages = with pkgs; [
    # browser
    brave
    
    # Terminal & Shell
    fish
    ghostty
    foot
    starship
    tmux
    cliphist
    lsd
    
    # Wayland & Window Manager
    niri
    waybar
    mako  # Lightweight notification daemon
    swaylock  # Screen locker
    swww  # Wallpaper daemon
    wl-clipboard  # Wayland clipboard utilities
    grim  # Screenshot utility
    slurp  # Screen area selection
    
    # Essential Development
    neovim
    git
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
    btop
    fastfetch
    cava  # Audio visualizer
    nh  # NixOS Helper - better CLI for nixos-rebuild and nix commands
    
    # File Management
    tree
    ranger
    yazi  # Modern file manager
    
    # Search & Navigation
    fzf
    ripgrep
    fd
    bat
    zoxide  # Smart directory jumper
    jq  # JSON processor for notification scripts
  ];

  # Link your existing dotfiles
  home.file = {
    # Shell & Terminal configs
    ".config/fish".source = ./dotfiles/.config/fish;
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
    
    # Fish shell
    fish = {
      enable = true;
      # Let your fish config files handle the detailed configuration
    };
    
    # Starship prompt
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
    
    # Direnv for project environments
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    
    # Zoxide for smart directory jumping
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    
    # Bat for syntax highlighting
    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        style = "numbers,changes,header";
      };
    };
    
    # FZF fuzzy finder
    fzf = {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      defaultOptions = [ "--height 40%" "--border" ];
    };
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

  # Systemd services
  systemd.user.services = {
    swww-wallpaper = {
      Unit = {
        Description = "Set wallpaper with swww";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStartPre = "/run/current-system/sw/bin/sleep 2";
        ExecStart = "${pkgs.swww}/bin/swww img %h/.config/backgrounds/white-tree.jpeg --transition-type fade --transition-duration 1";
        RemainAfterExit = true;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
