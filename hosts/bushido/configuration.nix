{
  inputs,
  config,
  pkgs,
  host,
  username,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./boot.nix
    ./kernel.nix
    ./power.nix
    ./wifi.nix
    ./storage.nix
    ./graphics.nix
    # ./howdy.nix # face unlock -> more breakage than usability, see file
    ../../modules/nixos/core
    ../../modules/nixos/services
    ../../modules/nixos/gaming
    ../../modules/nixos/dev
    ../../modules/nixos/desktop
    ../../modules/nixos/packages.nix
  ];

  networking.hostName = host;

  nixpkgs.config.allowUnfree = true;

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "wireshark"
      "uinput" 
    ];
    shell = pkgs.fish;
  };

  hardware.uinput.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data were taken. Leave at first-install version.
  system.stateVersion = "26.05";
}
