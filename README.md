# Neovim Configuration

Modern Neovim configuration using Lazy.nvim with optional Omarchy theme integration.

## Features

- **Plugin Manager**: Lazy.nvim with LazyVim defaults
- **LSP**: Native nvim-lspconfig setup with Mason-managed servers
- **Treesitter**: Syntax highlighting and code understanding
- **Git Integration**: Gitsigns, Neogit, Diffview, Blame
- **Fuzzy Finding**: Telescope
- **Debugging**: nvim-dap with UI
- **Theme**: Omarchy-aware with gruvbox/gruvbox-material fallback
- **Portable**: Works on systems with or without Omarchy

## Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── config/
│   │   ├── lazy.lua           # Lazy.nvim + LazyVim bootstrap
│   │   ├── options.lua        # Loads personal Vim options
│   │   ├── keymaps.lua        # Loads personal keymaps
│   │   └── autocmds.lua       # Autocmds and user commands
│   ├── thesbx/
│   │   ├── set.lua            # Personal Vim options
│   │   ├── remap.lua          # Personal keymaps
│   │   └── find_replace.lua   # Custom commands
│   ├── plugins/               # Plugin specifications (lazy-loaded)
│   │   ├── theme.lua          # Theme plugin
│   │   ├── lsp.lua            # LSP configuration
│   │   ├── git.lua            # Git plugins
│   │   └── ...                # Other plugin groups
│   └── snippets/              # Custom snippets
└── lazy-lock.json             # Locked plugin revisions
```

## Lazy Loading

Plugins use modern lazy-loading patterns:
- `event`: Load on Vim events (BufReadPost, VeryLazy, InsertEnter)
- `cmd`: Load when command is executed
- `ft`: Load for specific filetypes  
- `keys`: Load when keymapping is triggered
- `opts = {}`: Auto-call setup() with empty config

## Omarchy Integration

Auto-detects Omarchy theme system:
- With Omarchy: Uses `~/.config/omarchy/current/theme/neovim.lua`
- Without Omarchy: Falls back to gruvbox-material
- Hot-reload support when switching Omarchy themes

## Commands

```vim
:Lazy              " Plugin manager UI
:Lazy update       " Update all plugins
:Mason             " LSP/tool installer
```

## Leader Key

`<Space>` - See `lua/thesbx/remap.lua` for keybindings
