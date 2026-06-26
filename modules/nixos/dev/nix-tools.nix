{ pkgs, username, ... }: {
  environment.systemPackages = with pkgs; [
    nixfmt
    nix-ld
    nixd
    nixdoc
  ];

  programs.nix-ld.enable = true;

  nix.settings.trusted-users = [ "root" "@wheel" username ];

  # direnv is managed at the user level in modules/home/shell/utilities.nix.
}
