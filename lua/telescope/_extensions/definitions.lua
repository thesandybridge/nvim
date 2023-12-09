local telescope = require('telescope')
local previewers = require('telescope.previewers')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local function process_lsp_response(response)
    local items = {}
    for _, item in ipairs(response) do
        print("Item:", vim.inspect(item))
        local name = item.name
        local sline, fline
        local uri = item.location.uri

        -- Check if 'range' field is present and extract start and end lines
        if item.location.range then
            sline = item.location.range.start.line
            fline = item.location.range["end"].line
        else
            -- Handle the case when 'range' field is missing
            sline = 1
            fline = 1
        end

        table.insert(items, {
            name = name,
            sline = sline,
            fline = fline,
            uri = uri
        })
    end
    return items
end

local function get_all_items(callback)
    local bufnr = vim.api.nvim_get_current_buf()

    vim.lsp.buf_request(bufnr, 'workspace/symbol', {
        query = ""
    },
    function(err, result)
        if err then
            print("Error from LSP:", err)
            return
        end

        local definitions = process_lsp_response(result)
        callback(definitions)
    end)
end

local function function_entry_maker(item)
    return {
        value = item.name,
        display = item.name .. " - Line: " .. tostring(item.line),
        ordinal = item.name,
        lnum = item.sline,
        fnum = item.fline,
        item = item,
        uri = item.uri,
        filename = vim.fn.bufname("%")
    }
end

local function define_preview(self, entry, status)
    -- Debugging: Check the entry and state values

    if not self.state or not self.state.winid then
        print("Error: preview window state is not set")
        return
    end

    if not vim.api.nvim_win_is_valid(self.state.winid) then
        print("Error: Invalid preview window ID")
        return
    end

    if not entry or not entry.filename or not entry.lnum then
        print("Error: Invalid entry data")
        return
    end

    print("URI:", entry.uri)
    local file_path = vim.fn.expand(entry.uri:sub(8))
    print("File Path:", file_path)

    if not entry.uri:match("^file://") then
        print("Error: Invalid URI format")
        return
    end

    -- Read the file content using Neovim's built-in function
    local file_content = vim.fn.readfile(file_path)

    if not file_content or #file_content == 0 then
        print("Error: File content is empty")
        return
    end

    -- Set the content in the preview buffer
    local filetype = vim.filetype.match({filename = file_path})
    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, file_content)
    vim.api.nvim_buf_set_option(self.state.bufnr, 'filetype', filetype)

    -- Set the cursor to the line number of the selected function
    vim.api.nvim_win_set_buf(self.state.winid, self.state.bufnr)

    vim.api.nvim_win_set_cursor(self.state.winid, {entry.lnum, 0})
end

local function show_definitions()
    get_all_items(function(definitions)
        pickers.new({}, {
            prompt_title = 'Definitions in File',
            finder = finders.new_table({
                results = definitions,
                entry_maker = function_entry_maker
            }),
            sorter = conf.generic_sorter({}),
            previewer = previewers.new_buffer_previewer({
                define_preview = define_preview
            }),
            attach_mappings = function(prompt_bufnr, map)
                map('i', '<CR>', function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    if selection and selection.uri then
                        -- Convert the URI to a file path and navigate to the file and line
                        local file_path = vim.uri_to_fname(selection.uri)
                        vim.cmd('edit ' .. file_path)
                        vim.api.nvim_win_set_cursor(0, {selection.lnum + 1, 0})
                    end
                end)
                return true
            end
        }):find()
    end)
end

return telescope.register_extension({
    exports = {
        definitions = show_definitions
    },
})

