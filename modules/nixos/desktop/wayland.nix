{ pkgs, ... }:
{
  # Add your Wayland compositor config here.
  # Programs running in XWayland can have blurry text on HiDPI displays.
  programs.xwayland.enable = true;
}
