-- Coding assistance plugins
return {
  {
    'kkoomen/vim-doge',
    lazy = false,
    build = ':call doge#install()',
    init = function()
      vim.g.doge_enable_mappings = false
    end,
    keys = {
      { "<leader>dg", "<Plug>(doge-generate)", desc = "Generate docs" },
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
