---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('ibl') then
	return
end

local api = vim.api

local hi = api.nvim_set_hl

local Mod = 'lazy_cfg.blank_line.'

Ibl = require('ibl')
local hooks = require('ibl.hooks')

local highlight = {
	"RainbowRed",
	"RainbowYellow",
	"RainbowBlue",
	"RainbowOrange",
	"RainbowGreen",
	"RainbowViolet",
	"RainbowCyan",
}
local bg_hl = {
	'CursorColumn',
	'Whitespace'
}

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	hi(0, "RainbowRed", { fg = "#E06C75" })
	hi(0, "RainbowYellow", { fg = "#E5C07B" })
	hi(0, "RainbowBlue", { fg = "#61AFEF" })
	hi(0, "RainbowOrange", { fg = "#D19A66" })
	hi(0, "RainbowGreen", { fg = "#98C379" })
	hi(0, "RainbowViolet", { fg = "#C678DD" })
	hi(0, "RainbowCyan", { fg = "#56B6C2" })
end)

if exists('rainbow-delimiters.setup') then
	local full_path = Mod..'rainbow_delims'
	if exists(full_path) then
		require(full_path).setup(highlight)
	else
		vim.g.rainbow_delimiters = { highlight = highlight }
	end
end

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

Ibl.setup({
	indent = {
		highlight = highlight,
		char = '•',
	},
	whitespace = {
		highlight = highlight,
		remove_blankline_trail = false,
	},
	scope = { enabled = true },
})
