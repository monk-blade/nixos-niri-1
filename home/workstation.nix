{ config, pkgs, ... }:

{
  # Basic user info
  home.username = "abbes";
  home.homeDirectory = "/home/abbes";
  home.stateVersion = "25.05";

  # Install packages but use dotfiles for configuration
  home.packages = with pkgs; [
    ghostty
    fish
    starship
    neovim
  ];

  # Basic git configuration only
  programs.git = {
    enable = true;
    userName = "Abbes";
    userEmail = "your-email@example.com"; # Change this to your email
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };
  
  # Copy dotfiles - let existing configs handle everything
  home.file = {
    ".config/ghostty/config" = {
      source = ../dotfiles/ghostty/config;
    };
    
    ".config/fish/config.fish" = {
      source = ../dotfiles/fish/config.fish;
    };
    
    ".config/fish/fish_variables" = {
      source = ../dotfiles/fish/fish_variables;
    };
    
    ".config/nvim" = {
      source = ../dotfiles/nvim;
      recursive = true;
    };
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;
}
