local ws = require('remote_connect.websocket')

local function remote_connect(host)
    ws.connect(host)

    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    local data = {
        text = table.concat(lines, "\n"),
        cursor = cursor_pos
    }

    ws.send_data(data)
end

vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
        ws.close()
    end
})

return {
    remote_connect =remote_connect,
}


