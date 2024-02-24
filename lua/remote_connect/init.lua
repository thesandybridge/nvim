local M = {}

function M.sendMessageToWebSocket(url, message)
    local websocatCmd = string.format("echo '%s' | websocat '%s'", message, url)
    local result = vim.fn.systemlist(websocatCmd)
    if vim.v.shell_error ~= 0 then
        print("Failed to send message to WebSocket:", result[1])
        return
    end
    print("Message sent successfully")
end


function M.sendBufferUpdateToWebSocket(url, clientId)
    -- Get the current buffer's content
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local text = table.concat(lines, "\n")

    -- Get the current cursor position
    local cursor = vim.api.nvim_win_get_cursor(0)
    local position = cursor[1] -- This simplification assumes position is line number; adjust as needed

    -- Get the current file name
    local fileName = vim.api.nvim_buf_get_name(bufnr)

    -- Construct the data table
    local data = {
        file_name = fileName,
        client_id = clientId,
        position = position,
        text = text
    }

    -- Convert the table to a JSON string
    local jsonData = vim.fn.json_encode(data)

    -- Send the JSON string using websocat (or your WebSocket client method)
    local websocatCmd = string.format("echo '%s' | websocat '%s'", jsonData:gsub('"', '\\"'), url)
    local result = vim.fn.systemlist(websocatCmd)
    if vim.v.shell_error ~= 0 then
        print("Failed to send message to WebSocket:", result[1])
        return
    end
    print("Message sent successfully")
end


return M
