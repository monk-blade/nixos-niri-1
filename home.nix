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
    # Terminal & Shell
    fish
    ghostty
    alacritty
    starship
    tmux
    cliphost
    
    # Wayland & Window Manager
    niri
    waybar
    mako  # Notification daemon
    swaylock  # Screen locker
    wl-clipboard  # Wayland clipboard utilities
    grim  # Screenshot utility
    slurp  # Screen area selection
    
    # Essential Development
    neovim
    git
    fnm  # Fast Node Manager
    
    # C/C++ Development (needed for Neovim plugins)
    gcc
    gnumake
    cmake
    
    # System Monitoring & Info
    btop
    fastfetch
    cava  # Audio visualizer
    
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
  };

  # Enable programs that need special handling
  programs = {
    # Git (you can still use your dotfiles for detailed config)
    git = {
      enable = true;
      # Basic config, detailed config can come from your dotfiles
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
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
  };
}