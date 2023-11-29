vim.keymap.set('i', '<C-J>', 'copilot#Accept("\n")', {
    expr = true,
    replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
