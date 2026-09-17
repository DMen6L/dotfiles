return {
	id = "rivendell",
	name = "Rivendell",

	palette = {
		name = "rivendell",
		variant = "dark",
	},

	roles = {
		background = "background",
		panel = "surface_container",
		panelAlt = "surface_container_high",
		text = "on_surface",
		muted = "on_surface_variant",
		accent = "primary",
		accentAlt = "base0d",
		success = "base0b",
		urgent = "error",
		ornamentText = "on_primary_container",
		shadow = "shadow",
		promptIdentity = "on_primary",
		promptDirectory = "primary_container",
	},

	terminal = {
		background = "background",
		foreground = "text",
		cursor = "accentAlt",
		cursorText = "background",
		selectionBackground = "panelAlt",
		selectionForeground = "text",
		normal = {
			"base00", "base08", "base0b", "base0a",
			"base0d", "base0e", "base0c", "base05",
		},
		bright = {
			"base03", "base08", "base0b", "base0a",
			"base0d", "base0e", "base0c", "base07",
		},
	},

	visuals = {
		wallpaper = nil,
		barAssetSet = "rivendell",
	},
}
