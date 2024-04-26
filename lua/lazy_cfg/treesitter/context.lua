---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types
local hl_t = User.types.user.highlight
local map_t = User.types.user.maps
local kmap = User.maps.kmap

local exists = Check.exists.module
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
	trim_scope = 'inner',
	line_numbers = false,
	min_window_height = 1,
	zindex = 12,
	enable = true,
	max_lines = 3,
}

Context.setup(Options)

---@type HlDict
local hls = {
	['TreesitterContextLineNumberBottom'] = {
		underline = true,
		sp = 'Grey'
	},
}

---@type KeyMapDict
local keys = {
	['<leader>Cn'] = {
		function()
			local goto_context = Context.go_to_context

			goto_context(vim.v.count1)
		end,
		{ desc = 'Previous Context' },
	},
}

for k, tuple in next, keys do
	nmap(k, tuple[1], tuple[2] or {})
end

for k, v in next, hls do
	hi(k, v)
end
