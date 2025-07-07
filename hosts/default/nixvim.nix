# In your NixOS configuration (e.g., /etc/nixos/configuration.nix)
{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    # Core plugin configuration using attribute sets
    plugins = {
      lualine = {
        enable = true;
        theme = "pywal-nvim"; # Match pywal theme
      };
      lsp = {
        enable = true;
        servers.rust-analyzer = {
          enable = true;
          settings = {
            "rust-analyzer" = {
              cargo.allFeatures = true;
              checkOnSave.command = "clippy";
              procMacro.enable = true;
            };
          };
        };
      };

      treesitter = {
        enable = true;
        ensureInstalled = [
          "rust"
          "lua"
          "nix"
        ];
        # highlight.enable = true;
      };

      telescope = {
        enable = true;
        keymaps = {
          "ff" = "find_files";
          "fg" = "live_grep";
          "fb" = "buffers";
        };
      };

      which-key = {
        enable = true;
        registrations = {
          "<leader>f" = "File operations";
          "<leader>g" = "Git operations";
        };
      };

      gitsigns = {
        enable = true;
        settings.signs = {
          add.text = "+";
          change.text = "~";
          delete.text = "_";
        };
      };
    };

    # Additional plugins
    extraPlugins = with pkgs.vimPlugins; [
      pywal-nvim
      nvim-surround
      direnv-vim
      lualine-nvim
      trouble-nvim
      nvim-autopairs
      coc-rls
      coc-rust-analyzer
      rustaceanvim
      comment-nvim
      auto-save-nvim
    ];

    # Key mappings
    keymaps = [
      # Existing keymaps
      {
        mode = "i";
        key = "jj";
        action = "<Esc>";
      }

      {
        mode = "n";
        key = "<C-z>";
        action = "u";
      }

      {
        mode = "i";
        key = "<C-z>";
        action = "<C-o>u";
      }

      {
        mode = "n";
        key = "<C-y>";
        action = "<C-r>";
      }

      {
        mode = "n";
        key = "<C-s>";
        action = "<cmd>ASToggle<CR>";
        options.desc = "Toggle auto-save";
      }

      {
        mode = "i";
        key = "<C-y>";
        action = "<C-o><C-r>";
      }

    ];

    # # Additional configuration
    extraConfigLua = ''

      vim.diagnostic.config({
        virtual_text = true,  -- Show inline errors/warnings
        underline = true,
        signs = true,
        update_in_insert = false,
        severity_sort = true,
      })

      require('lspconfig').rust_analyzer.setup({
          settings = {
              ["rust-analyzer"] = {
              diagnostics = { enable = true },
              inlayHints = {
                  enable = true,
                  showParameterNames = true,
                  parameterHintsPrefix = "<- ",
                  otherHintsPrefix = "=> ",
              },
              cargo = { allFeatures = true, buildScripts = { enable = true } },
              procMacro = { enable = true },
              }
          },
          on_attach = function(client, bufnr)
              vim.lsp.inlay_hint.enable(bufnr, true)
          end,
          })

          require('Comment').setup()
          -- Map Ctrl+/ to toggle comment in normal and visual mode
          vim.keymap.set('n', '<C-_>', 'gcc', { noremap = false, silent = true, desc = 'Toggle comment line' })
          vim.keymap.set('v', '<C-_>', 'gc', { noremap = false, silent = true, desc = 'Toggle comment block' })


          require("auto-save").setup({
              enabled = true,  -- start auto-save when plugin loads
              execution_message = {
              message = function()
                  return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
              end,
              dim = 0.18,
              cleaning_interval = 1250,
              },
              trigger_events = { "InsertLeave", "TextChanged" },  -- save on these events
              debounce_delay = 1000,  -- ms between saves
              condition = nil,  -- save all modifiable buffers
              write_all_buffers = false,
          })
          
    '';

    # Required system packages
    extraPackages = with pkgs; [
      rust-analyzer
      cargo
      rustfmt
      clippy
      direnv # Required for direnv-nvim
    ];
  };
}

# Treesitter configuration (
