local nnoremap = require("thesbx.keymap").nnoremap

nnoremap("<leader>pv", "<cmd>Ex<CR>")
nnoremap("<leader>pt", "<cmd>Telescope find_files<CR>")
nnoremap("<leader>gs", "<cmd>:Git<CR>")
nnoremap("<leader>ga", "<cmd>Git fetch --all<CR>")
