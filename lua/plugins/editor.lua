-- Editor enhancement plugins
return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon add file" },
      { "<C-e>", function() local harpoon = require("harpoon"); harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon menu" },
      { "<C-h>", function() require("harpoon"):list():select(1) end, desc = "Harpoon file 1" },
      { "<C-t>", function() require("harpoon"):list():select(2) end, desc = "Harpoon file 2" },
      { "<C-n>", function() require("harpoon"):list():select(3) end, desc = "Harpoon file 3" },
      { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon file 4" },
      { "<C-S-P>", function() require("harpoon"):list():prev() end, desc = "Harpoon previous" },
      { "<C-S-N>", function() require("harpoon"):list():next() end, desc = "Harpoon next" },
    },
    opts = {},
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
  {
    'numToStr/Comment.nvim',
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        keywords = {
          FIX = {
            icon = " ",
            color = "error",
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
          },
          TODO = { icon = "✔️", color = "info" },
          HACK = { icon = "", color = "warning" },
          WARN = { icon = "", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = "", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = "", color = "hint", alt = { "INFO" } },
          TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        }
      }
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
        scope = { enabled = false },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    -- Config is in lua/thesbx/toggleterm.lua
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {},
  },
  {
    "folke/twilight.nvim",
    cmd = "Twilight",
    config = function()
      require("twilight").setup({
        dimming = {
          alpha = 0.25,
          color = { "Normal", "#ffffff" },
          term_bg = "#000000",
          inactive = false,
        },
        context = 10,
        treesitter = true,
        expand = {
          "function",
          "method",
          "table",
          "if_statement",
        },
        exclude = {},
      })
    end,
  },
}
