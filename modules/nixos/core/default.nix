{ ... }:
{
  imports = [
    ./keyd.nix
    ./networking.nix
    ./audio.nix
    ./diagnostics.nix
    ./locale.nix
    ./shell.nix
    ./packages.nix
    ./scheduler.nix
    ./firmware.nix
    ./nix.nix
    ./logging.nix
    ./dotfiles.nix
  ];
}
