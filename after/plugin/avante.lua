require("avante_lib").load()
require("avante").setup(
    {
        ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
        provider = "claude", -- Recommend using Claude
        -- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
        -- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
        -- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
        auto_suggestions_provider = "claude",
        claude = {
            endpoint = "https://api.anthropic.com",
            model = "claude-3-7-sonnet-latest",
            temperature = 0.1,
            max_tokens = 4096,
        },
    }
)
