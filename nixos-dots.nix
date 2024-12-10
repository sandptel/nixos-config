{ home-manager, system, inputs, config, lib, pkgs, ... }:

with lib;

let
    cfg = config.nixos-dots;
in
{
  options.nixos-dots = {
    enable = mkEnableOption "Add dotfiles";
  };

  config = mkIf cfg.enable {

programs.pywal16.enable=true;

programs.kitty={
  enable = true;
  shellIntegration.enableFishIntegration=true;
  extraConfig = ''
# wallust-colors
#include kitty-colors.conf 

font_family Fira Code SemiBold
font_size 14.8
bold_font auto
italic_font auto
bold_italic_font auto

background_opacity 0.25
confirm_os_window_close 0

# change to x11 or wayland or leave auto
linux_display_server auto

scrollback_lines 2000
wheel_scroll_min_lines 1

enable_audio_bell no

window_padding_width 4

selection_foreground none
selection_background none

foreground #dddddd
background #000000
cursor #dddddd
  
   '';
 };

wayland.windowManager.hyprland = {
  enable = true;
  extraConfig = ''
  # /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
# Sourcing external config files

exec-once = dconf write /org/gnome/desktop/interface/gtk-theme "'gruvbox-dark'"
exec-once = dconf write /org/gnome/desktop/interface/icon-theme "'Flat-Remix-Blue-Dark'"

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
    #inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursorsssssss
    # inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
  ];
};


home.sessionVariables.GTK_THEME = "gruvbox-dark";

programs.vscode.enable=true;

home.packages = with pkgs;[
# airshipper
pywalfox-native
solarc-gtk-theme
wl-clipboard
hyprlock
matugen
];

home.file.".config/ags".source = config.lib.file.mkOutOfStoreSymlink ./config/ags;
home.file.".config/btop".source = config.lib.file.mkOutOfStoreSymlink ./config/btop;
home.file.".config/cava".source = config.lib.file.mkOutOfStoreSymlink ./config/cava;
home.file.".config/fastfetch".source = config.lib.file.mkOutOfStoreSymlink ./config/fastfetch;
# home.file.".config/hypr".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr;
home.file.".config/kitty/kitty-colors.conf".source = config.lib.file.mkOutOfStoreSymlink ./config/kitty/kitty-colors.conf;
home.file.".config/Kvantum".source = config.lib.file.mkOutOfStoreSymlink ./config/Kvantum;
home.file.".config/qt5ct".source = config.lib.file.mkOutOfStoreSymlink ./config/qt5ct;

home.file.".config/swappy".source = config.lib.file.mkOutOfStoreSymlink ./config/swappy;
home.file.".config/swaync".source = config.lib.file.mkOutOfStoreSymlink ./config/swaync;
# home.file.".config/wallrust".source = config.lib.file.mkOutOfStoreSymlink ./config/wallrust;
# home.file.".config/waybar".source = config.lib.file.mkOutOfStoreSymlink ./config/waybar;
home.file.".config/wlogout".source = config.lib.file.mkOutOfStoreSymlink ./config/wlogout;

 home.file.".config/hypr/configs".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr/configs;
 home.file.".config/hypr/scripts".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr/scripts;
 home.file.".config/hypr/UserConfigs".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr/UserConfigs;
 home.file.".config/hypr/UserScripts".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr/UserScripts;
 home.file.".config/hypr/hypridle.conf".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr/hypridle.conf;
 home.file.".config/hypr/hyprlock-2k.conf".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr/hyprlock-2k.conf;
 home.file.".config/hypr/initial-boot.sh".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr/initial-boot.sh;
 home.file.".config/hypr/v2.3.7".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr/v2.3.7;


# home.file.".config/rofi" = {
#   source = config.lib.file.mkOutOfStoreSymlink ./config/rofi;
#   # recursive = true;
#   # executable = true;
# };
  };
}
