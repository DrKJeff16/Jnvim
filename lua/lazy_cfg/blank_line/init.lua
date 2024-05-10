---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local hl_t = User.types.user.highlight

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local hi = User.highlight.hl

if not exists('ibl') then
	return
end

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

---@type string[]
local highlight = {}
for k, _ in next, hilite do
	if is_str(k) then
		table.insert(highlight, k)
	end
end

---@type string[]
local names = {}
---@type HlOpts[]
local options = {}

for k, v in next, hilite do
	if is_str(k) and k ~= '' then
		table.insert(names, k)
	end
	if is_tbl(v) and not vim.tbl_isempty(v) then
		table.insert(options, v)
	end
end

local apply_hilite = function()
	for k, v in next, hilite do
		hi(k, v)
	end
end

Hooks.register(Hooks.type.HIGHLIGHT_SETUP, apply_hilite)

Hooks.register(Hooks.type.SCOPE_HIGHLIGHT, Hooks.builtin.scope_highlight_from_extmark)

Ibl.setup({
	indent = {
		highlight = highlight,
		char = '•',
	},
	whitespace = {
		highlight = highlight,
		remove_blankline_trail = true,
	},
	scope = { enabled = true },
})

if exists('rainbow-delimiters.setup') then
	vim.g.rainbow_delimiters = { highlight = names }
end
