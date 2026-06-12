return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      local js_linters = {}

      if vim.fn.executable("oxlint") == 1 then
        table.insert(js_linters, "oxlint")
      end

      if vim.fn.executable("eslint_d") == 1 then
        local eslint_d = lint.linters.eslint_d
        eslint_d.args = {
          "--format",
          "json",
          "--stdin",
          "--stdin-filename",
          function()
            return vim.api.nvim_buf_get_name(0)
          end,
        }
        eslint_d.parser = function(output)
          local json_line = nil
          for _, line in ipairs(vim.split(output, "\n")) do
            if line:match("^%[") then
              json_line = line
              break
            end
          end
          if not json_line then
            return {}
          end
          local ok, result = pcall(vim.json.decode, json_line)
          if not ok or not result or not result[1] then
            return {}
          end
          local diagnostics = {}
          for _, msg in ipairs(result[1].messages or {}) do
            if msg.line then
              table.insert(diagnostics, {
                lnum = msg.line - 1,
                col = (msg.column or 1) - 1,
                message = msg.message,
                severity = msg.severity == 2 and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN,
                source = "eslint_d",
              })
            end
          end
          return diagnostics
        end
        eslint_d.condition = function(ctx)
          return vim.fs.find({
            ".eslintrc",
            ".eslintrc.json",
            ".eslintrc.js",
            "eslint.config.js",
            "eslint.config.mjs",
          }, { path = ctx.filename, upward = true })[1] ~= nil
        end
        table.insert(js_linters, "eslint_d")
      end

      if #js_linters == 0 then
        return
      end

      lint.linters_by_ft = {
        typescript = js_linters,
        javascript = js_linters,
        typescriptreact = js_linters,
        javascriptreact = js_linters,
      }

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("SandyBridgeLint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
