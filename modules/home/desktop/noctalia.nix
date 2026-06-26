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
  programs.noctalia = {
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
    grim
    # Additional tools you might want
    # pavucontrol   # PulseAudio volume control
    # networkmanagerapplet  # Network manager GUI
  ];
}
