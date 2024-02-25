local config = {
    send_rate = 5
}

-- Convert the Lua table to a string representation for Python
local config_str = vim.fn.json_encode(config)

-- Correct way to call the configure command of your Python plugin with the configuration string
vim.cmd('WSConfigure ' .. config_str)

