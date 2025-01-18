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
    autocmd BufRead,BufNewFile *.tera set filetype=html
]], false)

vim.api.nvim_exec([[
  augroup NetrwCursorLine
    autocmd!
    autocmd FileType netrw,netrwTree setlocal cursorline
    autocmd FileType netrw,netrwTree autocmd CursorMoved <buffer> setlocal cursorline
  augroup END
]], false)


autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.textwidth = 80
    end,
})
--vim.api.nvim_command('autocmd BufNewFile,BufRead *.php setlocal syntax=php')
--

vim.cmd('filetype indent on')
