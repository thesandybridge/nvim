return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = "main",
    lazy = false,
    build = ':TSUpdate',
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
}
