-- Custom keymaps
-- exit to netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- open teriminal split window
--vim.keymap.set("n", "<leader>tt", ":new +terminal<CR>")
vim.keymap.set("n", "<leader>tv", ":call termcmd#horiz()<CR>")
vim.keymap.set("n", "<leader>ts", ":call termcmd#vert()<CR>")
-- jump up/down half page and center cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- prevent Q mistype
vim.keymap.set("n", "Q", "<nop>")
-- not sure, found this one on Primes .dotfiles
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
-- enables "+ register for copying to clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<C-t>", ":tabnext<CR>")

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

vim.keymap.set("n", "<leader>ch", function()
    return require("obsidian").util.toggle_checkbox()
end)

vim.keymap.set("n", "<leader>gf", function()
    return require("obsidian").util.gf_passthrough()
end)

vim.keymap.set("v", "<leader>sc", ":Silicon<CR>", { silent = true })

vim.keymap.set("n", "<C-w>q", ":bd<CR>", { silent = true })
