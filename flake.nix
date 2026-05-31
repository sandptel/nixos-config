{
  description = "A modular NixOS flake with Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
    in
    {
      overlays.default = import ./pkgs;

      nixosConfigurations.bushido = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/bushido/configuration.nix

          ({ ... }: {
            nixpkgs.overlays = [ self.overlays.default ];
          })

          home-manager.nixosModules.home-manager
          ({ ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
          })
        ];
      };
    };
}
