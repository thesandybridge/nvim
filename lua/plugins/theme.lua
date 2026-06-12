-- Theme plugin
return {
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    lazy = false,
    init = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_dim_inactive_windows = 1
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-material",
    },
  },
}
