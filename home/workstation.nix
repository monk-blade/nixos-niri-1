{ config, pkgs, lib, dotfiles ? null, isVM ? false, ... }:

{
  imports = [
    ./common
    ./desktop/niri.nix
    ./desktop/applications.nix
    ./programs/ghostty.nix
  ];

  home = {
    username = "abbes";
    homeDirectory = "/home/abbes";
    stateVersion = "25.05";
  };

  # Copy your existing dotfiles (if dotfiles path is provided)
  home.file = lib.optionalAttrs (dotfiles != null) {
    ".config/nvim" = {
      source = "${dotfiles}/nvim";
      recursive = true;
    };
    
    ".config/tmux" = {
      source = "${dotfiles}/tmux";
      recursive = true;
    };
  } // lib.optionalAttrs (dotfiles != null && !isVM) {
    # Physical machine specific dotfiles
    ".config/hardware-specific" = {
      source = "${dotfiles}/hardware-specific";
      recursive = true;
    };
  };

  # Programs managed by Home Manager
  programs = {
    git = {
      enable = true;
      userName = "Abbes";
      userEmail = "your-email@example.com";
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "nvim";
      };
    };

    tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        resurrect
        continuum
      ];
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
