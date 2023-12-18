local lsp_zero = require("lsp-zero")

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

lsp_zero.set_preferences({
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp_zero.on_attach(function(_, bufnr)
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "gd", function()
        require"telescope.builtin".lsp_definitions({jump_type="tab"})
    end, opts)
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

local get_intelephense_license = function ()
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

--lsp_zero.setup()

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'tsserver',
        'rust_analyzer',
        'eslint',
        'intelephense',
        'lua_ls',
    },
    handlers = {
        lsp_zero.default_setup,
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
                filetypes = {"php", "phtml"},
            })
        end,
  }
})

-- enables error output to the right of the line with the error
vim.diagnostic.config({
    virtual_text = true
})
