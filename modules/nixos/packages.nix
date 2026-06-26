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
  services.cloudflare-warp.enable = true;


  environment.systemPackages = with pkgs; [
    # Add packages here.
    spotify
    vlc
    cloudflare-warp
    playerctl
    motrix-next

    google-chrome
    mpv
  ];
}
