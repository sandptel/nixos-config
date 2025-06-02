{ home-manager, system, inputs, config, lib, pkgs, ... }:

with lib;

let
    cfg = config.nixos-dots;
    checkupdates= pkgs.writeShellScriptBin "checkupdates" ''
    ${pkgs.uutils-coreutils-noprefix}/bin/echo "This is a pseudo package to check for updates"
    exit 0
    '';
in
{
  options.nixos-dots = {
    enable = mkEnableOption "Add dotfiles";
  };

  config = mkIf cfg.enable {

programs.pywal16.enable=true;

home.packages = with pkgs;[
gifsicle
matugen
nwg-drawer
checkupdates
wpgtk
tmux
hyprls
# gnome-tweaks
# airshipper
pywalfox-native
solarc-gtk-theme
wl-clipboard
hyprlock
matugen
];

#script for wpgtk
# home.activation= {
#   wpgtk = lib.hm.dag.entryAfter ["writeBoundary"] ''
#     ${pkgs.wpgtk}/bin/wpg-install.sh -i -g
#     ${pkgs.wpgtk}/bin/wpg --preview
#   '';
# };

# home.sessionVariables.GTK_THEME = "linea-nord-color";

gtk = {
    enable = true;
    # font.name = "JetBrains Mono Nerd Font";
    # font.size = 12.5;
    # font.package = pkgs.jetbrains-mono;
    iconTheme.name = "Flat-Remix-Blue-Dark";
    iconTheme.package = pkgs.flat-remix-icon-theme;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      # gtk-key-theme-name = "linea-nord-color";
      # gtk-icon-theme-name   = "flattr";
      gtk-cursor-theme-name = "Bibata-Modern-Ice";
    };
  };

  home.file.".icons/default".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Ice";
  home.sessionVariables = {
    XCURSOR_SIZE = 24;
    XCURSOR_THEME = "Bibata-Modern-Ice";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # gtk-key-theme = "linea-nord-color";
      cursor-theme = "Bibata-Modern-Ice";
    };
  };

  xdg.systemDirs.data = [
    "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
  ];


services.kdeconnect.enable = true;

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
  # /* ---- 👒 https://github.com/sandptel/nixos-config ---- */  #
# Sourcing external config files

# exec-once = dconf write /org/gnome/desktop/interface/gtk-theme "'linea-nord-color'"
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
source= $UserConfigs/Scratchpads.conf

#pywal colors #https://github.com/alexhulbert/SeaGlass
source = ~/.cache/wal/colors-hyprland.conf

# #hyprchroma
# windowrulev2 = plugin:chromakey,fullscreen:0
# chromakey_background = 7,8,17
# bind = Super SHIFT,O, togglechromakey

# plugin = ${inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors}/lib/libhypr-dynamic-cursors.so

plugin:overview:reverseSwipe =true;

  '';

  xwayland.enable=true;
  plugins = [
    inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
    # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
    # inputs.hyprchroma.packages.${pkgs.system}.default
  ];
};

mascot.shimeji.enable=true;

programs.vscode.enable=true;

home.file.".config/ags".source = config.lib.file.mkOutOfStoreSymlink ./config/ags;
home.file.".config/btop".source = config.lib.file.mkOutOfStoreSymlink ./config/btop;
home.file.".config/cava/shaders".source = config.lib.file.mkOutOfStoreSymlink ./config/cava/shaders;
# home.file.".config/cava/config".source = config.lib.file.mkOutOfStoreSymlink ./config/cava/config;
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

home.file.".config/wallust/wallust.toml".source = config.lib.file.mkOutOfStoreSymlink ./config/wallust/wallust.toml;

 home.file.".config/hypr/configs".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr/configs;
 home.file.".config/hypr/scripts".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr/scripts;
 home.file.".config/hypr/UserConfigs".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr/UserConfigs;
 home.file.".config/hypr/UserScripts".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr/UserScripts;
 home.file.".config/hypr/hypridle.conf".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr/hypridle.conf;
 home.file.".config/hypr/hyprlock.conf".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr/hyprlock.conf;
 home.file.".config/hypr/initial-boot.sh".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr/initial-boot.sh;
 home.file.".config/hypr/v2.3.7".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr/v2.3.7;
 home.file.".config/hypr/pyprland.toml".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr/pyprland.toml;

home.file.".config/wal/templates/colors-hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink ./config/wal/templates/colors-hyprland.conf;
home.file.".config/wal/templates/obsidian.css".source = config.lib.file.mkOutOfStoreSymlink ./config/wal/templates/obsidian.css;

home.file.".config/wal/templates/spicetify.ini".source = config.lib.file.mkOutOfStoreSymlink ./config/wal/templates/spicetify.ini ;
home.file.".config/spicetify/config-xpui.ini".source = config.lib.file.mkOutOfStoreSymlink ./config/spicetify/config-xpui.ini;

# home.file.".config/rofi" = {
#   source = config.lib.file.mkOutOfStoreSymlink ./config/rofi;
#   # recursive = true;
#   # executable = true;
# };
  };
}