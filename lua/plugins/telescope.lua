-- Telescope and related plugins
return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = "Telescope",
    keys = {
      { "<leader>ff", desc = "Find files" },
      { "<leader>fg", desc = "Live grep" },
      { "<C-p>", desc = "Git files" },
    },
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    event = "VeryLazy",
  },
}
