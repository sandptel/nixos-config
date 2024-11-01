{
  description = "KooL's NixOS-Hyprland";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    #wallust.url = "git+https://codeberg.org/explosion-mental/wallust?ref=dev";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; # hyprland development
    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
    nixos-grub-themes.url = "github:jeslie0/nixos-grub-themes";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    wezterm.url = "github:wez/wezterm?dir=nix";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };


  };

  outputs =
    inputs @ { self
    , nixpkgs
 #   ,home-manager
 #   ,stylix
    , ...
    }:
    let
      system = "x86_64-linux";
      host = "NixOS";
      username = "antonio";
      #defaultPackage.x86_64-linux = wezterm.packages.x86_64-linux.default;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit username;
            inherit host;
          };
          modules = [
            ./hosts/${host}/config.nix
            inputs.distro-grub-themes.nixosModules.${system}.default
#            inputs.stylix.nixosModules.stylix
            inputs.spicetify-nix.nixosModules.default
            { nixpkgs.overlays = [ inputs.hyprpanel.overlay ]; }
          ];
        };
      };
    };
}
