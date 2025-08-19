# Manual theme configuration (alternative to Stylix)
# You can use this if you prefer more control over individual app theming

{ pkgs, ... }:

let
  # Define your color palette
  colors = {
    # Base colors (dark theme)
    bg = "#1d2021";           # Dark background
    bg-alt = "#282828";       # Alternative background
    fg = "#ebdbb2";           # Foreground text
    fg-alt = "#a89984";       # Alternative foreground
    
    # Accent colors
    red = "#cc241d";
    green = "#98971a";
    yellow = "#d79921";
    blue = "#458588";
    purple = "#b16286";
    aqua = "#689d6a";
    orange = "#d65d0e";
    
    # UI colors
    border = "#504945";
    selection = "#3c3836";
    urgent = "#fb4934";
  };
  
  # Font configuration
  fonts = {
    mono = "SpaceMono Nerd Font";
    sans = "Noto Sans";
    size = {
      small = "10";
      normal = "11";
      large = "14";
    };
  };
in
{
  # This file provides color variables that can be imported by other configs
  # You would then manually configure each application to use these colors
  
  # Example usage in other configs:
  # let theme = import ./theme.nix { inherit pkgs; }; in
  # {
  #   programs.foot.settings.colors.background = theme.colors.bg;
  # }
  
  # Export the theme for use in other modules
  _module.args.theme = { inherit colors fonts; };
}
