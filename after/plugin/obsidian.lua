require("obsidian").setup({
    workspaces = {
        {
            name = "Seabridge",
            path = "~/Dev/Seabridge",
        },
    },
    daily_notes = {
        folder = "daily_notes",
        date_format = "%m-%d-%Y",
        template = "templates/daily.md",
    },
    disable_frontmatter = false,
    mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
            action = function()
                return require("obsidian").util.gf_passthrough()
            end,
            opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>ch"] = {
            action = function()
                return require("obsidian").util.toggle_checkbox()
            end,
            opts = { buffer = true },
        },
    },

})
