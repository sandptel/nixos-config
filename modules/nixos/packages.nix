{ pkgs, ... }:
# General GUI apps not owned by any module group.
# (firefox -> core/env.nix, warp -> core/networking.nix, mtr -> dev/networks.nix,
#  nm-applet/seahorse/dconf -> desktop/packages.nix)
{
  environment.systemPackages = with pkgs; [
    spotify
    vlc
    motrix-next
    google-chrome
    mpv
  ];
}
