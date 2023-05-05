vim.api.nvim_create_user_command("FindReplace", function(opts)
    if #opts.fargs < 1 then
        vim.api.nvim_err_writeln("FindReplace requires a search_pattern argument")
        return
    end

    local search_pattern = vim.fn.escape(opts.fargs[1], '\\/.*$^~[]')
    local replace_escaped = vim.fn.escape(opts.fargs[2], '\\/&~')

    local command = string.format("%%s/%s/%s/g", search_pattern, replace_escaped)
    vim.cmd(command)
end,
{ nargs = "*" })


