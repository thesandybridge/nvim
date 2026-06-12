local function dapui_is_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype:match("^dapui_") then
      return true
    end
  end
  return false
end

local function toggle_dapui()
  local dapui = require("dapui")
  if dapui_is_open() then
    dapui.close()
  else
    dapui.open({ reset = true })
  end
end

return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "DAP continue",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "DAP step into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "DAP step over",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "DAP step out",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.open()
        end,
        desc = "DAP REPL",
      },
      {
        "<leader>dq",
        function()
          local dap = require("dap")
          require("dapui").close()
          dap.repl.close()
          dap.terminate({ all = true, hierarchy = true })
        end,
        desc = "DAP quit",
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = false,
    keys = {
      {
        "<leader>du",
        toggle_dapui,
        desc = "DAP UI toggle",
      },
      {
        "<leader>dU",
        function()
          require("dapui").close()
          require("dap").repl.close()
        end,
        desc = "DAP UI close",
      },
    },
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup({
        floating = {
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
      })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-go").setup()
    end,
  },
}
