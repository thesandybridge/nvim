local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        -- Enable ESLint formatting
        null_ls.builtins.formatting.prettierd.with({
            condition = function(utils)
                return utils.root_has_file({ ".eslintrc", ".eslintrc.js", ".eslintrc.json" }) -- Only enable if an ESLint config exists in the root
            end,
        }),
    },
})
