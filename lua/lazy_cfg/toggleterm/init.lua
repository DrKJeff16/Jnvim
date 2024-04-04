---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.maps')
require('user.types.user.autocmd')

local User = require('user')
local exists = User.exists
local maps = User.maps

local map = maps.map
local tmap = map.t
local nmap = map.n
local imap = map.i

if not exists('toggleterm') then
	return
end

local api = vim.api

local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup

local Tt = require('toggleterm')

Tt.setup({
	size = function(term)
		local FACTOR = 0.4
		if term.direction == 'horizontal' then
			return 15
		elseif term.direction == 'vertical' then
			return vim.o.columns * FACTOR
		end
	end,

	autochdir = true,
	hide_numbers = true,
	direction = 'float',
	close_on_exit = true,

	opts = {
		border = 'double',
		title_pos = 'center',
		width = vim.o.columns * 0.4,
	},
})

---@type AuPair[]
local aus = {
	{
		event = 'TermEnter',
		opts = {
			pattern = { 'term://*toggleterm#*' },
			callback = function()
				tmap('<c-t>', '<CMD>exe v:count1 . "ToggleTerm"<CR>')
			end
		}
	},
}

for _, v in next, aus do
	au(v.event, v.opts)
end

---@class ApiMapArgs
---@field lhs string
---@field rhs string
---@field opts? ApiMapOpts

---@class ApiMapTbl
---@field n? ApiMapArgs[]
---@field i? ApiMapArgs[]
---@field t? ApiMapArgs[]
---@field v? ApiMapArgs[]
local map_tbl = {
	n = {
		{
			lhs = '<c-t>',
			rhs = '<CMD>exe v:count1 . "ToggleTerm"<CR>',
			opts = { desc = 'Toggle \'ToggleTerm\'' },
		},
		{
			lhs = '<leader>Tt',
			rhs = '<CMD>exe v:count1 . "ToggleTerm"<CR>',
			opts = { desc = 'Toggle \'ToggleTerm\'' },
		},
	},
	i = {
		{
			lhs = '<c-t>',
			rhs = '<Esc><CMD>exe v:count1 . "ToggleTerm"<CR>',
			opts = { desc = 'Toggle \'ToggleTerm\'' },
		},
	},
	t = {},
}

for k, v in next, map_tbl do
	for _, args in next, v do
		map[k](args.lhs, args.rhs, args.opts or {})
	end
end
