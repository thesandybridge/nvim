-- Tool integrations
return {
  {
    "luckasRanarison/nvim-devdocs",
    cmd = { "DevdocsOpen", "DevdocsInstall" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },
  {
    'kawre/leetcode.nvim',
    cmd = "Leet",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require("leetcode").setup()
    end,
  },
  {
    "epwalsh/obsidian.nvim",
    cmd = { "ObsidianOpen", "ObsidianNew", "ObsidianSearch" },
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local obsidian_path = vim.fn.expand("~/obsidian")
      -- Only setup if obsidian directory exists
      if vim.fn.isdirectory(obsidian_path) == 1 then
        require("obsidian").setup({
          workspaces = {
            {
              name = "personal",
              path = obsidian_path,
            },
          },
        })
      end
    end,
  },
}
