# /globals.nix
# Shared settings for both NixOS and Home Manager
{
  # Allow unfree packages globally
  nixpkgs.config.allowUnfree = true;
}
