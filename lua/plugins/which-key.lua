return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.delay = 1000000
      opts.triggers = {}
      opts.notify = false
      return opts
    end,
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Show keymaps",
      },
    },
  },
}
