-- Theme plugin
return {
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    lazy = false,
    config = function()
      -- Configure before loading
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_dim_inactive_windows = 1

      -- Apply colorscheme
      vim.cmd("colorscheme gruvbox-material")
    end,
  },
}
