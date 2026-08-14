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
    ./kernel.nix
    ./power.nix
    ./wifi.nix
    ./storage.nix
    ./graphics.nix
    # turing off howdy because of the shit it brings without any usability
    # ./howdy.nix
    ../../modules/nixos/core
    ../../modules/nixos/dev
    ../../modules/nixos/desktop
    ../../modules/nixos/packages.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.supportedFilesystems = [ "ntfs" "exfat" ];
  boot.loader.efi.canTouchEfiVariables = true;

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
    ];
    shell = pkgs.fish;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data were taken. Leave at first-install version.
  system.stateVersion = "26.05";
}
