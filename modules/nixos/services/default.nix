{ ... }:
{
  # Optional network services. Comment one out to drop it.
  imports = [
    ./sharing
    ./printing.nix
    ./mdns.nix
    ./flatpak.nix
  ];
}
