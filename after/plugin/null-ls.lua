local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettierd.with({
            extra_args = { "--tab-width", "2" },
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "html", "css" },
        }),
        require("none-ls.diagnostics.eslint_d"),
        require("none-ls.code_actions.eslint_d"),
    },
    root_dir = require("null-ls.utils").root_pattern("tsconfig.json", "package.json"),
})
