---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require("user")
local Check = User.check
local types = User.types.toggleterm
local map = User.maps.map

local empty = Check.value.empty
local is_tbl = Check.value.is_tbl
local exists = Check.exists.module
local tmap = map.t
local nmap = map.n
local imap = map.i

if not exists("toggleterm") then
	return
end

local api = vim.api

local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup

local TT = require("toggleterm")

local FACTOR = vim.o.columns * 0.55

TT.setup({
	---@type fun(term: Terminal): number
	size = function(term)
		local res = 30

		if term.direction == "vertical" then
			res = FACTOR
		end

		return res
	end,

	autochdir = true,
	hide_numbers = true,
	direction = "float",
	close_on_exit = true,

	opts = {
		border = "none",
		title_pos = "center",
		width = FACTOR,
	},

	highlights = {
		Normal = { guibg = "#291d3f" },
		NormalFloat = { link = "Normal" },
		FloatBorder = {
			guifg = "#c5c7a1",
			guibg = "#21443d",
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
		border = "single",
		title_pos = "center",
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
})

---@type AuPair[]
local aus = {
	{
		event = "TermEnter",
		opts = {
			pattern = { "term://*toggleterm#*" },
			callback = function()
				tmap("<c-t>", '<CMD>exe v:count1 . "ToggleTerm"<CR>')
			end,
		},
	},
}

for _, v in next, aus do
	au(v.event, v.opts)
end

-- TODO: Annotate.
local map_tbl = {
	n = {
		{
			lhs = "<c-t>",
			rhs = '<CMD>exe v:count1 . "ToggleTerm"<CR>',
			opts = { desc = "Toggle 'ToggleTerm'" },
		},
		{
			lhs = "<leader>Tt",
			rhs = '<CMD>exe v:count1 . "ToggleTerm"<CR>',
			opts = { desc = "Toggle 'ToggleTerm'" },
		},
	},
	i = {
		{
			lhs = "<c-t>",
			rhs = '<Esc><CMD>exe v:count1 . "ToggleTerm"<CR>',
			opts = { desc = "Toggle 'ToggleTerm'" },
		},
	},
	t = {},
}

for k, v in next, map_tbl do
	if is_tbl(v) and not empty(v) then
		for _, args in next, v do
			map[k](args.lhs, args.rhs, args.opts or {})
		end
	end
end
