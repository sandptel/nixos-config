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
