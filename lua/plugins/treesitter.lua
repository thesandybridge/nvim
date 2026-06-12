return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "vimdoc",
        "javascript",
        "typescript",
        "c",
        "lua",
        "rust",
        "php",
        "markdown",
        "markdown_inline",
      },
      auto_install = true,
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("SandyBridgeTreesitter", { clear = true }),
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable = true,
      max_lines = 3,
    },
  },
}
