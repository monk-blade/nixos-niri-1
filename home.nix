{ config, pkgs, ... }:

{
  # Basic info
  home.username = "abbes";
  home.homeDirectory = "/home/abbes";
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Install your packages here (keeping it minimal for fast setup)
  home.packages = with pkgs; [
    # Terminal & Shell
    fish
    ghostty
    starship
    
    # Essential Development
    neovim
    git
    
    # Basic System Tools
    htop
    tree
    fzf
    ripgrep
    fd
    bat
    
    # Add more packages gradually as needed...
  ];

  # Link your existing dotfiles
  home.file = {
    # Fish config
    ".config/fish".source = ./dotfiles/.config/fish;
    
    # Ghostty config
    ".config/ghostty".source = ./dotfiles/.config/ghostty;
    
    # Neovim config
    ".config/nvim".source = ./dotfiles/.config/nvim;
    
    # Starship config
    ".config/starship".source = ./dotfiles/.config/starship;
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