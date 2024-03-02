require("obsidian").setup({
    workspaces = {
        {
            name = "Seabridge",
            path = "~/Dev/Seabrdige",
        },
    },
    daily_notes = {
        folder = "daily_notes",
        date_format = "%MM-%DD-%YY",
        template = "templates/daily.md",
    },
    disable_frontmatter = false,

})
