Remap = require("thesbx.keymap")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  nnoremap("gd", function() vim.lsp.buf.definition() end, bufopts)
  nnoremap("K", function() vim.lsp.buf.hover() end, bufopts)
  nnoremap("<leader>vws", function() vim.lsp.buf.workspace_symbol() end, bufopts)
  nnoremap("<leader>vd", function() vim.diagnostic.open_float() end, bufopts)
  nnoremap("[d", function() vim.diagnostic.goto_next() end, bufopts)
  nnoremap("]d", function() vim.diagnostic.goto_prev() end, bufopts) 
  nnoremap("<leader>vca", function() vim.lsp.buf.code_action() end, bufopts)

end

local lsp_flags = {
    debounce_text_changes = 150,
}

require'lspconfig'.emmet_ls.setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
require'lspconfig'.intelephense.setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
require'lspconfig'.pyright.setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
require'lspconfig'.rust_analyzer.setup{
    on_attach = on_attach,
    flags = lsp_flags,
    settings = {
        ["rust_analyzer"] = {}
    }
}
require'lspconfig'.gopls.setup{
    on_attach = on_attach,
}
