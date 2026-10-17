{ pkgs, ... }:
{
  # Add your Wayland compositor config here.
  # Programs running in XWayland can have blurry text on HiDPI displays.
  programs.xwayland.enable = true;

  # Hints Electron/Chromium apps to use Wayland natively.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable polkit for privilege escalation (e.g., when a GUI app asks for root password)
  security.polkit.enable = true;
}
