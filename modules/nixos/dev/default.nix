{ ... }: {
  imports = [
    ./nix-tools.nix
    ./networks.nix
    ./packages.nix
    ./docker.nix
  ];
}
