---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.highlight')

local User = require('user')
local exists = User.exists
local hl = User.highlight()

if not exists('treesitter-context') then
	return
end

local hi = hl.hl

local Context = require('treesitter-context')
local Config = require('treesitter-context.config')

---@type TSContext.UserConfig
local Options = {
	mode = 'cursor',
	trim_scope = 'outer',
	line_numbers = true,
	min_window_height = 3,
	zindex = 30,
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
