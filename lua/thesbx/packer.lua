--This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use 'othree/html5.vim'
    use 'navarasu/onedark.nvim'
    use 'folke/tokyonight.nvim'
    use 'petertriho/nvim-scrollbar'
    use 'github/copilot.vim'
    use 'lewis6991/gitsigns.nvim'
    use { 'rcarriga/nvim-dap-ui', requires = {'mfussenegger/nvim-dap'} }
    use 'theHamsta/nvim-dap-virtual-text'
    use 'leoluz/nvim-dap-go'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'
    use 'norcalli/nvim-colorizer.lua'
    use 'mattn/emmet-vim'
    use {
        'kkoomen/vim-doge',
        run = ':call doge#install()'
    }
    use({
        "folke/trouble.nvim",
    })
    use {
        "luckasRanarison/nvim-devdocs",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("nvim-devdocs").setup()
        end
    }
    --use({
    --    "folke/noice.nvim",
    --    requires = {
    --        "MunifTanjim/nui.nvim",
    --        "rcarriga/nvim-notify"
    --    }
    --})
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
    }
    use 'tpope/vim-fugitive'
    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use 'nvim-treesitter/playground'
    use 'nvim-treesitter/nvim-treesitter-context'
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/vim-vsnip-integ'
    use "akinsho/toggleterm.nvim"
    use "theprimeagen/harpoon"
    use "lukas-reineke/indent-blankline.nvim"
    use 'wakatime/vim-wakatime'
    use 'wfxr/minimap.vim'
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }
end)
