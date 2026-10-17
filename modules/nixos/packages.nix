{ pkgs, ... }:
# General GUI apps not owned by any module group.
# (firefox -> desktop/browser.nix, warp -> core/networking.nix, mtr -> dev/networks.nix,
#  nm-applet/seahorse/dconf -> desktop/packages.nix)
{
  environment.systemPackages = with pkgs; [
    spotify
    vlc
    rayburst # was motrix-next; renamed upstream, history not migrated
    google-chrome
    mpv
  ];
}
