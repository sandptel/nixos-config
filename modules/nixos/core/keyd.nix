{ config, pkgs, ... }:

{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            # Tap Caps = Esc, Hold Caps = Nav Layer
            capslock = "overload(nav, esc)";
          };

          nav = {
            # Vim Arrows
            h = "left";
            j = "down";
            k = "up";
            l = "right";

            # Your Custom Mappings
            n = "C-left"; # Go to start of line
            m = "C-right"; # Go to end of line
            u = "C-backspace"; # Delete whole word (backwards)
            i = "backspace";
            o = "enter";
            backspace = "C-backspace"; # Back to main layer

            # Optional: 'f' to delete word forward (Ctrl+Delete)
            # f = "C-delete";
          };
        };
      };
    };
  };
}
