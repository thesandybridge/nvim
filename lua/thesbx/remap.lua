local map = vim.keymap.set

map("n", "<leader>tv", ":call termcmd#horiz()<CR>", { desc = "Terminal horizontal split" })
map("n", "<leader>ts", ":call termcmd#vert()<CR>", { desc = "Terminal vertical split" })

map("n", "<leader>dfo", "<cmd>DiffviewOpen<CR>", { desc = "Open Diffview" })
map("n", "<leader>dfc", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" })

-- jump up/down half page and center cursor
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Previous search result" })

-- prevent Q mistype
map("n", "Q", "<nop>", { desc = "Disable Ex mode" })

-- not sure, found this one on Primes .dotfiles
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })
map({ "n", "v" }, "<leader>x", [["_d]], { desc = "Delete without yanking" })

-- enables "+ register for copying to clipboard
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })

map("n", "<C-t>", "<cmd>tabnext<CR>", { desc = "Next tab" })

map("n", "<leader><leader>", function()
  vim.cmd("so")
end, { desc = "Source current file" })

map("n", "<leader>xo", function()
  require("thesbx.external_open").open_current_buffer()
end, { desc = "Open file externally" })

map("n", "<leader>ch", function()
  return require("obsidian").util.toggle_checkbox()
end, { desc = "Toggle Obsidian checkbox" })

map("n", "<leader>gf", function()
  return require("obsidian").util.gf_passthrough()
end, { desc = "Obsidian follow link" })

map("n", "<C-w>q", "<cmd>q<CR>", { silent = true, desc = "Close window" })

-- TOhtml copy
map("n", "<leader>th", ":let @+ = expand('%:p:r') . '.html'<CR>", { silent = true, desc = "Copy HTML path" })

map("v", "<leader>cl", function()
  local buf = vim.api.nvim_get_current_buf()

  -- Save and normalize the visual selection positions
  vim.cmd('normal! "zy') -- yank selection into z register
  local text = vim.fn.getreg("z"):gsub("^%s+", ""):gsub("%s+$", "")

  local end_pos = vim.api.nvim_win_get_cursor(0)
  local insert_line = end_pos[1]

  local log = string.format("console.log('%s:', %s);", text, text)

  -- Insert console.log on the line below
  vim.api.nvim_buf_set_lines(buf, insert_line, insert_line, false, { log })

  -- Format the line (equalprg or built-in formatter)
  vim.api.nvim_win_set_cursor(0, { insert_line + 1, 0 })
  vim.cmd("normal! ==")
end, { desc = "Console log selected text" })
