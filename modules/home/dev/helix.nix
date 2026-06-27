{ pkgs, ... }:
# Helix keybinds ported from the user's VSCodeVim setup.
# Notes on what can't translate 1:1:
#  - Helix has no count-in-keymap, so "5j" is a 5-command sequence.
#  - Space is Helix's picker menu, so single-space-hover isn't bound;
#    space-space = definition, and the leader actions live under space.
#  - Helix clears search highlight automatically, so :nohl is unneeded.
let
  down5 = builtins.genList (_: "move_line_down") 5;
  up5 = builtins.genList (_: "move_line_up") 5;
  # Format the whole document: select all, format, then drop the selection.
  formatDoc = [
    "select_all"
    "format_selections"
    "collapse_selection"
  ];
in
{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    # Language servers + formatters. Compiled-language toolchains
    # (cargo/rustc, go, gcc) come per-project via direnv; the servers here
    # pick those up. Servers auto-activate when their binary is on PATH.
    extraPackages = with pkgs; [
      # Rust
      rust-analyzer
      # Nix
      nixd
      nixfmt
      # Python
      pyright
      ruff
      # Shell
      bash-language-server
      shfmt
      # Config formats
      taplo # toml
      yaml-language-server
      vscode-langservers-extracted # json / html / css / eslint
      marksman # markdown
      # Web / JS / TS
      typescript-language-server
      typescript
      prettier
      # C / C++
      clang-tools # clangd + clang-format
      # Lua
      lua-language-server
      stylua
      # Go
      gopls
    ];

    # Child theme inheriting noctalia (generated as themes/noctalia.toml), only
    # bumping contrast on dim scopes. Inheriting keeps noctalia's whole palette,
    # so onSurface/primary stay adaptive to the generated colors.
    settings.theme = "noctalia-contrast";

    themes.noctalia-contrast = {
      inherits = "noctalia";

      # noctalia uses dim "outline" greys for these; use the main foreground.
      "operator" = {
        fg = "onSurface";
        modifiers = [ "bold" ];
      };
      "punctuation" = "onSurface";
      "punctuation.delimiter" = "onSurface";
      "punctuation.bracket" = "onSurface";
      "punctuation.special" = "primary";

      # Diagnostics: brighter + bold so warnings/errors stand out.
      "warning" = "#fab387";
      "error" = "#f38ba8";
      "diagnostic.warning" = {
        underline = {
          color = "#fab387";
          style = "curl";
        };
        modifiers = [ "bold" ];
      };
      "diagnostic.error" = {
        underline = {
          color = "#f38ba8";
          style = "curl";
        };
        modifiers = [ "bold" ];
      };
    };

    settings.editor = {
      true-color = true; # force 24-bit color so the noctalia theme renders right
      bufferline = "multiple"; # buffer tabs (pairs with space j / space k)
      cursorline = true;
      color-modes = true; # mode-colored statusline
      indent-guides.render = true;
      lsp.display-inlay-hints = true; # rust-analyzer type hints
      file-picker.hidden = false; # show dotfiles in pickers / file tree

      # Inline error / warning display.
      end-of-line-diagnostics = "hint";
      inline-diagnostics = {
        cursor-line = "warning";
        other-lines = "error";
      };
    };

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

        # File pickers
        C-e = "file_picker_in_current_buffer_directory"; # dir of current file
        C-r = "file_picker_in_current_directory"; # current working directory

        # Search
        C-f = "search"; # search within current file
        C-F = "global_search"; # Ctrl+Shift+F: search across the working directory

        # Toggle comment on selection / current line
        "C-/" = "toggle_comments";

        # Git: open lazygit in a detached terminal window (Helix can't host a
        # TUI inline). setsid -f returns immediately so Helix doesn't block.
        C-g = ":sh setsid -f kitty -e lazygit";

        # Format whole document (Ctrl+Shift+I). Terminals must distinguish it
        # from Tab and C-/ from C-_ (kitty/foot/wezterm/ghostty do; legacy may not).
        C-I = formatDoc;

        # Common OS-style shortcuts
        C-c = "yank_to_clipboard";
        C-x = [
          "yank_to_clipboard"
          "delete_selection"
        ];
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
          h = "hover"; # rebound (we use space k for buffer nav)
          e = "file_explorer"; # native in-editor file tree (opens in place)
          y = ":sh setsid -f kitty -e yazi"; # yazi as a standalone launcher
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
        C-x = [
          "yank_to_clipboard"
          "delete_selection"
        ];
        "C-/" = "toggle_comments";
        C-I = formatDoc;
      };

      insert = {
        j.j = "normal_mode";
        C-v = "paste_clipboard_before"; # paste at cursor while typing
        C-s = ":w";
        C-z = [
          "normal_mode"
          "undo"
        ];
        C-y = [
          "normal_mode"
          "redo"
        ];
        # Leave insert, then act (can't select/cut mid-insert).
        C-a = [
          "normal_mode"
          "select_all"
        ];
        C-x = [
          "normal_mode"
          "yank_to_clipboard"
          "delete_selection"
        ];
      };
    };

    # auto-format on save uses the LSP's formatter unless `formatter` is set.
    languages = {
      language-server = {
        rust-analyzer.config.check.command = "clippy";
        nixd.command = "nixd";
        pyright = {
          command = "pyright-langserver";
          args = [ "--stdio" ];
        };
        ruff = {
          command = "ruff";
          args = [ "server" ];
        };
      };

      language = [
        # --- LSP handles formatting ---
        {
          name = "rust";
          auto-format = true;
        }
        {
          name = "toml";
          auto-format = true;
        }
        {
          name = "go";
          auto-format = true;
        }
        {
          name = "c";
          auto-format = true;
        }
        {
          name = "cpp";
          auto-format = true;
        }
        {
          name = "python";
          language-servers = [
            "pyright"
            "ruff"
          ];
          auto-format = true;
        }
        {
          name = "nix";
          language-servers = [ "nixd" ];
          auto-format = true;
          formatter.command = "nixfmt";
        }
        # --- external formatters ---
        {
          name = "bash";
          auto-format = true;
          formatter = {
            command = "shfmt";
            args = [
              "-i"
              "2"
            ];
          };
        }
        {
          name = "lua";
          auto-format = true;
          formatter = {
            command = "stylua";
            args = [ "-" ];
          };
        }
        # --- prettier family ---
        {
          name = "json";
          auto-format = true;
          formatter = {
            command = "prettier";
            args = [
              "--parser"
              "json"
            ];
          };
        }
        {
          name = "yaml";
          auto-format = true;
          formatter = {
            command = "prettier";
            args = [
              "--parser"
              "yaml"
            ];
          };
        }
        {
          name = "css";
          auto-format = true;
          formatter = {
            command = "prettier";
            args = [
              "--parser"
              "css"
            ];
          };
        }
        {
          name = "html";
          auto-format = true;
          formatter = {
            command = "prettier";
            args = [
              "--parser"
              "html"
            ];
          };
        }
        {
          name = "markdown";
          auto-format = true;
          formatter = {
            command = "prettier";
            args = [
              "--parser"
              "markdown"
            ];
          };
        }
        {
          name = "javascript";
          auto-format = true;
          formatter = {
            command = "prettier";
            args = [
              "--parser"
              "babel"
            ];
          };
        }
        {
          name = "typescript";
          auto-format = true;
          formatter = {
            command = "prettier";
            args = [
              "--parser"
              "typescript"
            ];
          };
        }
      ];
    };
  };
}
