---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists
local types = User.types.user.highlight
local hi = User.highlight.hl

if not exists('ibl') then
	return
end

local api = vim.api
local let = vim.g

local Ibl = require('ibl')
local Hooks = require('ibl.hooks')

---@type HlDict
local hilite = {
	['RainbowRed'] = { fg = '#E06C75' },
	['RainbowYellow'] = { fg = '#E5C07B' },
	['RainbowBlue'] = { fg = '#61AFEF' },
	['RainbowOrange'] = { fg = '#D19A66' },
	['RainbowGreen'] = { fg = '#98C379' },
	['RainbowViolet'] = { fg = '#C678DD' },
	['RainbowCyan'] = { fg = '#56B6C2' },
}
local highlight = {
	'RainbowRed',
	'RainbowYellow',
	'RainbowBlue',
	'RainbowOrange',
	'RainbowGreen',
	'RainbowViolet',
	'RainbowCyan',
}

---@type string[]
local names = {}
---@type HlOpts[]
local options = {}

for k, v in next, hilite do
	table.insert(names, k)
	table.insert(options, v)
end
local bg_hl = {
	'CursorColumn',
	'Whitespace'
}

Hooks.register(Hooks.type.HIGHLIGHT_SETUP, function()
	for k, v in next, hilite do
		hi(k, v)
	end
end)

Hooks.register(Hooks.type.SCOPE_HIGHLIGHT, Hooks.builtin.scope_highlight_from_extmark)

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

if exists('rainbow-delimiters.setup') then
	let.rainbow_delimiters = { highlight = names }
end
