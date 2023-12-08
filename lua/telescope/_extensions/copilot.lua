local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')

local copilot_panel = function(opts)
    opts = opts or {}

    pickers.new(opts, {
        prompt_title = 'Copilot Panel',
        finder = finders.new_table({
            results = {'Open Copilot Panel'}
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            map('i', '<CR>', function()
                actions.close(prompt_bufnr)
                vim.cmd('Copilot panel')
            end)
            return true
        end,
    }):find()
end

return require('telescope').register_extension({
    exports = {
        copilot = copilot_panel,
    },
})

