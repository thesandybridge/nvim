--This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- THEMES --
    --use 'folke/tokyonight.nvim'
    --use { "catppuccin/nvim", as = "catppuccin" }
    --use 'navarasu/onedark.nvim'
    --use { "ellisonleao/gruvbox.nvim" }
    use { "sainnhe/gruvbox-material" }
    use "rebelot/kanagawa.nvim"
    -- ENDTHEMES --
    --
    use 'nvim-tree/nvim-web-devicons'
    -- use 'github/copilot.vim'
    use 'lewis6991/gitsigns.nvim'
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} }
    use 'theHamsta/nvim-dap-virtual-text'
    use 'leoluz/nvim-dap-go'
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use {'nvim-telescope/telescope-ui-select.nvim' }
    -- GIT --
    use "sindrets/diffview.nvim"
    --use "thesandybridge/blame.nvim"
    use "FabijanZulj/blame.nvim"
    use {
        'NeogitOrg/neogit',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "sindrets/diffview.nvim",
        },
    }
    -- ENDGIT --
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    use 'norcalli/nvim-colorizer.lua'
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
        }
    }
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
    }
    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use 'nvim-treesitter/playground'
    use 'nvim-treesitter/nvim-treesitter-context'
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/vim-vsnip-integ'
    use "akinsho/toggleterm.nvim"
    use {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { {"nvim-lua/plenary.nvim"} }
    }
    use "lukas-reineke/indent-blankline.nvim"
    use 'wakatime/vim-wakatime'
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
        },
        branch = 'v3.x'
    }
    use "mvllow/modes.nvim"
    use({
        "epwalsh/obsidian.nvim",
        tag = "*",
        requires = {
            "nvim-lua/plenary.nvim",

        }
    })
    use "folke/which-key.nvim"
    use({
        "kylechui/nvim-surround",
        tag = "*",
    })
    use "folke/zen-mode.nvim"

    -- AI
    use 'stevearc/dressing.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'MunifTanjim/nui.nvim'
    use 'MeanderingProgrammer/render-markdown.nvim'
    use 'HakonHarnes/img-clip.nvim'
    use 'zbirenbaum/copilot.lua'

    use {
        'yetone/avante.nvim',
        branch = 'main',
        run = 'make',
        config = function()
            require('avante').setup()
        end
    }
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
end)
