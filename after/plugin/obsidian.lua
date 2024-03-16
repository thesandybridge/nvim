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
        template = "daily.md",
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
        }
    },
    follow_url_func = function(url)
        vim.fn.jobstart({"xdg-open", url})  -- linux
    end,
    attachments = {
        img_folder = "assets/images",
    },
    templates = {
        subdir = "templates",
        date_format = "%m-%d-%Y",
        time_format = "%H:%M",
    },

})

vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search Obsidian" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToday<CR>", { desc = "Open today's note" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "Create new note" })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Open backlinks" })
