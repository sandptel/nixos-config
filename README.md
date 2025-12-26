# Preview

https://github.com/user-attachments/assets/ad5d5f34-cb39-4afe-bc71-4833bdacc037

# **!!! Do Not Blindly install these dots**
# Installation
1. Installing Nix
```bash
sh <(curl -L https://nixos.org/nix/install) --no-daemon
 . ~/.nix-profile/etc/profile.d/nix.sh
export NIX_CONFIG="experimental-features = nix-command flakes"
```
2. Clone the Repository
```bash
git clone https://github.com/sandptel
```
3. Rebuild Switch Using Flakes
   Here <roronoa> is profile name.
```bash
sudo nixos-rebuild switch --flake .#roronoa
```
OR direct install via
```bash
sudo nixos-rebuild switch --flake github:sandptel/dotfiles#roronoa
```


# Neovim Configs ( Copyable )

This document provides a performance-optimized configuration for both **Neovim** (Lua) and **VS Code** (JSON).

### Keybindings Strategy

* **Vertical Speed:** `Shift + J/K` jumps 5 lines.
* **Horizontal Speed:** `H/L` moves to the start/end of the line.
* **Word Navigation:** `n/m` replaces `w/b` for ergonomic home-row word jumping.
* **Search Recovery:** Since `n` is now "word forward", `Space + n` becomes "next search match".

---

## 1. Neovim Configuration (`init.lua`)

Place this in `~/.config/nvim/init.lua`.

```lua
-- ==========================================================================
-- NEOVIM ERGONOMIC NAVIGATION CONFIG
-- ==========================================================================

local map = vim.keymap.set
local opt = { noremap = true, silent = true }

-- 1. Fast Vertical Movement (5 lines at a time)
-- We use 'n' for normal mode and 'v' for visual mode to keep selection working.
map({'n', 'v'}, 'J', '5j', opt)
map({'n', 'v'}, 'K', '5k', opt)

-- Recovery: Map 'Join Lines' to <leader>j since J is now movement
vim.g.mapleader = " " -- Ensure space is leader
map('n', '<leader>j', 'J', opt)

-- 2. Line Navigation (H for Start, L for End)
map({'n', 'v'}, 'H', '^', opt) -- Jump to first non-blank character
map({'n', 'v'}, 'L', '$', opt) -- Jump to end of line

-- 3. Word Movement on Home Row (n/m)
-- This replaces 'w' (forward) and 'b' (backward)
map({'n', 'v'}, 'n', 'w', opt)
map({'n', 'v'}, 'm', 'b', opt)

-- Recovery: Search Next/Prev Match moved to leader
-- Since 'n' is taken, we use <leader>n to find the next search result
map('n', '<leader>n', 'n', opt)
map('n', '<leader>N', 'N', opt)

-- 4. Quick Escape
-- The 'jj' sequence to exit insert mode is a life-saver for speed.
map('i', 'jj', '<Esc>', opt)

-- 5. Additional Power Moves
-- Center screen after large jumps (keeps your eyes in the middle)
map('n', '<C-d>', '<C-d>zz', opt)
map('n', '<C-u>', '<C-u>zz', opt)

-- Clear highlights with Space + l
map('n', '<leader>l', ':nohlsearch<CR>', opt)

```

---

## 2. VS Code Configuration (`settings.json`)

Add these to your existing `settings.json`.

```json
{
  "vim.leader": "<space>",
  "vim.normalModeKeyBindingsNonRecursive": [
    /* Fast Vertical Movement */
    { "before": ["J"], "after": ["5", "j"] },
    { "before": ["K"], "after": ["5", "k"] },
    { "before": ["<leader>", "j"], "after": ["J"] },

    /* Line Start/End */
    { "before": ["H"], "after": ["^"] },
    { "before": ["L"], "after": ["$"] },

    /* Home Row Word Movement */
    { "before": ["n"], "after": ["w"] },
    { "before": ["m"], "after": ["b"] },

    /* Search Recovery */
    { "before": ["<leader>", "n"], "after": ["n"] },
    { "before": ["<leader>", "N"], "after": ["N"] },

    /* Utilities */
    { "before": ["<leader>", "l"], "commands": [":nohl"] },
    { "before": ["<leader>", "w"], "commands": ["workbench.action.files.save"] }
  ],
  "vim.visualModeKeyBindingsNonRecursive": [
    { "before": ["J"], "after": ["5", "j"] },
    { "before": ["K"], "after": ["5", "k"] },
    { "before": ["H"], "after": ["^"] },
    { "before": ["L"], "after": ["$"] },
    { "before": ["n"], "after": ["w"] },
    { "before": ["m"], "after": ["b"] }
  ],
  "vim.insertModeKeyBindings": [
    { "before": ["j", "j"], "after": ["<Esc>"] }
  ]
}

```

---

