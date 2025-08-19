{ pkgs, ... }:

{
  # Enable Stylix for system-wide theming
  stylix.enable = true;
  
  # Base16 color scheme - you can change this to any base16 theme
  # Popular options: "gruvbox-dark-hard", "nord", "dracula", "tokyo-night-dark", "catppuccin-mocha"
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  
  # Set wallpaper (Stylix can generate colors from your wallpaper)
  stylix.image = ./dotfiles/.config/backgrounds/white-tree.jpeg;
  
  # Font configuration
  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.space-mono;
      name = "SpaceMono Nerd Font";
    };
    sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };
    serif = {
      package = pkgs.noto-fonts;
      name = "Noto Serif";
    };
    sizes = {
      applications = 11;
      terminal = 14;
      desktop = 11;
      popups = 10;
    };
  };
  
  # Configure which applications to theme (using only confirmed working targets)
  stylix.targets = {
    # Desktop environment
    waybar.enable = true;
    
    # Development tools
    neovim.enable = true;
    
    # System
    console.enable = true;
    grub.enable = false; # You're using systemd-boot
  };
  
  # Override specific colors if needed
  stylix.override = {
    # Example: override the accent color
    # base0D = "ff6b6b"; # Custom red accent
  };
}
