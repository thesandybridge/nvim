local ok, ts = pcall(require, 'nvim-treesitter')
if not ok then return end

ts.setup {
    ensure_installed = {
        "vimdoc",
        "javascript",
        "typescript",
        "c",
        "lua",
        "rust",
        "php",
        "markdown",
        "markdown_inline",
    },
    auto_install = true,
}

-- Highlighting, folds, and indentation are now wired up per-filetype
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        pcall(vim.treesitter.start)
    end,
})
