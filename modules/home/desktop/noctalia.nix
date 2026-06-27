{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];
  programs.noctalia-shell = {
    enable = true;
  };

  home.packages = with pkgs; [
    # but you can add extras here
    wl-clipboard # Wayland clipboard utilities
    grim # Screenshot tool
    slurp # Screen area selector

    pywalfox-native
    cava
    krabby
    # Additional tools you might want
    # pavucontrol   # PulseAudio volume control
    # networkmanagerapplet  # Network manager GUI
  ];
}
