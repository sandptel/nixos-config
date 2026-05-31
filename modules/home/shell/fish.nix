{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
        # Enable a plugin (here grc for colorized output)
        { name = "grc"; src = pkgs.fishPlugins.grc.src; }
    ];
  };
}
