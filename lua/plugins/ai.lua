return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    cmd = "Copilot",
    init = function()
      vim.g.copilot_no_tab_map = true
    end,
    keys = {
      {
        "<C-J>",
        'copilot#Accept("\\n")',
        mode = "i",
        expr = true,
        replace_keycodes = false,
        desc = "Accept Copilot suggestion",
      },
    },
  },
}
