local nnoremap = require("thesbx.keymap").nnoremap
local builtin = require("telescope.builtin")

nnoremap("<leader>pv", "<cmd>Ex<CR>")
nnoremap("<leader>pt", "<cmd>Telescope find_files<CR>")
nnoremap("<leader>ps", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
nnoremap("<leader>gs", "<cmd>:Git<CR>")
nnoremap("<leader>gb", "<cmd>:G blame<CR>")
nnoremap("<leader>ga", "<cmd>Git fetch --all<CR>")
