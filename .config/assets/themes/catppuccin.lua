-- Both flavors share functional colors; their native palette values differ.
return function(variant)
	assert(variant == "mocha" or variant == "latte", "unsupported Catppuccin flavor: " .. tostring(variant))
	local light = variant == "latte"
	local id = "catppuccin-" .. variant
	return {
		id = id,
		name = "Catppuccin " .. (light and "Latte" or "Mocha"),

		palette = {
			name = "catppuccin",
			variant = variant,
		},

		roles = {
			background = "base",
			panel = "mantle",
			panelAlt = "surface0",
			text = "text",
			muted = "subtext0",
			accent = "mauve",
			accentAlt = "lavender",
			widgetBorder = "surface2",
			success = "green",
			warning = "yellow",
			info = "sapphire",
			date = "peach",
			time = "lavender",
			language = "pink",
			network = "sapphire",
			audio = "teal",
			runtimeNode = "green",
			runtimePython = "yellow",
			runtimeRust = "peach",
			runtimeGo = "sky",
			runtimeLua = "blue",
			urgent = "red",
			ornamentText = "rosewater",
			shadow = light and "text" or "crust",
			promptIdentity = light and "surface0" or "mauve",
			promptIdentityText = light and "text" or "base",
			promptDirectory = light and "mantle" or "peach",
			promptDirectoryText = light and "text" or "base",
		},

		terminal = {
			background = "background",
			foreground = "text",
			cursor = "rosewater",
			cursorText = "background",
			selectionBackground = "rosewater",
			selectionForeground = "base",
			normal = {
				light and "subtext1" or "surface1", "red", "green", "yellow",
				"blue", "pink", "teal", light and "surface2" or "subtext1",
			},
			bright = {
				light and "subtext0" or "surface2", "red", "green", "yellow",
				"blue", "pink", "teal", light and "surface1" or "subtext0",
			},
		},

		visuals = {
			wallpaper = nil,
			barAssetSet = "rivendell",
			nvimColorscheme = id,
			kittyThemeFile = not light and "current-theme.conf" or nil,
			gtkTheme = id .. "-mauve-standard+default",
			gtkColorScheme = light and "prefer-light" or "prefer-dark",
			fastfetchSwatches = {
				{ "crust", "mantle", "base", "surface0", "surface1", "surface2", "subtext0", "text" },
				{ "rosewater", "flamingo", "pink", "mauve", "red", "maroon", "peach",
					"yellow", "green", "teal", "sky", "sapphire", "blue", "lavender" },
			},
		},
	}
end
