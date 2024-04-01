---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types')

local User = require('user')
local exists = User.exists

if not exists('treesitter-context') then
	return
end

local api = vim.api

local hi = api.nvim_set_hl

local Context = require('treesitter-context')

Context.setup({})

---@class TSHlArr
---@field name string
---@field opts HlOpts

---@type TSHlArr[]
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

---@param hi_tbl TSHlArr[]
local hl = function(hi_tbl)
	for _, t in next, hi_tbl do
		hi(0, t.name, t.opts)
	end
end

hl(hls)
