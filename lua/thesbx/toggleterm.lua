require("toggleterm").setup({
    size = 20,
    open_mapping = [[<c-\>]],
    direction = "float",
    hide_numbers = true,
    close_on_exit = true,
    auto_scroll = true,
    persist_size = true,
    shade_terminals = true,
    start_in_inset = true,
    insert_mappings = true,
    float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
            border = "Normal",
            background = "Normal",
        },
    },
})
