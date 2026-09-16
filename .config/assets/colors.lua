local selected = require("theme").current()
local theme = selected.colors

theme.id = selected.id
theme.name = selected.name
theme.bg = theme.background
theme.panel_alt = theme.panelAlt
theme.accent_alt = theme.accentAlt

function theme.hex(name)
	assert(theme[name] and theme[name].hex, "unknown theme role: " .. tostring(name))
	return theme[name].hex
end

function theme.rgba(name, alpha)
	local hex = theme.hex(name):sub(2)
	local aa = ("%02x"):format(math.floor(alpha * 255 + 0.5))
	return "rgba(" .. hex .. aa .. ")"
end

return theme
