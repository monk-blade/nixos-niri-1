{ pkgs, ... }:

{
  # Enable Stylix for system-wide theming
  stylix.enable = true;
  
  # Base16 color scheme - you can change this to any base16 theme
  # Popular options: "gruvbox-dark-hard", "nord", "dracula", "tokyo-night-dark", "catppuccin-mocha"
stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";

  # Set wallpaper (Stylix can generate colors from your wallpaper)
  stylix.image = ../../dotfiles/.config/backgrounds/texture.jpg;
  
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
  
  # Override specific colors to match Moonfly background
  stylix.override = {
    # Moonfly-inspired background colors
    base00 = "080808"; # Main background (very dark)
    base01 = "1c1c1c"; # Slightly lighter background
    base02 = "262626"; # Selection background
    base03 = "444444"; # Comments, invisibles
    
    # Keep Catppuccin Mocha for other colors
    # base04, base05, base06, base07 (foreground colors) - keep default
    # base08-base0F (accent colors) - keep default Catppuccin Mocha
  };
}
