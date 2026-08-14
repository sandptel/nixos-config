{
  description = "Nix flake for my personal configuration. It includes a NixOS configuration for my laptop and a Home Manager configuration for my user.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/v4.7.7";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Optional: experimental Ryzen NPU stack (use only when ready).
    nix-amd-ai.url = "github:noamsto/nix-amd-ai";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      host = "bushido";
      username = "bushido";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      overlays.default = import ./pkgs;

      nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs host username; };
        modules = [
          ./hosts/${host}/configuration.nix

          (
            { ... }:
            {
              nixpkgs.overlays = [ self.overlays.default ];
            }
          )

          home-manager.nixosModules.home-manager
          (
            { ... }:
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs host username; };
              home-manager.users.${username} = import ./modules/home/home.nix;
            }
          )
        ];
      };
    };
}
