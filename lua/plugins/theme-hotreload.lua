-- Omarchy theme hot-reload integration
-- This allows the theme to change dynamically when you switch system themes
return {
  {
    name = "theme-hotreload",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 999,
    config = function()
      -- Only setup hot-reload if Omarchy is available
      local omarchy_theme_path = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
      local has_omarchy = vim.fn.filereadable(omarchy_theme_path) == 1

      if not has_omarchy then
        return
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyReload",
        callback = function()
          -- Unload the theme module
          package.loaded["plugins.theme"] = nil

          vim.schedule(function()
            local ok, theme_spec = pcall(dofile, omarchy_theme_path)
            if not ok or not theme_spec then
              return
            end

            -- Find the colorscheme to apply
            local colorscheme_to_apply = nil

            for _, spec in ipairs(theme_spec) do
              if spec.opts and spec.opts.colorscheme then
                colorscheme_to_apply = spec.opts.colorscheme
                break
              end
            end

            if not colorscheme_to_apply then
              return
            end

            -- Clear all highlight groups before applying new theme
            vim.cmd("highlight clear")
            if vim.fn.exists("syntax_on") then
              vim.cmd("syntax reset")
            end

            -- Reset background to default
            vim.o.background = "dark"

            vim.defer_fn(function()
              -- Apply the colorscheme
              pcall(vim.cmd.colorscheme, colorscheme_to_apply)

              -- Force redraw to update all UI elements
              vim.cmd("redraw!")

              -- Trigger UI updates for various plugins
              vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
            end, 50)
          end)
        end,
      })
    end,
  },
}
