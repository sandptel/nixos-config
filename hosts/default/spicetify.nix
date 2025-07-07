{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  # if spotify does not open --> https://discourse.nixos.org/t/suddenly-cant-open-spotify-on-nixos/38649/4
  # `rm -rf ~/.cache/spotify` --> This should do |)
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
      "slack"
    ];
  # spicetify nixosModule technically cannot update using pywal colorss
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  # configure spicetify :)
  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        #  adblock
        #  hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];
      theme = spicePkgs.themes.defaultDynamic;
      #  colorScheme = "mocha";
    };

  #pywal spicetify won't work for a number of reasons
  # 1. spicetify is shit when it comes anything dynamic :) <does not refresh when refreshed> <backup problem might try later> --> info Spotify cannot be backed up at this state. Please re-install Spotify then run "spicetify backup apply".
  # 2. can't use nix module as will need to do home-manager switch

  # therefore I shall use normal spicetify to update the colors
  # home.packages = with pkgs; [
  #   spicetify-cli
  #   # spotify # for this to work use the flatpak spotify package instead
  # ];
  # this config already has Pywal as the current theme and path for flatpak spotify
  # can't get this shit working added in nixos-dots :(
  # home.file.".config/wal/templates/spicetify.ini".source = config.lib.file.mkOutOfStoreSymlink ../../config/wal/templates/spicetify.ini ;
  # home.file.".config/spicetify/config-xpui.ini".source = config.lib.file.mkOutOfStoreSymlink ../../config/spicetify/config-xpui.ini;
  # home.activation = {
  # spicetify-pywal = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   run ${pkgs.spicetify-cli}/bin/spicetify backup apply
  # '';
  # };
}
