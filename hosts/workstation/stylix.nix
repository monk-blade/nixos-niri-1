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
  
  # Override specific colors
  stylix.override = {
    # Base colors - slightly softer dark tones
    base00 = "121212";  # Softer dark background (was 0a0a0a)
    base01 = "1e1e1e";  # Slightly lighter than base00 (was 1a1a1a)
    base02 = "2a2a3a";  # Selection background - softer (was 252535)
    base03 = "505060";  # Comments, invisibles - softer (was 4a4a5a)
    # base04 = "809980"
    # base05 = "8ca68c"
    # base06 = "cfe8cf"
    # base07 = "f4fbf4"
    # base08 = "e6193c"
    # base09 = "87711d"
    # base0A = "98981b"
    # base0B = "29a329"
    # base0C = "1999b3"
    # base0D = "3d62f5"
    # base0E = "ad2bee"
    # base0F = "e619c3"
  };
}
