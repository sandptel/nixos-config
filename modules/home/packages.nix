{ pkgs, ... }:
{
  # User-level packages.
  home.packages = with pkgs; [
    # Add packages here.
    grc
  ];
}
