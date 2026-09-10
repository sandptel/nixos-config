{ ... }:
{
  imports = [
    ./keyd.nix
    ./networking.nix
    ./gaming.nix
    ./env.nix
    ./sharing
    ./audio.nix
    ./printing.nix
    ./mdns.nix
    ./diagnostics.nix
    ./locale.nix
    ./shell.nix
    ./flatpak.nix
    ./packages.nix
    ./scheduler.nix
    ./firmware.nix
    ./nix.nix
  ];
}
