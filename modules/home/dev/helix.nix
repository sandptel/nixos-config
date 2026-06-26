{ ... }:
# Helix keybinds ported from the user's VSCodeVim setup.
# Notes on what can't translate 1:1:
#  - Helix has no count-in-keymap, so "5j" is a 5-command sequence.
#  - Space is Helix's picker menu, so single-space-hover isn't bound;
#    space-space = definition, and the leader actions live under space.
#  - Helix clears search highlight automatically, so :nohl is unneeded.
let
  down5 = builtins.genList (_: "move_line_down") 5;
  up5 = builtins.genList (_: "move_line_up") 5;
in
{
  programs.helix = {
    enable = true;
    settings.keys = {
      normal = {
        J = down5;
        K = up5;

        # Word navigation (n/m)
        n = "move_next_word_start";
        m = "move_prev_word_start";

        # Line start / end (WORD back/end, mirrors normal-mode H/L)
        H = "move_prev_long_word_start";
        L = "move_next_long_word_end";

        # Jump list
        N = "jump_backward";
        M = "jump_forward";

        # System clipboard yank/paste (useSystemClipboard)
        y = "yank_to_clipboard";
        p = "paste_clipboard_after";
        P = "paste_clipboard_before";

        # Common OS-style shortcuts
        C-c = "yank_to_clipboard";
        C-x = [ "yank_to_clipboard" "delete_selection" ];
        C-v = "paste_clipboard_after";
        C-z = "undo";
        C-y = "redo";
        C-a = "select_all";
        C-s = ":w";

        # Leader (space) actions
        space = {
          j = "goto_previous_buffer";
          k = "goto_next_buffer";
          space = "goto_definition";
          n = "search_next";
          N = "search_prev";
          w = ":w";
        };
      };

      select = {
        J = down5;
        K = up5;
        H = "goto_first_nonwhitespace";
        L = "goto_line_end";
        n = "move_next_word_start";
        m = "move_prev_word_start";
        C-c = "yank_to_clipboard";
        C-x = [ "yank_to_clipboard" "delete_selection" ];
      };

      insert = {
        j.j = "normal_mode";
        C-v = "paste_clipboard_after";
        C-s = ":w";
      };
    };
  };
}
