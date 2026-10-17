{ config, pkgs, username, ... }:
{
  imports = [
    ./shell
    ./dev
    ./packages.nix
  ];

  home.stateVersion = "26.05";
  home.enableNixpkgsReleaseCheck = false;
  # Add user-level Home Manager settings here.
}
