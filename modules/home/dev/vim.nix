{ ... }:
# Neovim keybinds ported from the user's VSCodeVim setup.
{
  programs.neovim = {
    enable = true;
    defaultEditor = false; # helix is the default editor
    viAlias = false;
    vimAlias = false;
    initLua = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
      vim.o.timeoutlen = 300
      vim.o.clipboard = "unnamedplus" -- useSystemClipboard

      local map = vim.keymap.set
      local o = { noremap = true, silent = true }

      -- Fast vertical movement
      map({ "n", "x" }, "J", "5j", o)
      map({ "n", "x" }, "K", "5k", o)

      -- Word navigation (n/m -> w/b)
      map({ "n", "x" }, "n", "w", o)
      map({ "n", "x" }, "m", "b", o)

      -- Line start / end
      map("n", "H", "B", o)
      map("n", "L", "E", o)
      map("x", "H", "^", o)
      map("x", "L", "$", o)

      -- Jump list (N/M)
      map("n", "N", "<C-o>", o)
      map("n", "M", "<C-i>", o)

      -- Buffer navigation
      map("n", "<leader>j", "<cmd>bprevious<cr>", o)
      map("n", "<leader>k", "<cmd>bnext<cr>", o)

      -- LSP: space = hover, space space = definition
      map("n", "<leader>", vim.lsp.buf.hover, o)
      map("n", "<leader><leader>", vim.lsp.buf.definition, o)

      -- Search recovery (n/m are remapped above)
      map("n", "<leader>n", "n", o)
      map("n", "<leader>N", "N", o)

      -- Utilities
      map("n", "<leader>l", "<cmd>nohlsearch<cr>", o)
      map("n", "<leader>w", "<cmd>w<cr>", o)

      -- Insert escape
      map("i", "jj", "<Esc>", o)

      -- Common OS-style shortcuts (excluded from VSCodeVim via handleKeys)
      map("x", "<C-c>", '"+y', o)   -- copy
      map("n", "<C-c>", '"+yy', o)
      map("x", "<C-x>", '"+d', o)   -- cut
      map("n", "<C-x>", '"+dd', o)
      map("n", "<C-v>", '"+p', o)   -- paste
      map("x", "<C-v>", '"+p', o)
      map("i", "<C-v>", "<C-r>+", o)
      map("c", "<C-v>", "<C-r>+", o)
      map("n", "<C-z>", "u", o)     -- undo
      map("i", "<C-z>", "<C-o>u", o)
      map("n", "<C-y>", "<C-r>", o) -- redo
      map("n", "<C-a>", "ggVG", o)  -- select all
      map({ "n", "i" }, "<C-s>", "<cmd>w<cr>", o) -- save

      -- Ctrl+h/j/k/l: move between splits, hand off to tmux at the edge
      for key, d in pairs({ h = "L", j = "D", k = "U", l = "R" }) do
        map("n", "<C-" .. key .. ">", function()
          local win = vim.fn.winnr()
          vim.cmd("wincmd " .. key)
          if win == vim.fn.winnr() and vim.env.TMUX then
            vim.fn.system({ "tmux", "select-pane", "-" .. d })
          end
        end, o)
      end
    '';
  };
}
