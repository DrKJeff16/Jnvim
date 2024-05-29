---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.toggleterm
local map = User.maps.map
local WK = User.maps.wk

local empty = Check.value.empty
local is_tbl = Check.value.is_tbl
local exists = Check.exists.module
local desc = map.desc

if not exists('toggleterm') then
	return
end

local au = vim.api.nvim_create_autocmd

local TT = require('toggleterm')

local FACTOR = vim.opt.columns:get() * 0.85

local Opts = {
	---@type fun(term: Terminal): number
	size = function(term)
		if term.direction == 'vertical' then
			return vim.opt.columns:get() * 0.65
		end

		return FACTOR
	end,

	autochdir = true,
	hide_numbers = true,
	direction = 'float',
	close_on_exit = true,

	opts = {
		border = 'single',
		title_pos = 'center',
		width = FACTOR,
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
		border = 'single',
		title_pos = 'center',
		zindex = 100,
		winblend = 3,
	},

	winbar = {
		enabled = true,

		---@type fun(term: Terminal): string
		name_formatter = function(term)
			return term.name
		end,
	},
}

TT.setup(Opts)

---@type AuDict
local aus = {
	['TermEnter'] = {
		pattern = { 'term://*toggleterm#*' },
		callback = function()
			map.t('<c-t>', '<CMD>exe v:count1 . "ToggleTerm"<CR>')
		end,
	},
}

for event, v in next, aus do
	au(event, v)
end

---@type table<'n'|'i', ApiMapDict>
local Keys = {
	n = {
		['<c-t>'] = {
			'<CMD>exe v:count1 . "ToggleTerm"<CR>',
			desc('Toggle'),
		},
		['<leader>Tt'] = {
			'<CMD>exe v:count1 . "ToggleTerm"<CR>',
			desc('Toggle'),
		},
	},
	i = {
		['<c-t>'] = {
			'<Esc><CMD>exe v:count1 . "ToggleTerm"<CR>',
			desc('Toggle'),
		},
	},
}

---@type table<MapModes, RegKeysNamed>
local Names = {
	n = { ['<leader>T'] = { name = '+Toggleterm' } },
}

for mode, t in next, Keys do
	if WK.available() then
		if is_tbl(Names[mode]) and not empty(Names[mode]) then
			WK.register(Names[mode], { mode = mode })
		end
		WK.register(WK.convert_dict(t), { mode = mode })
	else
		for lhs, v in next, t do
			v[2] = is_tbl(v[2]) and v[2] or {}
			map[mode](lhs, v[1], v[2])
		end
	end
end
