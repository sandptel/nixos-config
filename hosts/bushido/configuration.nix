{ inputs, config, pkgs, ... }:
let
  username = "bushido";
in
{
  imports = [
    ./hardware.nix
    ./amd.nix
    ../../modules/nixos/core
    ../../modules/nixos/desktop
    ../../modules/nixos/packages.nix
  ];

  networking.hostName = "bushido";

  # Change this username to match your primary user.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    # Add extra groups and user settings here.
  };

  home-manager.users.${username} = {
    imports = [
      ../../modules/home/desktop
      ../../modules/home/shell
      ../../modules/home/dev
      ../../modules/home/packages.nix
    ];

    home.stateVersion = "25.05";
    # Add user-level Home Manager settings here.
  };

  system.stateVersion = "25.05";
}
