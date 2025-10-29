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
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = {'php', 'tsx', 'jsx'},
    },
}

local ok_statusline, treesitter = pcall(require, "nvim-treesitter")
if ok_statusline then
    treesitter.statusline()
end

