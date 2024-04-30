---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check

local exists = Check.exists.module

if not exists('colorizer') then
	return
end

local Colorizer = require('colorizer')

---@class ColorizerOpts
---@field RGB? boolean
---@field RRGGBB? boolean
---@field RRGGBBAA? boolean
---@field names? boolean
---@field rgb_fn? boolean
---@field hsl_fn? boolean
---@field css? boolean
---@field css_fn? boolean
---@field mode? 'foreground'|'background'

---@type ColorizerOpts
local DEFAULT = {
	RGB      = true,		-- #RGB hex codes
	RRGGBB   = true,		-- #RRGGBB hex codes
	names    = false,			-- "Name" codes like Blue
	RRGGBBAA = true,		-- #RRGGBBAA hex codes
	rgb_fn   = true,		-- CSS rgb() and rgba() functions
	hsl_fn   = false,		-- CSS hsl() and hsla() functions
	css      = false,		-- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
	css_fn   = false,		-- Enable all CSS *functions*: rgb_fn, hsl_fn
	-- Available modes: foreground, background
	mode     = 'background'; -- Set the display mode.
}

local html = DEFAULT
html.mode = 'foreground'
html.css = true
html.css_fn = true
html.hsl_fn = true
html.name = true

local css = html
css.mode = 'background'

Colorizer.setup({
	['*'] = DEFAULT,
	['css'] = css,
	['html'] = html,
	['markdown'] = css,
})
