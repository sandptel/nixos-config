{ inputs, pkgs, ... }:
{
  # Noctalia v5 shell. Config is in ~/dots (.config/noctalia), not Nix.
  # Started by the compositors (hypr execs / niri spawn-at-startup).
  imports = [ inputs.noctalia.nixosModules.default ];

  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true; # NetworkManager, bluetooth, upower, power-profiles
  };

  environment.systemPackages = with pkgs; [
    pywalfox-native # firefox theming from noctalia's palette
    cava
    krabby
  ];
}
