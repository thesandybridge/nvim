-- Debug Adapter Protocol (DAP) plugins
return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>db", desc = "DAP breakpoint" },
      { "<leader>dc", desc = "DAP continue" },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      { "<leader>du", desc = "DAP UI" },
    },
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("dapui").setup()
    end,
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
  {
    'leoluz/nvim-dap-go',
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require('dap-go').setup()
    end,
  },
}
