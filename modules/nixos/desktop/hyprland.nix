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
  # Cursor that rotates with its direction of travel and grows when shaken (rice configures it).
  # nixpkgs' build (2026-07-21) throws on load in 0.56.2; upstream's hyprpm.toml pins this
  # commit for Hyprland efb5099 (v0.56.2). It still reads hyprlang config. Drop the
  # override once nixpkgs catches up.
  environment.etc."hypr/plugins/dynamic-cursors.so".source =
    "${pkgs.hyprlandPlugins.hypr-dynamic-cursors.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "VirtCode";
        repo = "hypr-dynamic-cursors";
        rev = "5a224284872208b5324759d535d65061043725de";
        hash = "sha256-BQjuQplkQFA30/7evDxmEAvr2ArIG09JffEBQhuzo80=";
      };
    }}/lib/libhypr-dynamic-cursors.so";

  # Cursor: Rose Pine in both formats, same design (theme picked in ~/.config/hypr env.conf).
  # Complete sizes avoid the XWayland size mismatch some themes have (Hyprland #7842).
  # The fallback is the default for apps that ignore XCURSOR_THEME.
  xdg.icons.fallbackCursorThemes = [ "BreezeX-RosePine-Linux" ];

  # Hyprland-ecosystem only. Shared desktop userland (capture, clipboard,
  # brightness, audio) lives in ./packages.nix -- don't re-declare it here.
  environment.systemPackages = with pkgs; [
    pyprland
    hyprshot
    kitty
    wofi
    swaybg
    rose-pine-cursor
    rose-pine-hyprcursor
  ];
}
