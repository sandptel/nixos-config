{
  description = "Nix flake for my personal configuration. It includes a NixOS configuration for my laptop and a Home Manager configuration for my user.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/v5.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      # nixpkgs is not instantiated here -> nixosSystem builds its own pkgs from
      # `system` + the modules' nixpkgs.config (allowUnfree in configuration.nix).
    in
    {
      checks.${system}.dotfiles =
        nixpkgs.legacyPackages.${system}.callPackage ./modules/nixos/core/dotfiles-test.nix
          { };

      nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs host username; };
        modules = [
          ./hosts/${host}/configuration.nix

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
