require("thesbx.set")
require("thesbx.remap")
require("thesbx.toggleterm")
require("thesbx.minimap")
require("thesbx.find_replace")

local augroup = vim.api.nvim_create_augroup
local SandyBridgeGroup = augroup('SandyBridge', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = SandyBridgeGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

vim.api.nvim_exec([[
  autocmd BufRead,BufNewFile *.jsx set filetype=jsx
  autocmd BufRead,BufNewFile *.tsx set filetype=tsx
  autocmd BufRead,BufNewFile *.php set filetype=phtml
]], false)
