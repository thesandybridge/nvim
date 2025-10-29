-- Only run if treesitter is loaded
local ok, nvim_treesitter = pcall(require, 'nvim-treesitter.configs')
if not ok then
    return
end

nvim_treesitter.setup {
    -- A list of parser names, or "all"
    ensure_installed = {
        "vimdoc",
        "javascript",
        "typescript",
        "c",
        "lua",
        "rust",
        "php",
        "markdown",
        "markdown_inline"
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = true,

    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    indent = {
        enable = true,
    },

    highlight = {
        enable = true,
        -- Disable vim regex highlighting to prevent conflicts with treesitter
        -- and improve performance
        additional_vim_regex_highlighting = false,
    },
}

local ok_statusline, treesitter = pcall(require, "nvim-treesitter")
if ok_statusline then
    treesitter.statusline()
end

