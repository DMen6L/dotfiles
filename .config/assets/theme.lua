local palettes = require("palettes")
local profiles = require("themes")
local state = require("theme_state")

local Theme = {}

local function resolve_profile(id)
	local profile = profiles[id]
	assert(profile, "unknown theme profile: " .. tostring(id))

	local palette_set = palettes[profile.palette.name]
	assert(palette_set, "unknown palette: " .. tostring(profile.palette.name))

	local variant = palette_set[profile.palette.variant]
	assert(type(variant) == "function", "unknown palette variant: " .. tostring(profile.palette.variant))

	local palette = variant()
	local colors = {}

	for role, palette_key in pairs(profile.roles) do
		local color = palette[palette_key]
		assert(color and color.hex, "missing palette color '" .. palette_key .. "' for role '" .. role .. "'")
		colors[role] = color
	end

	local terminal = {}
	for key, role in pairs(profile.terminal) do
		if key == "normal" or key == "bright" then
			terminal[key] = {}
			for index, terminal_role in ipairs(role) do
				assert(colors[terminal_role], "missing terminal role: " .. terminal_role)
				terminal[key][index] = colors[terminal_role]
			end
		else
			assert(colors[role], "missing terminal role: " .. role)
			terminal[key] = colors[role]
		end
	end

	return {
		id = profile.id,
		name = profile.name,
		colors = colors,
		terminal = terminal,
		visuals = profile.visuals,
	}
end

function Theme.resolve(id)
	return resolve_profile(id)
end

function Theme.current()
	return resolve_profile(state.active)
end

function Theme.profiles()
	return profiles
end

return Theme
