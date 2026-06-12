return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.delay = 1000000
      opts.triggers = {}
      opts.notify = false
      opts.spec = vim.list_extend(opts.spec or {}, {
        { "<leader>?", desc = "Show keymaps" },
        { "<leader>a", desc = "Harpoon add file" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug/diff" },
        { "<leader>df", group = "diffview" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "go/git" },
        { "<leader>h", group = "hunks" },
        { "<leader>p", group = "project/paste" },
        { "<leader>t", group = "toggles/tools" },
        { "<leader>v", group = "lsp" },
        { "<leader>vr", group = "rename/references" },
        { "<leader>x", group = "diagnostics" },
        { "<leader>z", group = "zen" },
      })
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
