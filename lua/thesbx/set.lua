vim.opt.laststatus = 3 -- global statusline for all buffers
vim.opt.winbar = "%=%m %f"
vim.opt.guicursor = ""
vim.opt.splitbelow = true
vim.o.termguicolors = true

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

vim.opt.colorcolumn = "80"
vim.opt.cmdheight = 1
vim.opt.termguicolors = true

vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.updatetime = 50
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.g.mapleader = " "

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_liststyle = 3
vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro"
vim.g.netrw_keepdir = 1
vim.g.netrw_cursor = 1
vim.g.netrw_chgwin = 1
vim.g.netrw_preview = 1


