{ pkgs, ... }:
{
  programs = {
    firefox.enable = true;
    nm-applet.enable = true;
    seahorse.enable = true;
    dconf.enable = true;
    mtr.enable = true;
  };
  # System-wide packages.
  environment.systemPackages = with pkgs; [
    # Add packages here.
    spotify
    vlc
    playerctl
  ];
}
