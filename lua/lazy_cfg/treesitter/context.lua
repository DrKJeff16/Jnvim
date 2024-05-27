---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local hl_t = User.types.user.highlight
local map_t = User.types.user.maps
local kmap = User.maps.kmap

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty
local hi = User.highlight.hl
local nmap = kmap.n
local desc = kmap.desc

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
	min_window_height = 1,
	zindex = 30,
	enable = true,
	max_lines = not empty(vim.opt.scrolloff:get()) and 1 or vim.opt.scrolloff:get(),
}

Context.setup(Options)

---@type HlDict
local hls = {
	['TreesitterContextLineNumberBottom'] = {
		underline = true,
		sp = 'Grey',
	},
}

---@type KeyMapDict
local keys = {
	['<leader>Cn'] = {
		function()
			Context.goto_context(vim.v.count1)
		end,
		desc('Previous Context'),
	},
}

for lhs, v in next, keys do
	v[2] = is_tbl(v[2]) and v[2] or {}
	nmap(lhs, v[1], v[2])
end

for k, v in next, hls do
	hi(k, v)
end
