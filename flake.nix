{
  description = "NixOS configuration with existing dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:nix-community/stylix/release-24.05";
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }@inputs: {
    nixosConfigurations = {
      # Replace "nixos-vm" with your hostname
      abbes = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          stylix.nixosModules.stylix
          
          # Home Manager integration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.abbes = import ./home.nix;
            home-manager.backupFileExtension = "backup";
            # Pass flake inputs to home-manager
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}