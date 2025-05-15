-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- Plugin specifications
        { "wbthomason/packer.nvim" },

        -- THEMES
        -- { "folke/tokyonight.nvim" },
        -- { "catppuccin/nvim", as = "catppuccin" },
        -- { "navarasu/onedark.nvim" },
        -- { "ellisonleao/gruvbox.nvim" },
        { "sainnhe/gruvbox-material" },
        { "rebelot/kanagawa.nvim" },
        -- END THEMES

        { "nvim-tree/nvim-web-devicons" },
        -- { "github/copilot.vim" },
        { "lewis6991/gitsigns.nvim" },
        { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
        { "theHamsta/nvim-dap-virtual-text" },
        { "leoluz/nvim-dap-go" },
        {
            "nvim-telescope/telescope.nvim",
            dependencies = { "nvim-lua/plenary.nvim" }
        },
        { "nvim-telescope/telescope-ui-select.nvim" },

        -- GIT
        { "sindrets/diffview.nvim" },
        -- { "thesandybridge/blame.nvim" },
        { "FabijanZulj/blame.nvim" },
        {
            "NeogitOrg/neogit",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope.nvim",
                "sindrets/diffview.nvim",
            },
        },
        -- END GIT

        {
            "nvim-lualine/lualine.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons", opt = true }
        },

        { "norcalli/nvim-colorizer.lua" },
        {
            "kkoomen/vim-doge",
            build = ":call doge#install()"
        },
        { "folke/trouble.nvim" },
        {
            "luckasRanarison/nvim-devdocs",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope.nvim",
                "nvim-treesitter/nvim-treesitter",
            }
        },
        {
            "folke/todo-comments.nvim",
            dependencies = "nvim-lua/plenary.nvim",
        },
        { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
        { "nvim-treesitter/playground" },
        { "nvim-treesitter/nvim-treesitter-context" },
        { "hrsh7th/vim-vsnip" },
        { "hrsh7th/vim-vsnip-integ" },
        { "akinsho/toggleterm.nvim" },
        {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
            dependencies = { "nvim-lua/plenary.nvim" }
        },
        { "lukas-reineke/indent-blankline.nvim" },
        { "wakatime/vim-wakatime" },
        {
            "VonHeikemen/lsp-zero.nvim",
            dependencies = {
                -- LSP Support
                { "neovim/nvim-lspconfig" },
                { "williamboman/mason.nvim" },
                { "williamboman/mason-lspconfig.nvim" },

                -- Autocompletion
                { "hrsh7th/nvim-cmp" },
                { "hrsh7th/cmp-buffer" },
                { "hrsh7th/cmp-path" },
                { "saadparwaiz1/cmp_luasnip" },
                { "hrsh7th/cmp-nvim-lsp" },
                { "hrsh7th/cmp-nvim-lua" },

                -- Snippets
                { "L3MON4D3/LuaSnip" },
                { "rafamadriz/friendly-snippets" },
            },
            branch = "v3.x"
        },
        { "mvllow/modes.nvim" },
        {
            "epwalsh/obsidian.nvim",
            version = "*",  -- recommended, use latest release instead of latest commit
            lazy = true,
            ft = "markdown",
            -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
            -- event = {
            --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
            --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
            --   -- refer to `:h file-pattern` for more examples
            --   "BufReadPre path/to/my-vault/*.md",
            --   "BufNewFile path/to/my-vault/*.md",
            -- },
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
        },
        { "folke/which-key.nvim" },
        {
            "kylechui/nvim-surround",
            version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
            event = "VeryLazy",
        },
        { "folke/zen-mode.nvim" },

        -- AI
        { "stevearc/dressing.nvim" },
        { "nvim-lua/plenary.nvim" },
        { "MunifTanjim/nui.nvim" },
        { "MeanderingProgrammer/render-markdown.nvim" },
        { "HakonHarnes/img-clip.nvim" },
        { "zbirenbaum/copilot.lua" },

        {
            "yetone/avante.nvim",
            branch = "main",
            build = "make",
            config = function()
                require("avante").setup()
            end
        },
        {
            "numToStr/Comment.nvim",
            config = function()
                require("Comment").setup()
            end
        },
    },
    -- Configure any other settings here. See the documentation for more details.
    install = { colorscheme = { "gruvbox-material" } },
    checker = { enabled = true },
})

