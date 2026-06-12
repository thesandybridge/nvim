-- Editor enhancement plugins
return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
      { "<leader>pv", "<cmd>Oil<cr>", desc = "Open file browser" },
    },
    opts = {
      default_file_explorer = true,
      columns = {
        "permissions",
        "size",
        "mtime",
        "icon",
      },
      delete_to_trash = true,
      skip_confirm_for_simple_edits = false,
      watch_for_changes = true,
      constrain_cursor = "name",
      keymaps = {
        ["<CR>"] = "actions.select",
        ["l"] = "actions.select",
        ["o"] = {
          callback = function()
            local oil = require("oil")
            local entry = oil.get_cursor_entry()
            local dir = oil.get_current_dir()

            if entry and dir then
              require("thesbx.external_open").open(dir .. entry.name)
            end
          end,
          desc = "Open externally",
        },
        ["h"] = "actions.parent",
        ["q"] = "actions.close",
        ["r"] = "actions.refresh",
        ["g."] = "actions.toggle_hidden",
        ["gs"] = "actions.change_sort",
        ["<C-p>"] = "actions.preview",
        ["<C-s>"] = false,
        ["<C-h>"] = false,
        ["<C-t>"] = false,
      },
      view_options = {
        show_hidden = true,
        natural_order = true,
        case_insensitive = true,
        sort = {
          { "type", "asc" },
          { "name", "asc" },
        },
      },
      win_options = {
        wrap = false,
        signcolumn = "no",
        foldcolumn = "0",
        list = false,
        conceallevel = 3,
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>a",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon add file",
      },
      {
        "<C-e>",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon menu",
      },
      {
        "<C-h>",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon file 1",
      },
      {
        "<C-t>",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon file 2",
      },
      {
        "<C-n>",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "Harpoon file 3",
      },
      {
        "<leader>4",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "Harpoon file 4",
      },
      {
        "<C-S-P>",
        function()
          require("harpoon"):list():prev()
        end,
        desc = "Harpoon previous",
      },
      {
        "<C-S-N>",
        function()
          require("harpoon"):list():next()
        end,
        desc = "Harpoon next",
      },
    },
    opts = {},
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup({
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
        },
      })
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
    keys = {
      { [[<c-\>]], "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    },
    opts = {
      size = 20,
      direction = "float",
      start_in_insert = true,
      float_opts = {
        border = "curved",
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*",
        callback = function()
          local map = function(lhs, rhs)
            vim.keymap.set("t", lhs, rhs, { buffer = true })
          end

          map("<esc>", [[<C-\><C-n>]])
          map("jk", [[<C-\><C-n>]])
          map("<C-h>", [[<Cmd>wincmd h<CR>]])
          map("<C-j>", [[<Cmd>wincmd j<CR>]])
          map("<C-k>", [[<Cmd>wincmd k<CR>]])
          map("<C-l>", [[<Cmd>wincmd l<CR>]])
        end,
      })
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Zen mode" },
    },
    opts = {
      plugins = {
        twilight = { enabled = true },
      },
    },
  },
  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    keys = {
      { "<leader>tw", "<cmd>Twilight<cr>", desc = "Toggle focus dimming" },
    },
    opts = {
      dimming = {
        alpha = 0.35,
        color = { "Normal", "#ffffff" },
        term_bg = "#000000",
        inactive = false,
      },
      context = 8,
      treesitter = true,
      expand = {
        "function",
        "method",
        "table",
        "if_statement",
        "for_statement",
        "while_statement",
        "match_expression",
      },
      exclude = {
        "oil",
        "TelescopePrompt",
        "Trouble",
        "help",
        "lazy",
        "mason",
      },
    },
  },
}
