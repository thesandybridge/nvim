local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Define filetypes where this snippet should be available
local filetypes = {"javascriptreact", "typescriptreact", "javascript", "typescript"}

-- Function to check if useState is already imported and add it if needed
local function ensure_react_import()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local content = table.concat(lines, "\n")

  -- Check if useState is already imported
  if content:match("import%s+{[^}]*useState[^}]*}%s+from%s+['\"]react['\"]") or
     content:match("import%s+React,%s*{[^}]*useState[^}]*}%s+from%s+['\"]react['\"]") then
    -- useState is already imported
    return ""
  end

  -- Check if there's a React import we can modify
  for i, line in ipairs(lines) do
    -- Check for import { something } from 'react'
    if line:match("^import%s+{.+}%s+from%s+['\"]react['\"]") then
      -- Add useState to existing import
      local new_line = line:gsub("{(.-)}", function(imports)
        -- Trim whitespace and add useState
        local trimmed = imports:match("^%s*(.-)%s*$")
        return "{ " .. trimmed .. ", useState }"
      end)
      vim.api.nvim_buf_set_lines(bufnr, i-1, i, false, {new_line})
      return ""
    end

    -- Check for import React from 'react'
    if line:match("^import%s+React%s+from%s+['\"]react['\"]") then
      -- Change to import React, { useState } from 'react'
      local new_line = "import React, { useState } from 'react'"
      vim.api.nvim_buf_set_lines(bufnr, i-1, i, false, {new_line})
      return ""
    end
  end

  -- No existing React import found, add a new one at the top
  vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, {"import { useState } from 'react';", ""})
  return ""
end

-- Create the useState snippet
local useState_snippet = s("uss", {
  f(ensure_react_import, {}),
  t("const ["),
  i(1, "state"),
  f(function(args)
    local state = args[1][1]
    return ", set" .. state:gsub("^%l", string.upper)
  end, {1}),
  t("] = useState("),
  i(2, "initialValue"),
  t(");"),
  i(0),
})

-- Add the snippet to all relevant filetypes
for _, filetype in ipairs(filetypes) do
  ls.add_snippets(filetype, {
    useState_snippet,
  })
end

