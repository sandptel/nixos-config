{
  description = "KooL's NixOS-Hyprland";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
#    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
    nixos-grub-themes.url = "github:jeslie0/nixos-grub-themes";
     grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
    };
  #  home-manager.url = "github:nix-community/home-manager/master";
  #  home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    wezterm.url = "github:wez/wezterm?dir=nix";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
#    spicetify-nix = {
 #     url = "github:Gerg-L/spicetify-nix";
 #     inputs.nixpkgs.follows = "nixpkgs";
 #   };
};
  outputs =
    inputs @ { self
    , nixpkgs
    , ...
    }:
    let
      system = "x86_64-linux";
      host = "nixos";
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
 #           inputs.distro-grub-themes.nixosModules.${system}.default
            inputs.grub2-themes.nixosModules.default
            inputs.spicetify-nix.nixosModules.default
            { nixpkgs.overlays = [ inputs.hyprpanel.overlay ]; }
          ];
        };
      };
    };
}
