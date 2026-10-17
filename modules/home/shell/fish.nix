{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    '';
    plugins = [
        # Enable a plugin (here grc for colorized output)
        { name = "grc"; src = pkgs.fishPlugins.grc.src; }
    ];
  };
}
