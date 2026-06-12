require("thesbx.find_replace")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  group = augroup("HighlightYank", {}),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

autocmd("BufWritePre", {
  group = augroup("SandyBridge", {}),
  pattern = "*",
  callback = function()
    local excluded = {
      gitcommit = true,
      markdown = true,
    }
    if not excluded[vim.bo.filetype] then
      vim.cmd([[%s/\s\+$//e]])
    end
  end,
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
