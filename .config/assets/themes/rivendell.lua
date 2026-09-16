return {
	id = "rivendell",
	name = "Rivendell",

	palette = {
		name = "rivendell",
		variant = "dark",
	},

	roles = {
		background = "void",
		panel = "bark",
		panelAlt = "stone",
		text = "parchment",
		muted = "mist",
		accent = "gold",
		accentAlt = "elven",
		success = "moss",
		urgent = "ruby",
		ornamentText = "moonlight",
		shadow = "void",
	},

	terminal = {
		background = "background",
		foreground = "text",
		cursor = "accentAlt",
		cursorText = "background",
		selectionBackground = "panelAlt",
		selectionForeground = "text",
		normal = {
			"background", "urgent", "success", "accent",
			"accentAlt", "muted", "accentAlt", "text",
		},
		bright = {
			"panelAlt", "urgent", "success", "accent",
			"accentAlt", "muted", "accentAlt", "text",
		},
	},

	visuals = {
		wallpaper = nil,
		barAssetSet = "rivendell",
	},
}
