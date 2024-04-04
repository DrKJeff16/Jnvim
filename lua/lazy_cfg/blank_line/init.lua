---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.highlight')

local User = require('user')
local exists = User.exists

if not exists('ibl') then
	return
end

local api = vim.api
local let = vim.g

local hi = User.highlight().hl

local Ibl = require('ibl')
local hooks = require('ibl.hooks')

---@type HlDict
local highlight = {
	['RainbowRed'] = { fg = '#E06C75' },
	['RainbowYellow'] = { fg = '#E5C07B' },
	['RainbowBlue'] = { fg = '#61AFEF' },
	['RainbowOrange'] = { fg = '#D19A66' },
	['RainbowGreen'] = { fg = '#98C379' },
	['RainbowViolet'] = { fg = '#C678DD' },
	['RainbowCyan'] = { fg = '#56B6C2' },
}
---@type string[]
local names = {}
---@type HlOpts[]
local options = {}

for k, v in next, highlight do
	table.insert(names, k)
	table.insert(options, v)
end
local bg_hl = {
	'CursorColumn',
	'Whitespace'
}

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	for k, v in next, highlight do
		hi(k, v)
	end
end)

if exists('rainbow-delimiters.setup') then
	local path = 'lazy_cfg.blank_line.rainbow_delims'

	if exists('lazy_cfg.blank_line.rainbow_delims') then
		require('lazy_cfg.blank_line.rainbow_delims').setup(names, options)
	else
		let.rainbow_delimiters = { highlight = names }
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
