-- Coding assistance plugins
return {
  {
    'mfussenegger/nvim-lint',
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    'kaarmu/typst.vim',
    ft = 'typst',
  },
}
