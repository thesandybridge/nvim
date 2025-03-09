local nvim_lsp = require('lspconfig')
local lsp_zero = require("lsp-zero")

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local luasnip = require('luasnip')

local snippet_path = os.getenv("HOME")

require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_vscode').lazy_load({
    paths = { snippet_path .. '/.config/nvim/snippets/' },
})

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body) -- LuaSnip expand
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end,
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
    }
})

lsp_zero.set_preferences({
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    },
    semantic_highlighting = true,
})

lsp_zero.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function()
        require "telescope.builtin".lsp_definitions({ jump_type = "never" })
    end, opts)
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { noremap = true, silent = true })
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>va", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

local get_intelephense_license = function()
    local f = assert(io.open(os.getenv("HOME") .. "/.config/intelephense/license.txt", "rb"))
    local content = f:read("*a")
    f:close()
    return string.gsub(content, "%s+", "")
end

local function find_wordpress_root()
    local filepath = vim.api.nvim_buf_get_name(0)
    local project_root = filepath:match("(.*/public)/.*")
    return project_root
end

-- Autoformat on save
-- @param client lsp client
-- @param bufnr buffer number
local on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function() vim.lsp.buf.format({ async = false }) end
        })
    end
end

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'rust_analyzer',
        'intelephense',
        'lua_ls',
        'gopls',
        'marksman',
        'eslint',
        'ts_ls',
        'zls',
    },
    handlers = {
        lsp_zero.default_setup,
        gopls = function()
            require('lspconfig').gopls.setup({
                cmd = { "gopls", "serve" },
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                    },
                },
                on_attach = on_attach
            })
        end,
        denols = function()
            require('lspconfig').denols.setup({
                on_attach = on_attach,
                root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc")
            })
        end,
        zls = function ()
            require('lspconfig').zls.setup({
            })
        end,
        ts_ls = function ()
            require('lspconfig').ts_ls.setup({
                on_attach = function(client, bufnr)
                    -- Disable tsserver diagnostics
                    client.handlers["textDocument/publishDiagnostics"] = function() end
                end,
            })
        end,
        eslint = function()
            require('lspconfig').eslint.setup({
                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = true
                    client.server_capabilities.documentRangeFormattingProvider = true
                end,
            })
        end,
        rust_analyzer = function()
            require('lspconfig').rust_analyzer.setup({
                settings = {
                    ["rust-analyzer"] = {
                        assist = {
                            importGranularity = "module",
                            importPrefix = "by_self",
                        },
                        cargo = {
                            loadOutDirsFromCheck = true
                        },
                        procMacro = {
                            enable = true
                        },
                    }
                },
                on_attach = function(client, bufnr)
                    if client.server_capabilities.documentFormattingProvider then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr,
                            callback = function() vim.lsp.buf.format({ async = false }) end
                        })
                    end
                end
            })
        end,
        intelephense = function()
            require('lspconfig').intelephense.setup({
                root_dir = find_wordpress_root,
                init_options = {
                    licenseKey = get_intelephense_license()
                },
                settings = {
                    intelephense = {
                        format = {
                            braces = "k&r",
                            indent = {
                                alignment = 4,
                            },
                        },
                        environment = {
                            includePaths = {
                                "/home/sbx/.config/composer/vendor/"
                            },
                        },
                        stubs = {
                            "apache",
                            "bcmath",
                            "bz2",
                            "calendar",
                            "com_dotnet",
                            "Core",
                            "ctype",
                            "curl",
                            "date",
                            "dba",
                            "dom",
                            "enchant",
                            "exif",
                            "FFI",
                            "fileinfo",
                            "filter",
                            "fpm",
                            "ftp",
                            "gd",
                            "gettext",
                            "gmp",
                            "hash",
                            "iconv",
                            "imap",
                            "intl",
                            "json",
                            "ldap",
                            "libxml",
                            "mbstring",
                            "meta",
                            "mysqli",
                            "oci8",
                            "odbc",
                            "openssl",
                            "pcntl",
                            "pcre",
                            "PDO",
                            "pdo_ibm",
                            "pdo_mysql",
                            "pdo_pgsql",
                            "pdo_sqlite",
                            "pgsql",
                            "Phar",
                            "posix",
                            "pspell",
                            "readline",
                            "Reflection",
                            "session",
                            "shmop",
                            "SimpleXML",
                            "snmp",
                            "soap",
                            "sockets",
                            "sodium",
                            "SPL",
                            "sqlite3",
                            "standard",
                            "superglobals",
                            "sysvmsg",
                            "sysvsem",
                            "sysvshm",
                            "tidy",
                            "tokenizer",
                            "xml",
                            "xmlreader",
                            "xmlrpc",
                            "xmlwriter",
                            "xsl",
                            "Zend OPcache",
                            "zip",
                            "zlib",
                            "wordpress",
                            "imagick",
                            "woocommerce",
                            "wp-cli",
                            "wpsyntex",
                            "wordpress-stubs",
                            "wp-cli-stubs",
                            "woocommerce-stubs",
                            "timber-stubs",
                            "twig-stubs",
                        },
                    },
                },
                filetypes = { "php", "phtml" },
                on_attach = on_attach
            })
        end,
    }
})

-- enables error output to the right of the line with the error
vim.diagnostic.config({
    virtual_text = true
})
