local palettes = require("palettes")
local active = palettes.catppuccin.mocha()

return {
	get = function()
		return active
	end,

	set = function(theme)
		active = theme
	end,
}
