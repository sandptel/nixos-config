{ pkgs, ... }:
{
  imports = [
    ./wayland.nix
    ./hyprland.nix
    ./gnome.nix
  ];

  environment.systemPackages = with pkgs; [
    libnotify
    networkmanagerapplet
    pavucontrol
    nwg-look
    libappindicator
  ];

  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      fira-code
      fira-code-symbols
      rubik
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.ubuntu
      nerd-fonts.blex-mono
    ];
  };

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
