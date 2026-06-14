local M = {}

local root_markers = {
  "mise.toml",
  ".mise.toml",
  ".git",
  "package.json",
  "Cargo.toml",
  "go.mod",
}

local function shell_quote(value)
  return "'" .. tostring(value):gsub("'", [['"'"']]) .. "'"
end

local function project_root()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    path = vim.uv.cwd()
  end

  return vim.fs.root(path, root_markers) or vim.uv.cwd()
end

local function terminal_command(root, task)
  local command = "mise run " .. shell_quote(task)

  if vim.env.TMUX and vim.fn.executable("tmux") == 1 then
    vim.system({
      "tmux",
      "display-popup",
      "-E",
      "-w",
      "90%",
      "-h",
      "85%",
      "-d",
      root,
      "/bin/bash",
      "-lc",
      command .. [[; status=$?; echo; read -r -p "Press Enter to close..."; exit $status]],
    })
    return
  end

  vim.cmd("botright split")
  vim.cmd("resize 15")
  vim.cmd("terminal cd " .. shell_quote(root) .. " && " .. command)
end

local function task_names(root)
  local result = vim.system({ "mise", "tasks", "--json" }, { cwd = root, text = true }):wait()
  if result.code ~= 0 then
    vim.notify(result.stderr ~= "" and result.stderr or "Failed to list mise tasks", vim.log.levels.ERROR)
    return {}
  end

  local ok, decoded = pcall(vim.json.decode, result.stdout)
  if not ok or type(decoded) ~= "table" then
    vim.notify("Could not parse mise task list", vim.log.levels.ERROR)
    return {}
  end

  local names = {}
  for _, task in ipairs(decoded) do
    local name = task.name or task.alias or task.task
    if name then
      table.insert(names, name)
    end
  end

  table.sort(names)
  return names
end

function M.run(task)
  local root = project_root()
  terminal_command(root, task)
end

function M.select()
  local root = project_root()
  local tasks = task_names(root)

  if vim.tbl_isempty(tasks) then
    vim.notify("No mise tasks found in " .. root, vim.log.levels.INFO)
    return
  end

  vim.ui.select(tasks, {
    prompt = "mise run",
  }, function(task)
    if task then
      terminal_command(root, task)
    end
  end)
end

return M
