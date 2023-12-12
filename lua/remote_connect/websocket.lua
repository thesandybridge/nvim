local websocket = require 'http.websocket'

local M = {}
local ws

function M.connect(host)
    if ws then
        print("Already connected. Please disconnect first.")
        return
    end

    local url = "ws://" .. host
    ws = websocket.new_from_uri(url)
    local ok, err = ws:connect()
    if not ok then
        print("Failed to connect: " .. err)
    end
end

function M.send_data(data)
    if not ws then
        print("WebSocket is not connected.")
        return
    end

    local json = require('json')  -- You need a JSON library to encode the data.
    local message = json.encode(data)
    ws:send(message)
end

function M.close()
    if ws then
        ws:close()
        ws = nil
    end
end

return M

