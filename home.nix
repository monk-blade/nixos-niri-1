{ config, pkgs, ... }:

{
  # Basic info
  home.username = "yourusername";
  home.homeDirectory = "/home/yourusername";
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Install your packages here (keeping it minimal for fast setup)
  home.packages = with pkgs; [
    # Terminal & Shell
    fish
    ghostty
    
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
    
    # Neovim config (if you have it)
    ".config/nvim".source = ./dotfiles/.config/nvim;
    
    # Add more dotfile links as needed
    # ".vimrc".source = ./dotfiles/.vimrc;
    # ".config/i3".source = ./dotfiles/.config/i3;
    # ".tmux.conf".source = ./dotfiles/.tmux.conf;
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
    
    # Direnv (if you use it)
    direnv = {
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