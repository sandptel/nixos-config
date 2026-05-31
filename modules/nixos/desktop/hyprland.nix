{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pyprland

    kitty
    waybar
    # dunst
    wofi
    swaybg
    cliphist
    wl-clipboard
    grim
    slurp
  ];
}
