{ config,lib,inputs,pkgs, ... }:
{
  home.username = "roronoa";
  home.homeDirectory = "/home/roronoa";
  home.enableNixpkgsReleaseCheck = false;
 
# module.phcontrol.enable=true;

programs.kitty={
  enable = true;
  extraConfig = ''
  font_size 14
  background_opacity 0.1
  '';
};

# gtk = {
#     enable = true;
#     iconTheme = {
#       name = "SolArc-Dark";
#       package = pkgs.solarc-gtk-theme;
#     };
#   };

home.sessionVariables.GTK_THEME = "gruvbox-dark";

home.packages = with pkgs;[
# airshipper
kitty
solarc-gtk-theme
wl-clipboard
hyprlock
];

  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

}  