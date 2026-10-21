{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Plugins at stable paths for rice setups (~/.config/rice/setups/*/hypr-plugins.conf
  # loads them with `plugin = /etc/hypr/plugins/<name>.so`). Same pkgs as
  # programs.hyprland, so the plugin ABI matches the running compositor.
  environment.etc."hypr/plugins/hyprbars.so".source =
    "${pkgs.hyprlandPlugins.hyprbars}/lib/libhyprbars.so";
  # Workspace overview grid (rice binds Super+O / Super+Tab and the 4-finger swipe to it).
  # Hyprspace was the alternative but doesn't build against 0.56.
  # Patched: a left click (no drag) selects a workspace, and swiping it closed lands on
  # the hovered workspace; upstream needs right click and always returns to the old one.
  environment.etc."hypr/plugins/hyprtasking.so".source =
    "${pkgs.hyprlandPlugins.hyprtasking.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./hyprtasking-select.patch ];
    })}/lib/libhyprtasking.so";

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
