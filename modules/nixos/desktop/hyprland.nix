{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Hyprland-ecosystem only. Shared desktop userland (capture, clipboard,
  # brightness, audio) lives in ./packages.nix -- don't re-declare it here.
  environment.systemPackages = with pkgs; [
    pyprland
    hyprshot
    kitty
    wofi
    swaybg
  ];
}
