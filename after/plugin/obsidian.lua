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
        ["<C-l>"] = {
            action = function()
                return require("obsidian").util.toggle_checkbox()
            end,
            opts = { buffer = true },
        },
    },
    attachments = {
        -- The default folder to place images in via `:ObsidianPasteImg`.
        -- If this is a relative path it will be interpreted as relative to the vault root.
        -- You can always override this per image by passing a full path to the command instead of just a filename.
        img_folder = "assets/images",  -- This is the default
    },
    templates = {
        subdir = "templates",
        date_format = "%m-%d-%Y",
        time_format = "%H:%M",
    },

})
