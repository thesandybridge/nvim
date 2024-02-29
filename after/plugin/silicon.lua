require('silicon').setup {
    font = "Fira Mono Nerd Font=34;Noto Color Emoji=34",
    theme = "OneHalfDark",
    background = "#303030",
    to_clipboard = true,
    output = function()
		return "~/Media/Pictures/Screenshots" .. os.date("!%Y-%m-%dT%H-%M-%S") .. "_code.png"
	end,
}
