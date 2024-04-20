---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local types = User.types
local hl_t = User.types.user.highlight
local map_t = User.types.user.maps
local exists = User.check.exists.module
local kmap = User.maps.kmap

local hi = User.highlight.hl

local nmap = kmap.n

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
		name = 'TreesitterContextLineNumberBottom',
		opts = { underline = true, sp = 'Grey' },
	},
}

local goto_context = Context.go_to_context

---@type KeyMapDict
local keys = {
	['<leader>Cn'] = {
		function()
			goto_context(vim.v.count1)
		end,
		{ desc = 'Previous Context' },
	},
}

for k, tuple in next, keys do
	nmap(k, tuple[1], tuple[2] or {})
end

for _, v in next, hls do
	hi(v.name, v.opts)
end
