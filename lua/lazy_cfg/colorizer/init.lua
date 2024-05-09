---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.colorizer

local exists = Check.exists.module

if not exists('colorizer') then
	return
end

local Colorizer = require('colorizer')

---@type ColorizerOpts
local DEFAULT = {
	RGB      = false,		-- #RGB hex codes
	RRGGBB   = true,		-- #RRGGBB hex codes
	names    = false,			-- "Name" codes like Blue
	RRGGBBAA = true,		-- #RRGGBBAA hex codes
	rgb_fn   = false,		-- CSS rgb() and rgba() functions
	hsl_fn   = false,		-- CSS hsl() and hsla() functions
	css      = false,		-- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
	css_fn   = false,		-- Enable all CSS *functions*: rgb_fn, hsl_fn
	-- Available modes: foreground, background
	mode     = 'background', -- Set the display mode.
}
function DEFAULT.new()
	local self = setmetatable({}, { __index = DEFAULT })

	for k, _ in next, DEFAULT do
		if k ~= '__index' then
			self[k] = DEFAULT[k]
		end
	end

	return self
end


local Html = DEFAULT.new()
Html.css = true
Html.css_fn = true
Html.hsl_fn = true
Html.rgb_fn = true
Html.name = true

local Lua = DEFAULT.new()
Lua.names = true
Lua.rgb = true

Colorizer.setup({
	['*'] = DEFAULT.new(),
	['css'] = Html,
	['html'] = Html,
	['markdown'] = Html,
	['lua'] = Lua,
})
