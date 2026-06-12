local M = {}

local tools = {
  "rg",
  "fd",
  "stylua",
  "shfmt",
  "prettierd",
  "goimports",
  "rust-analyzer",
  "gopls",
  "intelephense",
  "lua-language-server",
  "typescript-language-server",
  "zls",
}

local function executable_status(name)
  if vim.fn.executable(name) == 1 then
    return "ok      " .. name
  end

  return "missing " .. name
end

local function active_lsp_lines(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if vim.tbl_isempty(clients) then
    return { "none" }
  end

  table.sort(clients, function(a, b)
    return a.name < b.name
  end)

  return vim.tbl_map(function(client)
    return client.name
  end, clients)
end

local function formatter_lines(bufnr)
  local conform = package.loaded.conform
  if not conform then
    return { "conform.nvim is not loaded yet" }
  end

  local formatters = conform.list_formatters_for_buffer(bufnr)
  if vim.tbl_isempty(formatters) then
    return { "none for filetype: " .. (vim.bo[bufnr].filetype ~= "" and vim.bo[bufnr].filetype or "unset") }
  end

  return vim.tbl_map(function(name)
    local info = conform.get_formatter_info(name, bufnr)
    local prefix = info.available and "ok      " or "missing "
    local detail = info.available_msg and (" - " .. info.available_msg) or ""
    return prefix .. name .. detail
  end, formatters)
end

local function append_section(lines, title, section_lines)
  table.insert(lines, title)
  table.insert(lines, string.rep("-", #title))
  vim.list_extend(lines, section_lines)
  table.insert(lines, "")
end

function M.open()
  local bufnr = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(bufnr)
  local lines = {
    "Neovim Config Health",
    "====================",
    "",
    "Buffer: " .. (path ~= "" and path or "[No Name]"),
    "Filetype: " .. (vim.bo[bufnr].filetype ~= "" and vim.bo[bufnr].filetype or "unset"),
    "",
  }

  append_section(lines, "External Tools", vim.tbl_map(executable_status, tools))
  append_section(lines, "Active LSP", active_lsp_lines(bufnr))
  append_section(lines, "Formatters", formatter_lines(bufnr))

  local health_bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[health_bufnr].bufhidden = "wipe"
  vim.bo[health_bufnr].filetype = "text"
  vim.api.nvim_buf_set_lines(health_bufnr, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = health_bufnr })
  vim.cmd("tabnew")
  vim.api.nvim_win_set_buf(0, health_bufnr)
end

function M.setup()
  vim.api.nvim_create_user_command("ConfigHealth", M.open, {
    desc = "Open a Neovim config health report",
  })
end

return M
