{
  description = "KooL's NixOS-Hyprland";

  inputs = {
    Hyprspace = {
      url = "github:KZDKM/Hyprspace/260f386075c7f6818033b05466a368d8821cde2d";
      # Hyprspace uses latest Hyprland. We declare this to keep them in sync.
      inputs.hyprland.follows = "hyprland";
    };
    matugen = {
    url = "github:/sandptel/Matugen";
  };
    elanmoc2.url= github:sandptel/elanmoc2;
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    # hyprsplit.url = "github:shezdy/hyprsplit";
    #wallust.url = "git+https://codeberg.org/explosion-mental/wallust?ref=dev";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland/1ba050d603dca644aca48872f62388d794c030b9"; # hyprland development
#    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
    nixos-grub-themes.url = "github:jeslie0/nixos-grub-themes";
     grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
    };
    #hypr-contrib.url = "github:hyprwm/contrib";
    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-init = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  #  home-manager.url = "github:nix-community/home-manager/master";
  #  home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    wezterm.url = "github:wez/wezterm?dir=nix";
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
   };
   hypr-dynamic-cursors = {
        url = "github:VirtCode/hypr-dynamic-cursors/81f4b964f997a3174596ef22c7a1dee8a5f616c7";
        inputs.hyprland.follows = "hyprland"; # to make sure that the plugin is built for the correct version of hyprland
    };
    nixos-boot.url = "github:Melkor333/nixos-boot";
    zen-browser.url = "github:sandptel/zen-browser-flake";
#        url = "github:notashelf/nvf";
#        inputs.nixpkgs.follows = "nixpkgs";
#    };
};
  outputs =
    inputs @ { self
    , nixpkgs
    , ...
    }:
    let
      system = "x86_64-linux";
      host = "default";
      username = "roronoa";
      #defaultPackage.x86_64-linux = wezterm.packages.x86_64-linux.default;
      pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
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
            
            inputs.nixos-boot.nixosModules.default
            inputs.hyprland.nixosModules.default
 #           inputs.distro-grub-themes.nixosModules.${system}.default
            inputs.grub2-themes.nixosModules.default
            inputs.spicetify-nix.nixosModules.default
            inputs.chaotic.nixosModules.default
            inputs.elanmoc2.nixosModules.elanmoc2
            # inputs.zen-browser.packages."${system}".generaic
            #inputs.stylix.nixosModules.default
            #inputs.catppuccin.homeManagerModules.catppuccin
            { nixpkgs.overlays = [ inputs.hyprpanel.overlay ]; }
          ];
        };
      };
    };
}
