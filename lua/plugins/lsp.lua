-- LSP Configuration
return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim', build = ":MasonUpdate" },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { "L3MON4D3/LuaSnip", version = "v2.*" },
      { 'rafamadriz/friendly-snippets' },
    },
  },
  {
    'hrsh7th/vim-vsnip',
    event = "InsertEnter",
  },
  {
    'hrsh7th/vim-vsnip-integ',
    event = "InsertEnter",
  },
}
