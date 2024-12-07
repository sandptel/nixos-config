{ config,lib,inputs,pkgs, ... }:
{
  imports=[
    ../../nixos-dots.nix
    # ./hypr.nix
    inputs.hyprland.homeManagerModules.default
    # inputs.matugen.homeManagerModules.default
];
nixos-dots.enable = true;
# home.configFile."<path>".source = "${config.programs.matugen.theme.files}/<template_output_path>";

# home.file.".config/gtk-4.0/gtk.css".source = "${config.programs.matugen.theme.files}/.config/gtk-4.0/gtk.css";

# home.file.".config/gtk-3.0/gtk.css".source = "${config.programs.matugen.theme.files}/.config/gtk-3.0/gtk.css";

  home.username = "roronoa";
  home.homeDirectory = "/home/roronoa";
  home.enableNixpkgsReleaseCheck = false;
 
# module.phcontrol.enable=true;

# programs.kitty={
#   enable = true;
#   extraConfig = ''
#   font_size 14
#   background_opacity 0.1
#   '';
# };

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
plugin:overview:reverseSwipe =true;
  '';

  xwayland.enable=true;
  plugins = [
    inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
    # inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
  ];
};


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
matugen
];

  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

}  
