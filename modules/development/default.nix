{ config, lib, pkgs, ... }:

{
  # Development tools
  environment.systemPackages = with pkgs; [
    # Languages and runtimes
    nodejs_20
    python3
    python3Packages.pip
    python3Packages.virtualenv
    rustc
    cargo
    go
    # jdk17
    
    # Build tools
    gcc
    gnumake
    cmake
    pkg-config
    
    # Version control (git is in home-manager)
    gh
    gitui
    
    # Editors and IDEs
    vscode
    # vim and neovim are in home-manager
    
    # Terminal tools
    tmux
    # alacritty is in home-manager
    kitty
    
    # Development utilities (curl/wget are in common)
    jq
    httpie
    postman
    
    # Database tools
    # sqlite
    # postgresql
    
    # Container tools (docker-compose is in docker module)
    
    # System tools
    btop
    tree
    fd
    ripgrep
    bat
    exa
    fzf
    
    # Network tools
    # nmap
    # wireshark
    # tcpdump
  ];
  
  # Enable development services
  programs.git.enable = true;
  
  # Shell improvements
  programs.fish.enable = true;
  
  # Enable direnv for project environments
  programs.direnv.enable = true;
}
