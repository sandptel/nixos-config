{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Add packages here.
    nixfmt
    nix-ld
    nixd
    nixdoc
  ];

  programs.nix-ld.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
