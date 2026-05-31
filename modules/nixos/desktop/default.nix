{ pkgs, ... }:
{
  imports = [
    ./wayland.nix
    ./hyprland.nix
    ./gnome.nix
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [
        "hyprland"
        "gtk"
      ];
      gnome.default = [
        "gnome"
        "gtk"
      ];
    };
  };

}
