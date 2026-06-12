local function diagnostic_float_opts()
  return {
    border = "rounded",
    scope = "line",
    source = "if_many",
    header = "",
    prefix = "",
    focusable = false,
    max_width = math.min(100, math.max(40, math.floor(vim.o.columns * 0.72))),
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
  }
end

local function show_line_diagnostics()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local source_line = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], false)[1] or ""
  local source_ft = vim.bo.filetype ~= "" and vim.bo.filetype or "text"
  local diagnostics = vim.diagnostic.get(0, { lnum = cursor[1] - 1 })

  if vim.tbl_isempty(diagnostics) then
    vim.notify("No diagnostics on this line", vim.log.levels.INFO)
    return
  end

  table.sort(diagnostics, function(a, b)
    return (a.severity or vim.diagnostic.severity.HINT) < (b.severity or vim.diagnostic.severity.HINT)
  end)

  local severity = {
    [vim.diagnostic.severity.ERROR] = { "Error", "DiagnosticError" },
    [vim.diagnostic.severity.WARN] = { "Warning", "DiagnosticWarn" },
    [vim.diagnostic.severity.INFO] = { "Info", "DiagnosticInfo" },
    [vim.diagnostic.severity.HINT] = { "Hint", "DiagnosticHint" },
  }

  local width = math.min(76, math.max(42, math.floor(vim.o.columns * 0.48)))
  local lines = {}
  local highlights = {}

  local function markdown_fence_ft(ft)
    return ({
      javascriptreact = "jsx",
      typescriptreact = "tsx",
      sh = "bash",
      zsh = "bash",
    })[ft] or ft
  end

  local function wrap_text(text)
    local wrapped = {}
    local line = ""

    for word in text:gmatch("%S+") do
      if line == "" then
        line = word
      elseif vim.fn.strdisplaywidth(line .. " " .. word) <= width then
        line = line .. " " .. word
      else
        table.insert(wrapped, line)
        line = word
      end
    end

    if line ~= "" then
      table.insert(wrapped, line)
    end

    return wrapped
  end

  for i, diagnostic in ipairs(diagnostics) do
    local label = severity[diagnostic.severity] or { "Diagnostic", "DiagnosticInfo" }
    local source = diagnostic.source and (" from " .. diagnostic.source) or ""
    local code = diagnostic.code and (" [" .. diagnostic.code .. "]") or ""
    local message = diagnostic.message:gsub("%s+", " ")

    if i > 1 then
      table.insert(lines, "")
    end

    local header_line = label[1] .. source .. code
    table.insert(lines, header_line)
    table.insert(highlights, { line = #lines - 1, group = label[2], start_col = 0, end_col = #label[1] })

    for _, wrapped_line in ipairs(wrap_text(message)) do
      table.insert(lines, wrapped_line)
    end
  end

  if source_line ~= "" then
    table.insert(lines, "")
    table.insert(lines, "```" .. markdown_fence_ft(source_ft))
    table.insert(lines, source_line)
    table.insert(lines, "```")
  end

  local height = math.min(#lines, math.max(1, math.floor(vim.o.lines * 0.35)))
  local bufnr = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].filetype = "markdown"

  pcall(vim.treesitter.start, bufnr, "markdown")

  for _, hl in ipairs(highlights) do
    vim.api.nvim_buf_add_highlight(bufnr, -1, hl.group, hl.line, hl.start_col, hl.end_col)
  end

  local winid = vim.api.nvim_open_win(bufnr, false, {
    relative = "cursor",
    row = 1,
    col = 0,
    width = width,
    height = height,
    border = "rounded",
    title = " Diagnostic ",
    title_pos = "left",
    style = "minimal",
    focusable = false,
    noautocmd = true,
  })

  vim.wo[winid].wrap = false
  vim.wo[winid].breakindent = true
  vim.wo[winid].conceallevel = 2
  vim.wo[winid].concealcursor = "nvc"
  vim.wo[winid].winhl = "Normal:NormalFloat,FloatBorder:FloatBorder"

  vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave", "FocusLost" }, {
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(winid) then
        vim.api.nvim_win_close(winid, true)
      end
    end,
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.diagnostic.config({
        severity_sort = true,
        float = diagnostic_float_opts(),
      })

      local function filtered_definitions()
        local ok, telescope = pcall(require, "telescope.builtin")
        if not ok then
          vim.lsp.buf.definition()
          return
        end

        vim.lsp.buf_request(0, "textDocument/definition", vim.lsp.util.make_position_params(), function(_, result)
          if not result or vim.tbl_isempty(result) then
            return
          end

          local locations = vim.islist(result) and result or { result }
          local filtered = vim.tbl_filter(function(loc)
            local uri = loc.uri or loc.targetUri or ""
            return not uri:match("node_modules") and not uri:match("index%.d%.ts")
          end, locations)

          if vim.tbl_isempty(filtered) then
            vim.notify("No non-node_modules definitions found", vim.log.levels.INFO)
            return
          end

          telescope.lsp_definitions({
            jump_type = "never",
            locations = filtered,
          })
        end)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("SandyBridgeLspKeymaps", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client then
            client.server_capabilities.semanticTokensProvider = nil
          end

          local opts = { buffer = event.buf, remap = false, silent = true }
          vim.keymap.set("n", "gd", filtered_definitions, vim.tbl_extend("force", opts, { desc = "Definitions" }))
          vim.keymap.set(
            "n",
            "<leader>gd",
            vim.lsp.buf.definition,
            vim.tbl_extend("force", opts, { desc = "Go to definition" })
          )
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
          vim.keymap.set(
            "n",
            "<leader>vws",
            vim.lsp.buf.workspace_symbol,
            vim.tbl_extend("force", opts, { desc = "Workspace symbols" })
          )
          vim.keymap.set(
            "n",
            "<leader>vd",
            show_line_diagnostics,
            vim.tbl_extend("force", opts, { desc = "Line diagnostics" })
          )
          vim.keymap.set("n", "[d", function()
            vim.diagnostic.jump({ count = 1, float = false })
          end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
          vim.keymap.set("n", "]d", function()
            vim.diagnostic.jump({ count = -1, float = false })
          end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
          vim.keymap.set(
            "n",
            "<leader>va",
            vim.lsp.buf.code_action,
            vim.tbl_extend("force", opts, { desc = "Code action" })
          )
          vim.keymap.set(
            "n",
            "<leader>vrr",
            vim.lsp.buf.references,
            vim.tbl_extend("force", opts, { desc = "References" })
          )
          vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
          vim.keymap.set(
            "i",
            "<C-h>",
            vim.lsp.buf.signature_help,
            vim.tbl_extend("force", opts, { desc = "Signature help" })
          )
        end,
      })
    end,
    opts = function(_, opts)
      local function get_intelephense_license()
        local path = vim.fn.expand("~/.config/intelephense/license.txt")
        local f = io.open(path, "rb")
        if not f then
          return nil
        end
        local content = f:read("*a")
        f:close()
        return content:gsub("%s+", "")
      end

      local function find_wordpress_root(bufnr)
        local filepath = vim.api.nvim_buf_get_name(bufnr or 0)
        return filepath:match("(.*/public)/.*") or vim.fs.root(filepath, { "composer.json", ".git" })
      end

      opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
        virtual_text = true,
        severity_sort = true,
        float = diagnostic_float_opts(),
      })

      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
        gopls = {
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
        },
        denols = {
          root_dir = function(fname)
            return vim.fs.root(fname, { "deno.json", "deno.jsonc" })
          end,
        },
        zls = {},
        ts_ls = {
          on_attach = function(client, bufnr)
            local ok, lint = pcall(require, "lint")
            local lint_cfg = ok and lint.linters_by_ft[vim.bo[bufnr].filetype] or nil
            if lint_cfg and vim.tbl_contains(lint_cfg, "eslint_d") then
              local root = vim.fs.find({
                ".eslintrc",
                ".eslintrc.json",
                ".eslintrc.js",
                "eslint.config.js",
                "eslint.config.mjs",
              }, {
                upward = true,
                path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
              })[1]
              if root then
                client.handlers["textDocument/publishDiagnostics"] = function() end
              end
            end
          end,
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              assist = {
                importGranularity = "module",
                importPrefix = "by_self",
              },
              cargo = {
                loadOutDirsFromCheck = true,
                allFeatures = true,
              },
              procMacro = {
                enable = true,
              },
              check = {
                command = "clippy",
              },
              checkOnSave = true,
            },
          },
        },
        intelephense = {
          root_dir = find_wordpress_root,
          init_options = {
            licenseKey = get_intelephense_license(),
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
                  vim.fn.expand("~/.config/composer/vendor/"),
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
        },
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "rust-analyzer",
        "intelephense",
        "lua-language-server",
        "gopls",
        "marksman",
        "typescript-language-server",
        "zls",
      },
    },
  },
}
