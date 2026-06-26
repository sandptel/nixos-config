{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pyprland

    kitty
    # dunst
    wofi
    swaybg
    cliphist
    gpu-screen-recorder
    wl-clipboard
    hyprshot
    grim
    slurp
  ];
}
