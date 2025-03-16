vim.g.minimap_width = 10
vim.g.minimap_auto_start = 1
vim.g.minimap_auto_start_win_enter = 1
vim.g.minimap_git_colors = 1
vim.g.minimap_highlight_range = 0
vim.g.minimap_highlight_search = 1
vim.g.minimap_highlight = 'Keyword'
vim.g.minimap_block_filetypes = { 'fugitive', 'nerdtree', 'tagbar', 'fzf' }
vim.g.minimap_block_buftypes = {
    'nofile',
    'nowrite',
    'quickfix',
    'terminal',
    'prompt',
    'NeogitStatus',
}

-- require("scrollbar").setup()
