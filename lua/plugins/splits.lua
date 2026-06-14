return {
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    opts = {
      multiplexer_integration = "tmux",
      disable_multiplexer_nav_when_zoomed = true,
      ignored_filetypes = {
        "oil",
        "Trouble",
        "lazy",
        "mason",
      },
    },
    keys = {
      {
        "<M-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "Move left",
      },
      {
        "<M-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "Move down",
      },
      {
        "<M-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "Move up",
      },
      {
        "<M-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "Move right",
      },
    },
  },
}
