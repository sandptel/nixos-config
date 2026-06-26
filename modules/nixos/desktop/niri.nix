{ pkgs, ... }:
{
  # Enable the Niri Wayland compositor
  programs.niri = {
    enable = true;
  };

  # Essential Wayland environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Hints Electron/Chromium apps to use Wayland natively
  };

  environment.systemPackages = with pkgs; [
    polkit_gnome  # GUI prompt for asking for passwords
  ];
}