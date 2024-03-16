require('neogit').setup {
    integrations = {
        diffview = true
    }
}

vim.keymap.set("n", "<leader>gs", vim.cmd.Neogit)
vim.keymap.set("n", "gh", "<cmd>diffget //2<CR>")
vim.keymap.set("n", "gl", "<cmd>diffget //3<CR>")
