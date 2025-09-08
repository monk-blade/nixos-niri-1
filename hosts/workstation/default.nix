{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    
    # Home Manager integration
    inputs.home-manager.nixosModules.home-manager
    {
      # home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;  
      home-manager.users.abbes = import ./home.nix;
      home-manager.backupFileExtension = "backup";
      # Pass flake inputs to home-manager
      home-manager.extraSpecialArgs = { inherit inputs; };
    }
  ];
}
