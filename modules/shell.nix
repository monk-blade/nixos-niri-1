{ config, lib, pkgs, ... }:

{
  # Fish shell configuration
  programs.fish = {
    enable = true;
    
    # Shell aliases - migrated from Fish config
    shellAliases = {
      # General Productivity
      lns = "ln -s";
      ll = "lsd -la";
      v = "nvim";
      c = "clear";
      lg = "lazygit";
      ff = "fastfetch";
      ".." = "cd ..";
      
      # NixOS Package Management
      nix-search = "nix search nixpkgs";
      nix-shell = "nix-shell -p";
      rebuild = "sudo nixos-rebuild switch";
      rebuild-test = "sudo nixos-rebuild test";
      nix-gc = "sudo nix-collect-garbage -d";
      nix-list = "nix-env -q";
      
      # Quick Navigation
      "..." = "cd ../..";
      "...." = "cd ../../..";
      home = "cd ~";
      nixcfg = "cd ~/nixos-config";
      
      # Docker Power Tools
      dc = "sudo docker-compose";
      dr = "sudo docker";
      
      # Tmux Session Management
      txfr = "tmuxifier";
      tm = "tmux";
      ta = "tmux attach-session -t";
      tn = "tmux new-session -s";
      tl = "tmux list-sessions";
      tk = "tmux kill-session -t";
      tka = "tmux kill-server";
      txsrc = "tmux source-file ~/.tmux.conf";
      
      # System Monitoring
      diskusg = "df -h | grep /dev/nvme0n1p2";
    };
  };
  
  # Related shell tools configuration
  programs.starship = {
    enable = true;
  };
  
  programs.zoxide = {
    enable = true;
  };
  
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  
  # FZF fuzzy finder
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [ "--height 40%" "--border" ];
  };
  
  # Bat for syntax highlighting
  programs.bat = {
    enable = true;
  };
}
