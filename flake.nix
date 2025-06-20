{
  description = "sandptel's Hyprland Dots";
  inputs = {
    #customkernel.url = "path:/home/roronoa/risc-v-kernelci";
   regolith.url = "github:regolith-lab/regolith-nix";
    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      # url = "github:KZDKM/Hyprspace";
      # Hyprspace uses latest Hyprland. We declare this to keep them in sync.
      inputs.hyprland.follows = "hyprland";
    };
    # firefox.url= "github:nix-community/flake-firefox-nightly";
    nix-gaming.url = "github:fufexan/nix-gaming";
    # hellwal.url = "github:sandptel/hellwal";
    # nixos-cosmic = {
    # url = "github:lilyinstarlight/nixos-cosmic";
    # # inputs.nixpkgs.follows = "nixpkgs";
    # };
    
    shimeji.url = "github:sandptel/shimeji-nix";

    nixvim = {
      url = "github:nix-community/nixvim/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matugen = {
    url = "github:/InioX/Matugen";
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
    hyprchroma = {
      url = "github:alexhulbert/Hyprchroma";
      inputs.hyprland.follows = "hyprland";
    };
    hyprfocus = {
      url = "github:VortexCoyote/hyprfocus";
      inputs.hyprland.follows = "hyprland";
    };
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland"; # hyprland development
    # hyprland.url = "github:hyprwm/Hyprland"; # hyprland development
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
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
   };
   hypr-dynamic-cursors = {
        url = "github:VirtCode/hypr-dynamic-cursors";
        # url = "github:VirtCode/hypr-dynamic-cursors";
        inputs.hyprland.follows = "hyprland"; # to make sure that the plugin is built for the correct version of hyprland
    };
    nixos-boot.url = "github:Melkor333/nixos-boot";
    zen-browser.url = "https://flakehub.com/f/youwen5/zen-browser/0.1.171";
#        url = "github:notashelf/nvf";
#        inputs.nixpkgs.follows = "nixpkgs";
#    };
};
  outputs =
    inputs @ { self
    , nixpkgs
    , home-manager
    , ...
    }:
    let
      system = "x86_64-linux";
      host = "default";
      username = "roronoa";
      lib=nixpkgs.lib;
      config = { allowUnfree = true; };
      #defaultPackage.x86_64-linux = wezterm.packages.x86_64-linux.default;
      pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
    in
    {
      # packages.x86_64-linux.homeConfigurations = pkgs.callPackage ./hosts/default/home.nix { inherit lib config; };
      # homeConfigurations= {
      #       "roronoa" = home-manager.lib.homeManagerConfiguration {
      #           # Note: I am sure this could be done better with flake-utils or something
      #           pkgs = import nixpkgs { system = "x86_64-linux"; };

      #           modules = [ ./hosts/default/home.nix ]; # Defined later
      #       };
      #   };
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
            ./cosmic.nix
           inputs.regolith.nixosModules.regolith
            inputs.nixos-boot.nixosModules.default
            inputs.hyprland.nixosModules.default
 #           inputs.distro-grub-themes.nixosModules.${system}.default
            inputs.grub2-themes.nixosModules.default
            inputs.spicetify-nix.nixosModules.default
            inputs.chaotic.nixosModules.default
            inputs.elanmoc2.nixosModules.elanmoc2
            inputs.nixvim.nixosModules.nixvim
            # inputs.zen-browser.packages."${system}".generaic
            #inputs.stylix.nixosModules.default
            #inputs.catppuccin.homeManagerModules.catppuccin
            { nixpkgs.overlays = [ inputs.hyprpanel.overlay ]; }
          ];
        };
      };
    };
}
