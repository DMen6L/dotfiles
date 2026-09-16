local dark = {
	name = "rivendell_dark",

	-- Moonlit Rivendell is our interpretation: deep elven-blue stone,
	-- cyan runes and river-light, softened by the gold of distant lamps.
	-- These values are calibrated to the Quickshell bar artwork rather than
	-- attempting to reproduce any single external depiction of Rivendell.
	void = { hex = "#060b1f" },
	mantle = { hex = "#0a1738" },
	bark = { hex = "#0a214f" },
	stone = { hex = "#163d78" },
	moss = { hex = "#4f997b" },
	gold = { hex = "#d8ad62" },
	elven = { hex = "#23c8ec" },
	moonlight = { hex = "#9edcff" },
	parchment = { hex = "#d9e9f7" },
	mist = { hex = "#8fa9c8" },
	ruby = { hex = "#d66b7b" },
}

return {
	dark = function()
		return dark
	end,
}
