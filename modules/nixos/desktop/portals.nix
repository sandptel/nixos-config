{ pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config = {
      # gtk has no ScreenCast iface -> any compositor missing an entry here
      # falls through to common.default and loses screen share / recording.
      common.default = [ "gtk" ];
      hyprland.default = [ "hyprland" "gtk" ];
      gnome.default = [ "gnome" "gtk" ];
      niri.default = [ "gnome" "gtk" ]; # niri ships no portal -> gnome provides ScreenCast
    };
  };
}
