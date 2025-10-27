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
    opts = {},
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
  },
  {
    'leoluz/nvim-dap-go',
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
  },
}
