require('treesitter-context').setup({
    enable = true, -- Enable this plugin (Can be disabled for specific file types)
    throttle = true, -- Throttle the plugin updates for better performance
    max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        default = {
            'class',
            'function',
            'method',
        },
    },
})
