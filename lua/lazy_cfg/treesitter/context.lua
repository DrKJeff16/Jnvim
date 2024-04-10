---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists
local types = User.types.user.highlight
local hi = User.highlight.hl

if not exists('treesitter-context') then
	return
end

local Context = require('treesitter-context')
local Config = require('treesitter-context.config')

---@type TSContext.UserConfig
local Options = {
	mode = 'topline',
	trim_scope = 'outer',
	line_numbers = false,
	min_window_height = 3,
	zindex = 15,
	enable = true,
	max_lines = 4,
}

Context.setup(Options)

---@type HlPair[]
local hls = {
	{
		name = 'TreesitterContextBottom',
		opts = { underline = true, sp = 'Grey' },
	},
	{
		name = 'TreesitterContextLineNumberBottom',
		opts = { underline = true, sp = 'Grey' },
	},
}

for _, v in next, hls do
	hi(v.name, v.opts)
end
