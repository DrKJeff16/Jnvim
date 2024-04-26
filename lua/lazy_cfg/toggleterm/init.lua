---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local au_t = User.types.user.autocmd
local maps_t = User.types.user.maps
local exists = Check.exists.module
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
	---@param term Terminal
	---@return number res
	size = function(term)
		local FACTOR = 0.5
		local res = 15
		if term.direction == 'vertical' then
			res = vim.o.columns * FACTOR
		end

		return res
	end,

	autochdir = true,
	hide_numbers = true,
	direction = 'float',
	close_on_exit = true,

	opts = {
		border = 'double',
		title_pos = 'center',
		width = vim.o.columns * 0.55,
	},

	highlights = {
		Normal = { guibg = '#291d3f' },
		NormalFloat = { link = 'Normal' },
		FloatBorder = {
			guifg = '#c5c7a1',
			guibg = '#21443d',
		},
	},
	shade_terminals = true,

	start_in_insert = true,
	insert_mappings = true,
	shell = vim.o.shell,
	auto_scroll = true,

	persist_size = true,
	persist_mode = true,

	float_opts = {
		border = 'double',
		title_pos = 'center',
		zindex = 100,
		winblend = 3,
	},

	winbar = {
		enabled = true,
		---@param term Terminal
		---@return string
		name_formatter = function(term)
			return term.name
		end,
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

-- TODO: Annotate.
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
