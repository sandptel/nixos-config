{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];
  programs.noctalia-shell = {
    enable = true;
  };

  # Shell-specific extras only. wl-clipboard/grim/slurp/networkmanagerapplet
  # come from modules/nixos/desktop/packages.nix -- duplicating them here just
  # shadows the system copy with a second closure.
  home.packages = with pkgs; [
    pywalfox-native
    cava
    krabby
  ];
}
