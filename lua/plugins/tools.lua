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
    opts = {},
  },
  {
    "epwalsh/obsidian.nvim",
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/obsidian/**.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/obsidian/**.md",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
