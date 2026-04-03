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

If you ever lose this because vscode is a piece of shit: 

```json
{
  "editor.fontFamily": "Fira Code",
  "editor.fontLigatures": true,
  "github.copilot.nextEditSuggestions.enabled": true,
  "material-code.primaryColor": "#7E898C",
  "vim.leader": "<space>",
  "vim.normalModeKeyBindingsNonRecursive": [
    /* Fast Vertical Movement */
    // 3. Word & Symbol Navigation (n/m)
    // If you want variable jumping specifically, use the commands below.
    // To stick to word movement only: change commands to ["w"] and ["b"]
    {
      "before": [
        "n"
      ],
      "commands": [
        "editor.action.wordHighlight.next"
      ]
    },
    {
      "before": [
        "m"
      ],
      "commands": [
        "editor.action.wordHighlight.prev"
      ]
    },
    // 4. History Navigation (N/M for Jump List)
    {
      "before": [
        "N"
      ],
      "commands": [
        "workbench.action.navigateBack"
      ]
    },
    {
      "before": [
        "M"
      ],
      "commands": [
        "workbench.action.navigateForward"
      ]
    },
    // 5. Tab & Editor Navigation (Leader + h/l)
    {
      "before": [
        "<leader>",
        "h"
      ],
      "commands": [
        "workbench.action.previousEditor"
      ]
    },
    {
      "before": [
        "<leader>",
        "l"
      ],
      "commands": [
        "workbench.action.nextEditor"
      ]
    },
    // 6. LSP Power Jumps (Spacebar logic)
    // Double Space for Details, Triple Space for Definition
    {
      "before": [
        "<leader>"
      ],
      "commands": [
        "editor.action.showHover"
      ]
    },
    {
      "before": [
        "<leader>",
        "<leader>"
      ],
      "commands": [
        "editor.action.revealDefinition"
      ]
    },
    {
      "before": [
        "J"
      ],
      "after": [
        "5",
        "j"
      ]
    },
    {
      "before": [
        "K"
      ],
      "after": [
        "5",
        "k"
      ]
    },
    {
      "before": [
        "<leader>",
        "j"
      ],
      "after": [
        "J"
      ]
    },
    /* Line Start/End */
    {
      "before": [
        "H"
      ],
      "after": [
        "^"
      ]
    },
    {
      "before": [
        "L"
      ],
      "after": [
        "$"
      ]
    },
    /* Home Row Word Movement */
    {
      "before": [
        "n"
      ],
      "commands": [
        "editor.action.wordHighlight.next"
      ]
    },
    // Jump to the PREVIOUS occurrence of the word under the cursor
    {
      "before": [
        "m"
      ],
      "commands": [
        "editor.action.wordHighlight.prev"
      ]
    },
    /* Search Recovery */
    {
      "before": [
        "<leader>",
        "n"
      ],
      "after": [
        "n"
      ]
    },
    {
      "before": [
        "<leader>",
        "N"
      ],
      "after": [
        "N"
      ]
    },
    /* Utilities */
    {
      "before": [
        "<leader>",
        "l"
      ],
      "commands": [
        ":nohl"
      ]
    },
    {
      "before": [
        "<leader>",
        "w"
      ],
      "commands": [
        "workbench.action.files.save"
      ]
    }
  ],
  "vim.visualModeKeyBindingsNonRecursive": [
    {
      "before": [
        "J"
      ],
      "after": [
        "5",
        "j"
      ]
    },
    {
      "before": [
        "K"
      ],
      "after": [
        "5",
        "k"
      ]
    },
    {
      "before": [
        "H"
      ],
      "after": [
        "^"
      ]
    },
    {
      "before": [
        "L"
      ],
      "after": [
        "$"
      ]
    },
    {
      "before": [
        "n"
      ],
      "after": [
        "w"
      ]
    },
    {
      "before": [
        "m"
      ],
      "after": [
        "b"
      ]
    }
  ],
  "vim.insertModeKeyBindings": [
    {
      "before": [
        "j",
        "j"
      ],
      "after": [
        "<Esc>"
      ]
    }
  ],
  "vim.handleKeys": {
    "<C-c>": false,
    "<C-x>": false,
    "<C-y>": false,
    "<C-k>": false,
    "<C-l>": false,
    "<C-j>": false,
    "<C-a>": false,
    "<C-w>": false
  },
  "files.autoSave": "afterDelay",
  "editor.fontSize": 17,
  "chat.agent.maxRequests": 200,
  "chat.checkpoints.showFileChanges": true,
  "chat.customAgentInSubagent.enabled": true,
  "chat.editor.fontFamily": "Fira Code",
  "chat.editor.fontSize": 15,
  "git.openRepositoryInParentFolders": "never"
}

```

---

Final VsCode.json file :
```
{
  //vscode settings.json
  "editor.fontFamily": "Fira Code",
  "editor.fontLigatures": true,
  "github.copilot.nextEditSuggestions.fixes": true,
  "github.copilot.editor.enableCodeActions": true,
  "terminal.integrated.fontFamily": "'JetBrainsMono Nerd Font', 'Material Design Icons', monospace",
  "material-code.primaryColor": "#66AF5A",
  "vim.leader": "<space>",
  "vim.normalModeKeyBindingsNonRecursive": [
    /* Fast Vertical Movement */
    // 3. Word & Symbol Navigation (n/m)
    // If you want variable jumping specifically, use the commands below.
    // To stick to word movement only: change commands to ["w"] and ["b"]
    {
      "before": [
        "n"
      ],
      "commands": [
        "editor.action.wordHighlight.next"
      ]
    },
    {
      "before": [
        "m"
      ],
      "commands": [
        "editor.action.wordHighlight.prev"
      ]
    },
    // 4. History Navigation (N/M for Jump List)
    {
      "before": [
        "N"
      ],
      "commands": [
        "workbench.action.navigateBack"
      ]
    },
    {
      "before": [
        "M"
      ],
      "commands": [
        "workbench.action.navigateForward"
      ]
    },
    // 5. Tab & Editor Navigation (Leader + h/l)
    {
      "before": [
        "<leader>",
        "h"
      ],
      "commands": [
        "workbench.action.previousEditor"
      ]
    },
    {
      "before": [
        "<leader>",
        "l"
      ],
      "commands": [
        "workbench.action.nextEditor"
      ]
    },
    // 6. LSP Power Jumps (Spacebar logic)
    // Double Space for Details, Triple Space for Definition
    {
      "before": [
        "<leader>"
      ],
      "commands": [
        "editor.action.showHover"
      ]
    },
    {
      "before": [
        "<leader>",
        "<leader>"
      ],
      "commands": [
        "editor.action.revealDefinition"
      ]
    },
    {
      "before": [
        "J"
      ],
      "after": [
        "5",
        "j"
      ]
    },
    {
      "before": [
        "K"
      ],
      "after": [
        "5",
        "k"
      ]
    },
    {
      "before": [
        "<leader>",
        "j"
      ],
      "after": [
        "J"
      ]
    },
    /* Line Start/End */
    {
      "before": [
        "H"
      ],
      "after": [
        "B"
      ]
    },
    {
      "before": [
        "L"
      ],
      "after": [
        "E"
      ]
    },
    /* Home Row Word Movement */
    {
      "before": [
        "n"
      ],
      "commands": [
        "editor.action.wordHighlight.next"
      ]
    },
    // Jump to the PREVIOUS occurrence of the word under the cursor
    {
      "before": [
        "m"
      ],
      "commands": [
        "editor.action.wordHighlight.prev"
      ]
    },
    /* Search Recovery */
    {
      "before": [
        "<leader>",
        "n"
      ],
      "after": [
        "n"
      ]
    },
    {
      "before": [
        "<leader>",
        "N"
      ],
      "after": [
        "N"
      ]
    },
    /* Utilities */
    {
      "before": [
        "<leader>",
        "l"
      ],
      "commands": [
        ":nohl"
      ]
    },
    {
      "before": [
        "<leader>",
        "w"
      ],
      "commands": [
        "workbench.action.files.save"
      ]
    }
  ],
  "vim.visualModeKeyBindingsNonRecursive": [
    {
      "before": [
        "J"
      ],
      "after": [
        "5",
        "j"
      ]
    },
    {
      "before": [
        "K"
      ],
      "after": [
        "5",
        "k"
      ]
    },
    {
      "before": [
        "H"
      ],
      "after": [
        "^"
      ]
    },
    {
      "before": [
        "L"
      ],
      "after": [
        "$"
      ]
    },
    {
      "before": [
        "n"
      ],
      "after": [
        "w"
      ]
    },
    {
      "before": [
        "m"
      ],
      "after": [
        "b"
      ]
    }
  ],
  "vim.insertModeKeyBindings": [
    {
      "before": [
        "j",
        "j"
      ],
      "after": [
        "<Esc>"
      ]
    }
  ],
  "vim.handleKeys": {
    "<C-c>": false,
    "<C-x>": false,
    "<C-y>": false,
    "<C-k>": false,
    "<C-l>": false,
    "<C-j>": false,
    "<C-b>": false,
    "<C-a>": false,
    "<C-e>": false,
    "<C-r>": false,
    "<C-d>": false,
    "<C-f>": false,
    "<C-w>": false,
    "<C-u>": false,
    "<C-n>": false,
  },
  "vim.useSystemClipboard": true,
  "files.autoSave": "afterDelay",
  "editor.fontSize": 17,
  "chat.agent.maxRequests": 200,
  "chat.checkpoints.showFileChanges": true,
  "chat.customAgentInSubagent.enabled": true,
  "chat.editor.fontFamily": "Fira Code",
  "chat.editor.fontSize": 15,
  "git.openRepositoryInParentFolders": "never",
  "accessibility.signalOptions.volume": 0,
  "chat.fontSize": 17,
  "chat.viewSessions.orientation": "stacked",
  "workbench.colorTheme": "Gruvbox Light Soft",
  "chat.edits2.enabled": true,
  "chat.mcp.gallery.enabled": true,
  "chat.editing.confirmEditRequestRemoval": false,
  "[nix]": {
    "editor.defaultFormatter": "brettm12345.nixfmt-vscode"
  },
  "editor.accessibilitySupport": "on",
  "workbench.panel.showLabels": false,
  "nix.enableLanguageServer": true,
  "nix.serverPath": "nixd",
  "nix.serverSettings": {
    "nixd": {
      "formatting": {
        "command": [
          "nixfmt"
        ] // or "alejandra"
      },
      "options": {
        // ENABLE NIXOS OPTIONS AUTOCOMPLETE
        // Replace "/absolute/path/to/flake" and "yourHostname"
        "nixos": {
          "expr": "(builtins.getFlake \"/home/user/dotfiles\").nixosConfigurations.yourHostname.options"
        },
        // ENABLE HOME-MANAGER OPTIONS AUTOCOMPLETE
        // Replace "user@hostname" with your actual home-manager config name
        "home-manager": {
          "expr": "(builtins.getFlake \"/home/user/dotfiles\").homeConfigurations.\"user@hostname\".options"
        }
      },
      "diagnostic": {
        // Suppress annoying "variable not found" errors if you use a lot of 'with' scopes
        "suppress": [
          "sema-extra-with"
        ]
      }
    }
  }
}
```
## Vimium Config
```
# ==============================================================================
# UNIVERSAL DEVELOPER VIMIUM CONFIG (PAGE-JUMP VERSION)
# ==============================================================================

# --- 1. ESCAPE & MODE SWITCHING ---
unmap a
map a focusInput
map p enterInsertMode
unmap f

# --- 2. THE J/K POWER MAPPING (Page Up/Down) ---
unmap J
unmap K
map J scrollFullPageDown
map K scrollFullPageUp

# --- 3. LINK INTERACTION (Home Row) ---
unmap i
map i LinkHints.activateMode
map I LinkHints.activateModeToOpenInNewTab
map yi LinkHints.activateModeToCopyLinkUrl

# --- 4. SCROLLING (Half Page) ---
unmap w
unmap b
unmap u
map u visitPreviousTab

# --- 5. HISTORY & URL HIERARCHY (N/M) ---
unmap n
unmap m

map n goBack
map m goForward

map H goBack
map L goForward

# --- 6. TAB NAVIGATION (H/L) ---

map h previousTab
map l nextTab

# --- 7. MISC ---
unmap <a-m>
mapkey <a-i> <c-[>

unmap o
map o Vomnibar.activateInNewTab
unmap O 
map O Vomnibar.activate

map fo Vomnibar.activateEditUrlInNewTab
map fO Vomnibar.activateEditUrl
```
## Tmux Configs
```conf
# ==============================================================================
# UNIVERSAL DEVELOPER TMUX CONFIG (CONTROL-KEY POWER)
# ==============================================================================

unbind C-b
set -g prefix C-Space
bind C-Space send-prefix

# --- 4. REPEATABLE RESIZING (Prefix, then tap h, j, k, l) ---
# The '-r' flag means you press Prefix ONCE, then you have 500ms to tap
# h, j, k, or l repeatedly to resize the window exactly how you want.
bind -r h resize-pane -L 5
bind -r j resize-pane -D 5
bind -r k resize-pane -U 5
bind -r l resize-pane -R 5

# --- 0.1. VIM-LIKE SPLITTING ---
# v for vertical, s for horizontal (matching Vim)
bind v split-window -h -c "#{pane_current_path}"
bind s split-window -v -c "#{pane_current_path}"
bind b break-pane
unbind '"'
unbind %

# --- 1. GENERAL SETTINGS ---
set -g mouse on               # Enable touchpad/mouse scrolling and clicking
set -g base-index 1           # Start windows at 1 (matches keyboard)
set -g pane-base-index 1      # Start panes at 1
set -g renumber-windows on    # Automatically renumber windows when one is closed
set -g status-interval 1      # Refresh status bar every second

# --- 2. WINDOW MANAGEMENT (n, m, x, t) ---
# Ctrl+left / Ctrl+right: Move back and forth between windows
bind -n S-left previous-window
bind -n S-right next-window
bind -n S-Down switch-client -p
bind -n S-Up switch-client -n

# Shift+Down to cycle to the next pane
bind -n C-e select-pane -t :.+

# Shift+Up to cycle to the previous pane
bind -n C-b select-pane -t :.-

# Ctrl+t: Create new window
bind -n C-t new-window -c "#{pane_current_path}"
bind -n C-T new-session

# Ctrl+x: Kill (Delete) current window
bind -n C-x kill-window
bind -n C-X detach-client

# --- 3. SESSION MANAGEMENT (N, M, T, B) ---

# Prefix + Ctrl+k: FETCH window from another session to here
# (Prompts for the target. E.g., type 'work:2' to pull window 2 from the 'work' session)
bind C-Down command-prompt -p "Send window to session:" "move-window -t '%%:'"
bind C-Up command-prompt -p "Fetch window from (session:window):" "move-window -s '%%'"

# --- 5. EXIT & EMERGENCY ---
# Prefix + q: Exit Tmux entirely (kills the server)
bind q confirm-before -p "Kill tmux server? (y/n)" kill-server

# --- 6. CLIPBOARD (NixOS/Wayland Fix) ---
setw -g mode-keys vi
bind -T copy-mode-vi y send -X copy-pipe-and-cancel "wl-copy"

```
