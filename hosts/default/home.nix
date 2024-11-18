{ config,lib,inputs,pkgs, ... }:
{
  imports=[
    # ./hypr.nix
    inputs.hyprland.homeManagerModules.default
];
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
#     }
#   };

wayland.windowManager.hyprland = {
  enable = true;
  extraConfig = ''
  # /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
# Sourcing external config files

# Default Configs
$configs = $HOME/.config/hypr/configs

source=$configs/Settings.conf
source=$configs/Keybinds.conf

# User Configs
$UserConfigs = $HOME/.config/hypr/UserConfigs

source= $UserConfigs/Startup_Apps.conf
source= $UserConfigs/ENVariables.conf
source= $UserConfigs/Monitors.conf
source= $UserConfigs/Laptops.conf
source= $UserConfigs/LaptopDisplay.conf
source= $UserConfigs/WindowRules.conf
source= $UserConfigs/UserDecorAnimations.conf
source= $UserConfigs/UserKeybinds.conf
source= $UserConfigs/UserSettings.conf
source= $UserConfigs/WorkspaceRules.conf
  '';
  plugins = [
    inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
  ];
};

# hyprland.extraConfig = ''
# # plugin = ${inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors}/lib/libhypr-dynamic-cursors.so
# #plugin = ${inputs.Hyprspace.packages.${pkgs.system}.Hyprspace}/lib/libHyprspace.so
# #plugin:overview:reverseSwipe =true;
# #plugin:overview:disableGestures =true;plugin:overview:disableGestures
# # exec-once = dconf write /org/gnome/desktop/interface/gtk-theme "'gruvbox-dark'"
# # exec-once = dconf write /org/gnome/desktop/interface/icon-theme "'oomox-Everforest-Dark'"
# # exec-once = dconf write /org/gnome/desktop/interface/document-font-name "'Noto Sans Medium 11'"
# # exec-once = dconf write /org/gnome/desktop/interface/font-name "'Noto Sans Medium 11'"
# # exec-once = dconf write /org/gnome/desktop/interface/monospace-font-name "'Noto Sans Mono Medium 11'"
# '';


# wayland.windowManager.hyprland = {
#     # enable = true;
#     # ...
#     plugins = [
#       # inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
#        inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
#       # ...
#     ];
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
