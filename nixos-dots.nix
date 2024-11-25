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

home.file.".config/ags".source = config.lib.file.mkOutOfStoreSymlink ./config/ags;
home.file.".config/btop".source = config.lib.file.mkOutOfStoreSymlink ./config/btop;
home.file.".config/cava".source = config.lib.file.mkOutOfStoreSymlink ./config/cava;
home.file.".config/fastfetch".source = config.lib.file.mkOutOfStoreSymlink ./config/fastfetch;
# home.file.".config/hypr".source = config.lib.file.mkOutOfStoreSymlink ./config/hypr;
home.file.".config/kitty".source = config.lib.file.mkOutOfStoreSymlink ./config/kitty;
home.file.".config/Kvantum".source = config.lib.file.mkOutOfStoreSymlink ./config/Kvantum;
home.file.".config/qt5ct".source = config.lib.file.mkOutOfStoreSymlink ./config/qt5ct;

home.file.".config/swappy".source = config.lib.file.mkOutOfStoreSymlink ./config/swappy;
home.file.".config/swaync".source = config.lib.file.mkOutOfStoreSymlink ./config/swaync;
# home.file.".config/wallrust".source = config.lib.file.mkOutOfStoreSymlink ./config/wallrust;
home.file.".config/waybar".source = config.lib.file.mkOutOfStoreSymlink ./config/waybar;
home.file.".config/wlogout".source = config.lib.file.mkOutOfStoreSymlink ./config/wlogout;


# home.file.".config/rofi" = {
#   source = config.lib.file.mkOutOfStoreSymlink ./config/rofi;
#   # recursive = true;
#   # executable = true;
# };
  };
}