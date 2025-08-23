{ pkgs, ... }:

let
  locals = import ./locals.nix { inherit pkgs; };
in
{
  # Enable Stylix for system-wide theming
  stylix.enable = true;
  
  # Base16 color scheme - you can change this to any base16 theme
  # Popular options: "gruvbox-dark-hard", "nord", "dracula", "tokyo-night-dark", "catppuccin-mocha"
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  # Set wallpaper from locals.nix (Stylix can generate colors from your wallpaper)
  stylix.image = locals.wallpaper;
  
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
  
  # Override specific colors - Darker Catppuccin Mocha
  stylix.override = {
    # Base colors - darker variants of Catppuccin Mocha
    base00 = "0b0b0f";  # Darker base (original: 1e1e2e)
    base01 = "131318";  # Darker mantle (original: 181825)
    base02 = "1a1a24";  # Darker surface0 (original: 313244)
    base03 = "2a2a3e";  # Darker surface1 (original: 45475a)
    base04 = "3a3a54";  # Darker surface2 (original: 585b70)
    base05 = "b8b8d1";  # Text (slightly dimmed from original: cdd6f4)
    base06 = "c8c8e1";  # Subtext0 (slightly dimmed from original: f2cdcd)
    base07 = "d8d8f1";  # Subtext1 (slightly dimmed from original: f5e0dc)
    base08 = "e78284";  # Red (slightly dimmed from original: f38ba8)
    base09 = "e5a890";  # Peach (slightly dimmed from original: fab387)
    base0A = "e2d065";  # Yellow (slightly dimmed from original: f9e2af)
    base0B = "a4c884";  # Green (slightly dimmed from original: a6e3a1)
    base0C = "7dc4e4";  # Teal (slightly dimmed from original: 94e2d5)
    base0D = "7287fd";  # Blue (slightly dimmed from original: 89b4fa)
    base0E = "c6a0f6";  # Mauve (slightly dimmed from original: cba6f7)
    base0F = "e78284";  # Flamingo (slightly dimmed from original: f2cdcd)
  };
}
