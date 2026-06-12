local M = {}

local image_extensions = {
  avif = true,
  bmp = true,
  gif = true,
  jpeg = true,
  jpg = true,
  png = true,
  svg = true,
  tiff = true,
  webp = true,
}

local function has_executable(command)
  return vim.fn.executable(command) == 1
end

function M.is_image(path)
  local extension = path:match("%.([^./]+)$")
  return extension and image_extensions[extension:lower()] or false
end

function M.open(path)
  if not path or path == "" then
    vim.notify("No file to open", vim.log.levels.WARN)
    return
  end

  path = vim.fn.fnamemodify(path, ":p")

  local command
  if M.is_image(path) and has_executable("feh") then
    command = { "feh", path }
  elseif has_executable("xdg-open") then
    command = { "xdg-open", path }
  elseif M.is_image(path) then
    vim.notify("Install feh or xdg-open to open images externally", vim.log.levels.ERROR)
    return
  else
    vim.notify("Install xdg-open to open files externally", vim.log.levels.ERROR)
    return
  end

  local ok, err = pcall(vim.system, command, { detach = true })
  if not ok then
    vim.notify("Failed to open " .. path .. ": " .. err, vim.log.levels.ERROR)
  end
end

function M.open_current_buffer()
  M.open(vim.api.nvim_buf_get_name(0))
end

return M
