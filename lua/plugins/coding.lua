-- Coding assistance plugins
return {
  {
    'kkoomen/vim-doge',
    build = ':call doge#install()',
    keys = {
      { "<leader>d", desc = "Generate docs" },
    },
  },
  {
    'mfussenegger/nvim-lint',
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    'kaarmu/typst.vim',
    ft = 'typst',
  },
}
