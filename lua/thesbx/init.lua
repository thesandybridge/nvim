vim.cmd("filetype plugin indent on")

-- Load settings first (includes mapleader)
require("thesbx.set")
require("thesbx.remap")

-- Load lazy.nvim (must be after mapleader is set)
require("thesbx.lazy")

-- Load other configs
require("thesbx.toggleterm")
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

autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.tera",
    command = "set filetype=html",
})

autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.textwidth = 80
    end,
})
