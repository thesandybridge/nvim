require("obsidian").setup({
    workspaces = {
        {
            name = "Seabridge",
            path = "~/Projects/Seabridge",
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
        },
        ["<leader>i"] = {
            action = function()
                return open_image_in_feh()
            end,
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

local function open_image_in_feh()
    local current_line = vim.fn.getline(".")
    local match = string.match(current_line, "%((.-)%)")
    if match then
        local image_path = match
        local command = "feh " .. image_path .. " &"
        vim.notify("Executing: " .. command, vim.log.levels.INFO)
        local result = vim.fn.system(command)
        if vim.v.shell_error ~= 0 then
            vim.notify("Failed to open image with feh: " .. result, vim.log.levels.ERROR)
        end
    else
        vim.notify("No image path found on the current line", vim.log.levels.INFO)
    end
end

-- Adding the Lua function to the global table to reference it in the command
_G.open_image_in_feh = open_image_in_feh

-- Creating a command "FehOpenImage"
vim.api.nvim_create_user_command('FehOpenImage', open_image_in_feh, {})
--vim.keymap.set("n", "<leader>i", ":lua open_image_in_feh()<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search Obsidian" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToday<CR>", { desc = "Open today's note" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "Create new note" })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Open backlinks" })
