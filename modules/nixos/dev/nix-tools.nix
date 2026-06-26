{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Add packages here.
    nixfmt
    nix-ld
    nixd
    nixdoc
  ];

  programs.nix-ld.enable = true;

  nix.settings.trusted-users =  [ "root" "@wheel" "bushido" ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
