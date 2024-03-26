vim.g.gruvbox_material_background = 'medium'
vim.g.gruvbox_material_enable_bold = 1
vim.g.gurvbox_material_better_performance = 1
vim.g.gruvbox_material_dim_inactive_windows = 1
-- setup must be called before loading
vim.cmd("colorscheme gruvbox-material")
require'colorizer'.setup()
