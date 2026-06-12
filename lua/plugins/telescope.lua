-- Telescope and related plugins
return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = "Telescope",
    keys = {
      { "<C-f>", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<C-p>", function() require("telescope.builtin").git_files() end, desc = "Git files" },
      { "<C-c>", function() require("telescope.builtin").git_commits() end, desc = "Git commits" },
      { "<C-b>", function() require("telescope.builtin").git_branches() end, desc = "Git branches" },
      { "<C-g>", function() require("telescope.builtin").grep_string() end, desc = "Grep word" },
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
      { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent files" },
      { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics" },
      { "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Document symbols" },
      {
        "<leader>vh",
        function()
          require("telescope.builtin").help_tags({
            previewer = true,
            layout_config = {
              width = 0.9,
              preview_width = 0.6,
            },
          })
        end,
        desc = "Help tags",
      },
    },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob",
            "!.git",
          },
        },
        extensions = {
          ["ui-select"] = require("telescope.themes").get_dropdown({}),
        },
      })

      telescope.load_extension("ui-select")
    end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },
}
