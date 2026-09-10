{ pkgs, username, ... }: {
  environment.systemPackages = with pkgs; [
    nixfmt # nixd (LSP) is scoped to the helix wrapper in modules/home/dev/helix.nix
    nixdoc
  ];

  programs.nix-ld.enable = true;

  nix.settings.trusted-users = [ "root" "@wheel" username ];

  # direnv is managed at the user level in modules/home/shell/utilities.nix.
}
