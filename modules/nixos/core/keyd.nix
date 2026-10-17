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
            n = "C-left";
            m = "C-right";
            u = "C-backspace"; # Delete whole word (backwards)
            i = "backspace";
            o = "enter";
            
            # Universal Copy/Paste (Bypasses terminal SIGINT)
            y = "C-insert";    # Copy 
            p = "S-insert";    # Paste
            
            backspace = "C-backspace"; 

            # Optional: 'f' to delete word forward (Ctrl+Delete)
            # f = "C-delete";
          };
        };
      };
    };
  };
}