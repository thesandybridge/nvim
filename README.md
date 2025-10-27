# Neovim Configuration

Modern Neovim configuration using Lazy.nvim with optional Omarchy theme integration.

## Features

- **Plugin Manager**: Lazy.nvim with optimized lazy loading
- **LSP**: Full LSP support via lsp-zero with Mason
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
│   ├── thesbx/
│   │   ├── init.lua           # Main config loader + theme application
│   │   ├── lazy.lua           # Lazy.nvim bootstrap
│   │   ├── set.lua            # Vim options
│   │   ├── remap.lua          # Keymaps
│   │   └── ...                # Other configs
│   ├── plugins/               # Plugin specifications (lazy-loaded)
│   │   ├── theme.lua          # Theme plugin
│   │   ├── lsp.lua            # LSP configuration
│   │   ├── git.lua            # Git plugins
│   │   └── ...                # Other plugin groups
│   └── snippets/              # Custom snippets
└── after/plugin/              # Plugin configurations
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
